using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Web.Helpers;
using ListenTo.Web.ModelBinders;
using ListenTo.Web.Security;
using ListenTo.Shared.DTO;
using ListenTo.Shared.Validation;
using ListenTo.Web.Models;
using ListenTo.Shared.Utility;

namespace ListenTo.Web.Controllers
{
    public class ArtistController : ListenToController
    {
        //public IArtistManager ArtistManager { get; set; }
        public ITrackManager TrackManager { get; set; }
        public IImageManager ImageManager { get; set; }
        public ICommentManager CommentManager { get; set; }
        public IValidationHelper ArtistValidationHelper { get; set; }
        public IUserProfileManager UserProfileManager { get; set; }
        public IRelationshipManager RelationshipManager { get; set; }

        public ActionResult Index(string name)
        {
            UserCredentials userCredentials = this.GetUserCredentials();

            ArtistIndexViewModel artistIndexViewModel = new ArtistIndexViewModel();

            Artist artist = ArtistManager.GetByProfileAddress(name);

            //Get the artists next gig
            IList<Gig> gigs = GigManager.GetUpcomingGigsWithArtist(1, 0, artist.ID);
            Gig nextGig = null;
            
            if (gigs.Count > 0)
            {
                nextGig = gigs[0];
            }

            //Get the artists comments
            IList<CommentSummary> comments = CommentManager.GetCommentSummaries(10, 0, artist.ID);

            //Get the Authors Profile
            UserProfile authorsUserProfile = UserProfileManager.GetByID(artist.OwnerID);

            artistIndexViewModel.Comments = comments;
            artistIndexViewModel.Artist = artist;
            artistIndexViewModel.NextGig = nextGig;
            artistIndexViewModel.AuthorsUserProfile = authorsUserProfile;
            artistIndexViewModel.IsUserFanOfArtist =  IsUserFanOfArtist(artist);

            FansPartialViewModel fansPartialViewModel = new FansPartialViewModel();
            fansPartialViewModel.ArtistFanRelationshipSummaries = RelationshipManager.GetArtistFanRelationshipSummaryForArtist(userCredentials, 10, 0, artist.ID);
            fansPartialViewModel.NumberPerRow = 5;

            artistIndexViewModel.FansPartialViewModel = fansPartialViewModel;
            artistIndexViewModel.AddCommentViewModel = new AddCommentViewModel();
            artistIndexViewModel.AddCommentViewModel.ContentTargetId = artist.ID;
            artistIndexViewModel.AddCommentViewModel.ContentType = ListenTo.Shared.Enums.ContentType.ARTIST;
            return View(artistIndexViewModel);
        }

        private bool IsUserFanOfArtist(Artist artist) {
            
            bool isUserFanOfArtist = false;
            if(this.HttpContext.User.Identity.IsAuthenticated) {
                IListenToUser user = (IListenToUser)this.HttpContext.User;
                isUserFanOfArtist = RelationshipManager.IsUserFanOfArtist(user.UserCredentials, artist.ID,user.UserId);
            }
            return isUserFanOfArtist;
        }

        public ActionResult List(string style, int? page)
        {
            if (page == null)
            {
                page = 0;
            }

            ArtistListViewModel artistListViewModel = new ArtistListViewModel();

            IList<StyleSummary> styleSummaries = StyleManager.GetStyleSummaries(this.GetSite().ID);
            TagCloudViewModel tagCloudViewModel = new TagCloudViewModel();
            tagCloudViewModel.Tags = new List<TagViewModel>();

            foreach (StyleSummary styleSummary in styleSummaries)
            {
                TagViewModel tagViewModel = new TagViewModel();
                tagViewModel.Count = styleSummary.NumberOfArtists;
                tagViewModel.Tag = styleSummary.Name;
                tagViewModel.URL = RouteHelpers.ArtistListingsUrl(styleSummary.Name);
                tagCloudViewModel.Tags.Add(tagViewModel);
            }
            tagCloudViewModel.Max = tagCloudViewModel.Tags.Max(t => t.Count);
            artistListViewModel.StyleTagCloudViewModel = tagCloudViewModel;

            if (style != null & style != string.Empty)
            {
                Style styleObj = StyleManager.GetStyleWithName(style);
                artistListViewModel.StyleFilter = styleObj;

                if (styleObj != null)
                {
                    artistListViewModel.Artists = ArtistManager.GetArtistSummariesBySiteAndStyle(NumberOfItemsPerPageForListings, page.Value, this.GetSite().ID, styleObj.ID);
                }
                else
                {
                    throw new Exception("Style does not exist"); 
                }
            }
            else
            {
                artistListViewModel.Artists = ArtistManager.GetArtistSummariesBySite(NumberOfItemsPerPageForListings, page.Value, this.GetSite().ID);
            }

            return View(artistListViewModel); 
        }

