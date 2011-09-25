using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Web.Models;
using ListenTo.Shared.Utility;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Web.ModelBinders;
using ListenTo.Web.Security;
using ListenTo.Shared.Validation;
using ListenTo.Web.Helpers;

namespace ListenTo.Web.Controllers
{
    public class NewsItemController : ListenToController
    {
        public INewsItemManager NewsItemManager { get; set; }
        public ICommentManager CommentManager { get; set; }
        public IUserProfileManager UserProfileManager { get; set; }
       

        public ActionResult Index(Guid id)
        {
            NewsItemIndexViewModel newsItemIndexViewModel = new NewsItemIndexViewModel();

            NewsItem newsItem = NewsItemManager.GetByID(id);

            if (newsItem.IsDeleted == true)
            {
                throw new Exception("Cannot view deleted newsitem");
            }

            //Get the comments
            IList<CommentSummary> comments = CommentManager.GetCommentSummaries(10, 0, newsItem.ID);

            //Get the Authors Profile
            UserProfile authorsUserProfile = UserProfileManager.GetByID(newsItem.OwnerID);

            newsItemIndexViewModel.Comments = comments;
            newsItemIndexViewModel.NewsItem = newsItem;
            newsItemIndexViewModel.AuthorUserProfile = authorsUserProfile;
            newsItemIndexViewModel.AddCommentViewModel = new AddCommentViewModel();
            newsItemIndexViewModel.AddCommentViewModel.ContentTargetId = newsItem.ID;
            newsItemIndexViewModel.AddCommentViewModel.ContentType = ListenTo.Shared.Enums.ContentType.NEWSITEM;
            return View(newsItemIndexViewModel);
        }


        public ActionResult List(int? page)
        {
            if (page == null)
            {
                page = 0;
            }
            
            ListenTo.Shared.DO.Site site = this.GetSite();
            NewsItemListViewModel newsItemListViewModel = new NewsItemListViewModel();
            newsItemListViewModel.NewsItemSummaries = (PageOfList<NewsItemSummary>)NewsItemManager.GetPublishedNewsItemSummariesBySite(10, page.Value, site.ID);
            return View(newsItemListViewModel);
        }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Add()
        {
            NewsItemEditViewModel newsItemEditViewModel = new NewsItemEditViewModel();
            newsItemEditViewModel.UploadImagePopupViewModel = new UploadImagePopupViewModel();
            return View(newsItemEditViewModel);
        }

        [Authorize]
        [AcceptVerbs("POST")]
        [ValidateInput(false)]
        public ActionResult Add([Bind(Prefix="NewsItem")]NewsItem newsItem, UploadImagePopupViewModel image)
        {
            NewsItemEditViewModel newsItemEditViewModel = new NewsItemEditViewModel();
            newsItemEditViewModel.NewsItem = newsItem;
            newsItemEditViewModel.UploadImagePopupViewModel = image;
            return ManageNewsItem(newsItemEditViewModel);
        }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Edit(Guid id)
        {
            NewsItem newsItem = NewsItemManager.GetByID(id);
            PrepareImageMetaData(newsItem);
            NewsItemEditViewModel newsItemEditViewModel = new NewsItemEditViewModel();
            newsItemEditViewModel.NewsItem = newsItem;
            newsItemEditViewModel.UploadImagePopupViewModel = new UploadImagePopupViewModel();
            newsItemEditViewModel.UploadImagePopupViewModel.ImageMetaData = newsItem.Image;
            return View(newsItemEditViewModel);
        }

        [Authorize]
        [AcceptVerbs("POST")]
        [ValidateInput(false)]  
        public ActionResult Edit(Guid id, FormCollection formCollection)
        {
            NewsItem newsItem = NewsItemManager.GetByID(id);
            UpdateModel<NewsItem>(newsItem, "NewsItem");

            //This object represents a file the user has uploaded...
            UploadImagePopupViewModel uploadImagePopupViewModel = new UploadImagePopupViewModel();
            UpdateModel<UploadImagePopupViewModel>(uploadImagePopupViewModel);
            
            NewsItemEditViewModel newsItemEditViewModel = new NewsItemEditViewModel();
            newsItemEditViewModel.NewsItem = newsItem;
            newsItemEditViewModel.UploadImagePopupViewModel = uploadImagePopupViewModel;

            return ManageNewsItem(newsItemEditViewModel);
        }

        /// <summary>
        /// The NewsItemEditViewModel is passed through since this is the model which we need to pass back to the view :)
        /// </summary>
        /// <param name="newsItemEditViewModel"></param>
        /// <returns></returns>
        private ActionResult ManageNewsItem(NewsItemEditViewModel newsItemEditViewModel)
        {
            IListenToUser user = (IListenToUser)this.HttpContext.User;
            NewsItem newsItem = newsItemEditViewModel.NewsItem;
            UploadImagePopupViewModel image = newsItemEditViewModel.UploadImagePopupViewModel;

            try
            {
                //For time being we only want to be able to add news to ListenToManchester
                newsItem.TargetSites = new List<Site>();
                newsItem.TargetSites.Add(this.GetSite());
                //Until we've decided how publishing will work...
                newsItem.IsPublished = true;

                if (image.ImageMetaData != null)
                {
                    //We have an image!
                    //Assign it to the newsitem
                    //The previous image wont be deleted, but we dont really care at this point!
                    newsItem.Image = image.ImageMetaData;
                    
                }

                NewsItemManager.Save(newsItem, user.UserCredentials);
            }
            catch (ValidationException e)
            {
                e.AddToModelState(ViewData.ModelState, "NewsItem");
            }

            //If the model isnt valid
            if (!ViewData.ModelState.IsValid)
            {
                return View(newsItemEditViewModel);
            }

            return RedirectToNewsItem(newsItem);
        }

        private void PrepareImageMetaData(NewsItem newsItem)
        {
            //Did the user upload an image?
            //If so, we want to display it...
            if (newsItem.Image != null)
            {
                ImageMetaData imageMetaData = (ImageMetaData)newsItem.Image;
                ViewData["Image"] = imageMetaData;
            }
        }

    }
}
