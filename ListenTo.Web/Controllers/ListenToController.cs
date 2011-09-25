using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Web.Mvc;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Managers;
using System.Collections.Generic;
using ListenTo.Web.Helpers;
using ListenTo.Web.Models;
using ListenTo.Web.Constants;
using ListenTo.Web.Security;
using ListenTo.Shared.Interfaces.Helpers;
using ListenTo.Web.Helpers.HtmlHelperExtensions;
using Common.Logging;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Interfaces.Ownership;
using ListenTo.Shared.Interfaces.Do;


namespace ListenTo.Web.Controllers
{
    public class ListenToController: Controller
    {
        protected static readonly ILog LOG = LogManager.GetLogger(typeof(ListenToController));
        public ISiteManager SiteManager { get; set; }
        public IStyleManager StyleManager { get; set; }
        public ITownManager TownManager { get; set; }
        public IArtistManager ArtistManager { get; set; }
        public IGigManager GigManager { get; set; }
        public IRouteHelpers RouteHelpers { get; set; }
        public int NumberOfItemsPerPageForListings { get; set; }
        public IOwnershipHelper OwnershipHelper { get; set; }
        public IUserProfileManager UserProfileManager { get;set; }
        public IVenueManager VenueManager { get; set; }
        public ITemporaryFileStrategy TemporaryFileStrategy {get;set;}

        public void RedirectUserIfAccessDenied( BaseDO baseDO) {

            IListenToUser user = (IListenToUser)this.HttpContext.User;
            UserCredentials userCredentials = user.UserCredentials;
            bool isOwner = OwnershipHelper.IsOwner(baseDO, userCredentials);
            if (!isOwner)
            {
                RedirectToAction(Routes.INFO_ERROR, new { });
            }
        }

        public RedirectToRouteResult RedirectToGig(Gig gig)
        {
            return RedirectToRoute(Routes.GIG, new { gigId = gig.ID });
        }

        public RedirectToRouteResult RedirectToArtist(Artist artist)
        {
            return RedirectToRoute(Routes.ARTIST, new { name = artist.ProfileAddress  });
        }

        public RedirectToRouteResult RedirectToWhoIs(UserProfile userprofile)
        {
            return RedirectToRoute(Routes.WHOIS_VIEW, new { username = userprofile.Username });
        }

        public RedirectToRouteResult RedirectToTrack(Track track)
        {
            return RedirectToRoute(Routes.ARTIST_MUSIC, new { id = track.ID, name = track.Artist.ProfileAddress });
        }

        public RedirectToRouteResult RedirectToNewsItem(NewsItem newsItem)
        {
            return RedirectToRoute(Routes.NEWSITEM_INDEX, new { id = newsItem.ID});
        }

        public RedirectToRouteResult RedirectToUploadedImage(ListenTo.Shared.DO.Image image)
        {
            return RedirectToRoute(Routes.IMAGE, new { id = image.ID});
        }

        public RedirectToRouteResult RedirectToUserRegistered(User user)
        {
            return RedirectToUserRegistered(user.Username);
        }

        public RedirectToRouteResult RedirectToUserRegistered(string username)
        {
            return RedirectToRoute(Routes.USER_REGISTERED, new { username = username });
        }

        public RedirectToRouteResult RedirectToWhatsNew(string username)
        {
            return RedirectToRoute(Routes.ACCOUNT_WHATS_NEW, new { username = username });
        }

        protected ActionResult ReturnToUrl()
        {
            string returnUrl = Request.Form["ReturnUrl"];

            if (!String.IsNullOrEmpty(returnUrl) && Request.Url.AbsoluteUri.ToLower() != returnUrl.ToLower())
            {
                return Redirect(returnUrl);
            }
            else
            {
                if (this.User.Identity.IsAuthenticated)
                {
                    return RedirectToWhatsNew(((IListenToUser)this.User).UserCredentials.Username);
                }
                else
                {
                    return RedirectToRoute(Routes.HOME);
                }
               
            }
        }
        private Site _site = null;

        public Site GetSite()
        {
            if (this._site == null)
            {
                string host = Request.Url.Host;
                this._site = SiteManager.GetSiteByURL(host);
            }
            return this._site;
        }