        public ActionResult Music(string name, Guid? id)
        {
            ArtistsMusicViewModel artistsMusicViewModel = new ArtistsMusicViewModel();

            Artist artist = ArtistManager.GetByProfileAddress(name);

            Player player = new Player();
            player.PlayList = TrackManager.GetTrackSummariesForArtist(10, 0, artist.ID);
            player.FirstTrackId = id;

            artistsMusicViewModel.Artist = artist;
            artistsMusicViewModel.Player = player;
            artistsMusicViewModel.IsUserFanOfArtist = IsUserFanOfArtist(artist);
            artistsMusicViewModel.FansPartialViewModel = new FansPartialViewModel();
            artistsMusicViewModel.FansPartialViewModel.ArtistFanRelationshipSummaries = RelationshipManager.GetArtistFanRelationshipSummaryForArtist(this.GetUserCredentials(), 10, 0, artist.ID);
            artistsMusicViewModel.FansPartialViewModel.NumberPerRow = 5;

            return View(artistsMusicViewModel);
        }

        public ActionResult Gigs(string name)
        {
            Artist artist = ArtistManager.GetByProfileAddress(name);
            IPageOfList<Gig> upcomingGigs = GigManager.GetUpcomingGigsWithArtist(10, 0, artist.ID);
            IPageOfList<Gig> previousGigs = GigManager.GetPreviousGigsWithArtist(10, 0, artist.ID);
            ArtistsGigsViewModel artistsGigs = new ArtistsGigsViewModel();
            artistsGigs.UpcomingGigs = upcomingGigs;
            artistsGigs.PreviousGigs = previousGigs;
            artistsGigs.Artist = artist;
            artistsGigs.IsUserFanOfArtist = IsUserFanOfArtist(artist);

            artistsGigs.FansPartialViewModel = new FansPartialViewModel();
            artistsGigs.FansPartialViewModel.ArtistFanRelationshipSummaries = RelationshipManager.GetArtistFanRelationshipSummaryForArtist(this.GetUserCredentials(), 10, 0, artist.ID);
            artistsGigs.FansPartialViewModel.NumberPerRow = 5;


            return View(artistsGigs);
        }


        public JsonResult FetchLike(string q)
        {
            //TODO: CHANGE TO RETURN SUMMARY
            IList<Artist> artists = ArtistManager.GetArtistsWithNameLike(10, 0, q);
            return Json(artists);
        }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Add()
        {
            AddArtistViewModel addArtistViewModel = new AddArtistViewModel();
            addArtistViewModel.UploadImagePopupViewModel = new UploadImagePopupViewModel();
            PrepareViewDataForAddAction();
            return View(addArtistViewModel);
        }

        [Authorize]
        [ValidateInput(false)]
        [AcceptVerbs("POST")]
        public ActionResult Add([Bind(Prefix = "Artist")]Artist artist, UploadImagePopupViewModel uploadImagePopupViewModel)
        {
            AddArtistViewModel addArtistViewModel = new AddArtistViewModel();
            addArtistViewModel.Artist = artist;
            addArtistViewModel.UploadImagePopupViewModel = uploadImagePopupViewModel;
            return ManageArtist(addArtistViewModel);
        }



