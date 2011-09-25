using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Utility;
using ListenTo.Shared.DO;
using ListenTo.Shared.Enums;
using ListenTo.Shared.DTO;

namespace ListenTo.Core.Managers
{
    public class NewsItemManager : BaseManager, INewsItemManager
    {
        public IActionsManager ActionsManager { get; set; }
        public IImageManager ImageManager { get; set; }


        public NewsItemManager()
        {
            string s = string.Empty;
        }

        #region INewsItemManager Members

        public IPageOfList<ListenTo.Shared.DTO.NewsItemSummary> GetNewsItemSummariesBySite(int pageSize, int currentPageIndex, Guid siteId)
        {
           return this.Repository.GetNewsItemSummaryBySite(pageSize,currentPageIndex,siteId);
        }

        public IPageOfList<ListenTo.Shared.DTO.NewsItemSummary> GetNewsItemSummaries(int pageSize, int currentPageIndex)
        {
            throw new NotImplementedException();
        }

        public IPageOfList<ListenTo.Shared.DTO.NewsItemSummary> GetPublishedNewsItemSummariesBySite(int pageSize, int currentPageIndex, Guid siteId)
        {
            return this.Repository.GetPublishedNewsItemSummaryBySite(pageSize, currentPageIndex, siteId);
        }

        public IList<ListenTo.Shared.DTO.NewsItemSummary> GetSummariesByIds(IList<Guid> ids)
        {
            return this.Repository.GetPublishedNewsItemSummaryByIds(ids);
        }

        public NewsItem SetNewsItemImage(NewsItem newsitem, byte[] data, UserCredentials userCredentials)
        {
            ListenTo.Shared.DO.Image image = ImageManager.HandleUploadedImage(data, userCredentials);
            newsitem.Image = image;
            this.Save(newsitem, userCredentials);
            return newsitem;
        }

        public IPageOfList<NewsItemSummary> GetNewsItemSummariesByOwner(int pageSize, int currentPageIndex, Guid userId)
        {
            return this.Repository.GetNewsItemSummariesByOwner(pageSize, currentPageIndex, userId);
        }
   
        #endregion

        #region IManager<NewsItem> Members

        public ListenTo.Shared.DO.NewsItem GetByID(Guid id)
        {
            return this.Repository.GetNewsItemById(id);
        }

        public ListenTo.Shared.DO.NewsItem Save(ListenTo.Shared.Interfaces.DO.IDO dO, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            NewsItem newsItem = (NewsItem)dO;
            
            this.CheckOwnership(newsItem, userCredentials);

            bool isValid = ValidationRunner.Validate(newsItem, userCredentials);

            bool isNew = this.CheckIsNew(newsItem, userCredentials);

            newsItem =  this.Repository.SaveNewsItem(newsItem);

            if (isNew)
            {
                ListenTo.Shared.DO.Action action = new ListenTo.Shared.DO.Action();
                action.ActionType = ActionType.ADDED_A_NEWS_ITEM;
                action.ContentType = ContentType.NEWSITEM;
                action.ContentID = newsItem.ID;

                foreach (Site site in newsItem.TargetSites)
                {
                    action.TargetSites.Add(site.ID);
                }

                action.OwnerID = newsItem.OwnerID;
                ActionsManager.AddAction(action, userCredentials);
            }

            return newsItem;
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            NewsItem newsItem = this.GetByID(id);
            if (newsItem != null)
            {
                this.CheckOwnership(newsItem, userCredentials);
                newsItem.IsDeleted = true;
                this.Save(newsItem, userCredentials);
            }
            else
            {
                throw new Exception("The newsitem you are trying to delete does not exist");
            }     
        }

        #endregion

    }
}