        public UserCredentials GetUserCredentials()
        {
            UserCredentials userCredentials = null;

            if (this.HttpContext.User.Identity.IsAuthenticated)
            {
                IListenToUser user = (IListenToUser)this.HttpContext.User;
                userCredentials = user.UserCredentials;
            }

            return userCredentials;
        }

        protected void PrepareStyles(Guid? selectedStyle)
        {
            IList<ListenTo.Shared.DO.Style> styles = StyleManager.GetStyles();
            styles = styles.OrderBy(s => s.Name).ToList();
            ViewData["styles"] = SelectListHelper.CreateSelectList<ListenTo.Shared.DO.Style>(styles, selectedStyle);
        }

        protected void PrepareVenues(Guid? selectedVenue)
        {
            IList<Venue> venues = VenueManager.GetVenues();
            //we dont care about deleted venues
            venues = (from v in venues where v.IsDeleted==false select v).ToList();
            venues = venues.OrderBy(v => v.Name).ToList();
            ViewData["venues"] = SelectListHelper.CreateSelectList<ListenTo.Shared.DO.Venue>(venues, selectedVenue);
        }

        protected void PrepareTowns(Guid? selectedTown)
        {
            IList<Town> towns = TownManager.GetTowns();
            //we dont care about deleted towns
            towns = (from t in towns where t.IsDeleted == false select t).ToList();
            towns = towns.OrderBy(t => t.Name).ToList();
            ViewData["towns"] = SelectListHelper.CreateSelectList<ListenTo.Shared.DO.Town>(towns, selectedTown);
        }

        public MP3Result MP3Result(byte[] data)
        {
            MP3Result result = new MP3Result { Data = data };
            return result;
        }

        protected override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            //Check that we are returning a viewResult...
            var result = filterContext.Result as ViewResult;
            if (result != null)
            {
                Footer f = new Footer();
                f.Artists = ArtistManager.GetNRandomArtistSummariesBySite(this.GetSite().ID, 5);
                f.Gigs = GigManager.GetNRandomGigsBySiteAfterDate(5, this.GetSite().ID, DateTime.Now);

                BaseListenToViewModel model = result.ViewData.Model as BaseListenToViewModel;
                //Since the concept of a BaseListenToViewModel is new, most views dont support this... hence 
                if (model != null)
                {
                    model.Footer = f;
                }
                else
                {
                    result.ViewData["footer"] = f;
                }
            }

            base.OnActionExecuted(filterContext);
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            Exception e = filterContext.Exception;

            LOG.Error(e.Message + e.StackTrace);

            //log our exceptions here
            base.OnException(filterContext);
        }

        /// <summary>
        /// A model binder *may* have populated our model with byte data. 
        /// If so we need to temporarily persist the data, so that if need be we can access it later, if its valid
        /// If the post didnt contain byte data, we may have a temporary file still associated with this model,
        /// so we grab the data and populate the file.
        /// </summary>
        /// <param name="model"></param>
        /// <param name="fileValidationHelper"></param>
        public IHasBinaryData HandleTemporaryFile(IHasBinaryData model, IFileValidationHelper fileValidationHelper)
        {
            bool isExistingTemporaryFile = false;


            if (model.Data == null || model.Data.Length == 0)
            {
                //The model doesnt have any data.... lets try to grab some
                model = (UploadFilePartialViewModel)TemporaryFileStrategy.Fetch(model);
                isExistingTemporaryFile = true;
            }

            if (model.Data == null || model.Data.Length == 0)
            {
                //There isnt any data so we can return...
                return model;
            }

            //is the data valid?
            if (!fileValidationHelper.IsValidFileType(model.Data))
            {
                //Post 1: - uploads valid temporary file
                //Post 2: - uploads invalid temporary file
                //We dont want to keep the data associated with post 1, so we attempt a delete just in case..
                TemporaryFileStrategy.DeleteTemporaryFile(model);
                //The data is invalid, therefore we will remove it...
                //model.Data = null;
                //Throw an exception
                throw new InvalidFileTypeException();
            }

            if (isExistingTemporaryFile==false)
            {
                //Persist the file for later use if the file is the correct type
                TemporaryFileStrategy.Create(model);
            }

            return model;


        }
        

    }
}