        [Authorize]
        [ValidateInput(false)]
        [AcceptVerbs("POST")]
        public ActionResult BecomeAFan(string profileAddress)
        {
          // Guid? artistId = ModelBinderHelpers.GetValue<Guid?>(formCollection,"ArtistId");
           IListenToUser user = (IListenToUser)this.HttpContext.User;
           Guid userId = user.UserId;
           Artist artist = ArtistManager.GetByProfileAddress(profileAddress);

           if (artist!=null)
           {
               RelationshipManager.AddArtistFan(user.UserCredentials, artist.ID, userId);
               return RedirectToArtist(artist);
           }

            //This should be an error view....
           return View();
        }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Edit(Guid id)
        {
            Artist artist = ArtistManager.GetByID(id);
            AddArtistViewModel addArtistViewModel = new AddArtistViewModel();
            addArtistViewModel.Artist = artist;

            addArtistViewModel.UploadImagePopupViewModel = new UploadImagePopupViewModel();
            addArtistViewModel.UploadImagePopupViewModel.ImageMetaData = artist.ProfileImage;

            PrepareViewDataForEditAction(artist);
            return View(addArtistViewModel);
        }


        [Authorize]
        [ValidateInput(false)]
        [AcceptVerbs("POST")]
        public ActionResult Edit(Guid id, FormCollection formCollection)
        {
            Artist artist = ArtistManager.GetByID(id);
            UpdateModel<Artist>(artist, "Artist");

            UploadImagePopupViewModel uploadImagePopupViewModel = new UploadImagePopupViewModel();
            UpdateModel<UploadImagePopupViewModel>(uploadImagePopupViewModel);

            AddArtistViewModel addArtistViewModel = new AddArtistViewModel();
            addArtistViewModel.Artist = artist;
            addArtistViewModel.UploadImagePopupViewModel = uploadImagePopupViewModel;

            return ManageArtist(addArtistViewModel);
        }

        private ActionResult ManageArtist(AddArtistViewModel addArtistViewModel)
        {
            Artist artist = addArtistViewModel.Artist;
            UploadImagePopupViewModel uploadImagePopupViewModel = addArtistViewModel.UploadImagePopupViewModel;

            IListenToUser user = (IListenToUser)this.HttpContext.User;

            if (uploadImagePopupViewModel.ImageMetaData != null)
            {
                artist.ProfileImage = uploadImagePopupViewModel.ImageMetaData;
            }

            try
            {
                ArtistManager.Save(artist, user.UserCredentials);
            }
            catch (ValidationException e)
            {
                e.AddToModelState(ViewData.ModelState, "Artist");

                PrepareViewDataForEditAction(artist);

                return View(addArtistViewModel);
            }

            return RedirectToArtist(artist);  
        }



        //private void PrepareImageMetaData(Artist artist)
        //{
        //    //Did the user upload an image?
        //    //If so, we want to display it...
        //    if (artist.ProfileImage != null)
        //    {
        //        ImageMetaData imageMetaData = (ImageMetaData)artist.ProfileImage;
        //        ViewData["ProfileImage"] = imageMetaData;
        //    }
        //}

        private void PrepareViewDataForAddAction()
        {
            PrepareTowns(null);
            PrepareStyles(null);
            PrepareFormedDate(null);
        }

        private void PrepareViewDataForEditAction(Artist artist)
        {
            Guid? townId = null;
            if (artist.Town != null)
            {
                townId = artist.Town.ID;
            }
            PrepareTowns(townId);
           
            Guid? styleId = null;
            if (artist.Style != null)
            {
                styleId = artist.Style.ID;
            }
            PrepareStyles(styleId);
                
            PrepareFormedDate(artist.Formed);
        }

        private void PrepareFormedDate(DateTime? formedDate)
        {
            int month;
            int year;

            if (formedDate.HasValue)
            {
                month = formedDate.Value.Month;
                year = formedDate.Value.Year;
            } else {
                month = DateTime.Now.Month;
                year = DateTime.Now.Year;
            }

            ViewData["months"] = SelectListHelper.CreateMonths(1, 12, 1, month);

            int minYear = DateTime.Now.Year - 50;
            if (year < minYear) { minYear = year; }

            ViewData["years"] = SelectListHelper.CreateYears(minYear, DateTime.Now.Year, 1, year);
        }

    }
}
