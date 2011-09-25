using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Utility;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface INewsItemManager : IManager<NewsItem>
    {
        //Consider adding this to IManager...
        IList<NewsItemSummary> GetSummariesByIds(IList<Guid> ids);
        IPageOfList<NewsItemSummary> GetNewsItemSummaries(int pageSize, int currentPageIndex);
        IPageOfList<NewsItemSummary> GetNewsItemSummariesBySite(int pageSize, int currentPageIndex, Guid siteId);
        IPageOfList<NewsItemSummary> GetPublishedNewsItemSummariesBySite(int pageSize, int currentPageIndex, Guid siteId);
        NewsItem SetNewsItemImage(NewsItem newsitem, byte[] data, UserCredentials userCredentials);
        
        /// <summary>
        /// Will not return deleted newsitems
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        IPageOfList<NewsItemSummary> GetNewsItemSummariesByOwner(int pageSize, int currentPageIndex, Guid userId);
    }
}
