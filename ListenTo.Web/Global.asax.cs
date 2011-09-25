using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Spring.Context.Support;
using ListenTo.Shared.DO;
using ListenTo.Web.ModelBinders;
using System.Web.Security;
using ListenTo.Web.Security;
using System.Security.Principal;
using System.Text.RegularExpressions;
using ListenTo.Web.Helpers;
using ListenTo.Web.Constants;
using ListenTo.Web.Models;
using ListenTo.Shared.Interfaces.Helpers;
using ListenTo.Web.Controllers;

namespace ListenTo.Web
{

    public class GlobalApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("favicon.ico");
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.IgnoreRoute("content/{*pathInfo}");

            routes.MapRouteWithName(
                Routes.HOME,
                "home/{action}",
                new { controller = "Home", action = "Index" }
            );

            routes.MapRouteWithName(
                 Routes.INFO_ADDING_CONTENT,
                 "info/addingcontent",
                 new { controller = "Info", action = "addingcontent" }
            );

            routes.MapRouteWithName(
                 Routes.INFO_ABOUT,
                 "info/about",
                 new { controller = "Info", action = "about" }
            );

            routes.MapRouteWithName(
                Routes.INFO_TERMS_AND_CONDITIONS,
                "info/termsandconditions",
                new { controller = "Info", action = "termsandconditions" }
            );

            routes.MapRouteWithName(
                Routes.INFO_PRIVACY_POLICY,
                "info/privacypolicy",
                new { controller = "Info", action = "privacypolicy" }
            );

            routes.MapRouteWithName(
                Routes.INFO_RSS,
                "info/rss",
                new { controller = "Info", action = "rss" }
            );

            routes.MapRouteWithName(
                Routes.INFO_ERROR,
                "info/error",
                new { controller = "Info", action = "error" }
            );

            routes.MapRouteWithName(
                Routes.IMAGE_UPLOAD,
                "image/upload",
                new { controller = "Image", action = "upload" }
            );

            routes.MapRouteWithName(
                Routes.IMAGE,
                "image/index",
                new { controller = "Image", action = "index" }
            );

            routes.MapRouteWithName(
                Routes.GIG_YEAR_AND_MONTH_AND_DAY_LISTINGS,
                "gig/list/{year}/{month}/{day}",
                new { controller = "Gig", action = "List" },
                new
                {
                    year = @"^[0-9]{4,4}$",
                    month = @"^[0-9]{1,2}$",
                    day = @"^[0-9]{1,2}$"
                }
            );

            routes.MapRouteWithName(
                Routes.GIG_YEAR_AND_MONTH_LISTINGS,
                "gig/list/{year}/{month}",
                new { controller = "Gig", action = "List" },
                new
                {
                    year = @"^[0-9]{4,4}$",
                    month = @"^[0-9]{1,2}$"
                }
            );

            routes.MapRouteWithName(
                Routes.GIG_YEAR_LISTINGS,
                "gig/list/{year}",
                new { controller = "Gig", action = "List" },
                new
                {
                    year = @"^[0-9]{4,4}$",
                }
            );

            routes.MapRouteWithName(
                Routes.GIG_LISTINGS,
                "gig/list",
                new { controller = "Gig", action = "List" }
            );

            routes.MapRouteWithName(
                Routes.GIG_ADD,
                "gig/add",
                new { controller = "Gig", action = "Add" }
            );

            routes.MapRouteWithName(
                Routes.GIG_EDIT,
                "gig/edit/{id}",
                new { controller = "Gig", action = "Edit" }
            );

            routes.MapRouteWithName(
                "UpdateGig",
                "gig/update/{id}",
                new { controller = "Gig", action = "Update" }
            );

            // A parameter q can be passed as a querystring to this route
            routes.MapRouteWithName(
                "FetchVenue",
                "venue/fetchlike",
                new { controller = "venue", action = "fetchlike" }
            );

            // A parameter q can be passed as a querystring to this route
            routes.MapRouteWithName(
                "FetchArtist",
                "band/fetchlike",
                new { controller = "artist", action = "fetchlike" }
            );

            routes.MapRouteWithName(
                Routes.ACCOUNT_LOGIN,
                "account/login/",
                new { controller = "account", action = "login" }
            );

            routes.MapRouteWithName(
                Routes.ACCOUNT_AJAX_LOGIN,
                "account/ajaxlogin/",
                new { controller = "account", action = "ajaxlogin" }
            );

            routes.MapRouteWithName(
                Routes.ACCOUNT_USER_CONTENT,
                "account/{username}/usercontent",
                new { controller = "account", action = "usercontent" }
            );

            routes.MapRouteWithName(
                Routes.ACCOUNT_WHATS_NEW,
                "account/{username}/whatsnew/",
                new { controller = "account", action = "whatsNew" }
            );

            routes.MapRouteWithName(
                Routes.ACCOUNT_EDIT_PROFILE,
                "account/editProfile/{id}",
                new { controller = "account", action = "editProfile" }
            );

            routes.MapRouteWithName(
                Routes.ACCOUNT_PROFILE,
                "account/{username}/profile",
                new { controller = "account", action = "profile" }
            );

            routes.MapRouteWithName(
                Routes.ACCOUNT_DETAILS_RETRIEVED,
                "account/detailsRetrieved",
                new { controller = "account", action = "detailsRetrieved" }
            );

            routes.MapRouteWithName(
                Routes.ACCOUNT_RETRIEVE_DETAILS,
                "account/retrieveDetails",
                new { controller = "account", action = "retrieveDetails" }
            );

            routes.MapRouteWithName(
                "Logout",
                "account/logout/",
                new { controller = "account", action = "logout" }
            );

            routes.MapRouteWithName(
                Routes.ACCOUNT_REGISTER,
                "account/register/",
                new { controller = "account", action = "register" }
            );

            routes.MapRouteWithName(
                Routes.USER_APPROVE,
                "account/approve/{validationId}",
                new { controller = "account", action = "approve" }
            );

            routes.MapRouteWithName(
                Routes.USER_REGISTERED,
                "account/registered/",
                new { controller = "account", action = "registered" }
            );

            routes.MapRouteWithName(
                Routes.GIG,
                "gig/{gigId}",
                new { controller = "Gig", action = "Index" }
            );

            routes.MapRouteWithName(
                Routes.VENUE,
                "venue/{venueId}",
                new { controller = "Venue", action = "Index" }
            );

            routes.MapRouteWithName(
                Routes.COMMENT_ADD,
                "comment/add",
                new { controller = "Comment", action = "Add" }
            );

            routes.MapRouteWithName(
                Routes.ARTIST_LISTINGS_BY_STYLE,
                "band/list/{style}",
                new { controller = "Artist", action = "List" }
            );

            routes.MapRouteWithName(
                Routes.ARTIST_LISTINGS,
                "band/list",
                new { controller = "Artist", action = "List" }
            );

            routes.MapRouteWithName(
                Routes.ARTIST_ADD,
                "band/add",
                new { controller = "Artist", action = "Add" }
            );

            routes.MapRouteWithName(
                Routes.ARTIST_EDIT,
                "band/edit/{id}",
                new { controller = "Artist", action = "Edit" }
            );

            routes.MapRouteWithName(
                Routes.TRACK_LISTINGS_BY_STYLE,
                "music/list/{style}",
                new { controller = "Track", action = "List" }
            );

            routes.MapRouteWithName(
                Routes.TRACK_LISTINGS,
                "music/list",
                new { controller = "Track", action = "List" }
            );

            routes.MapRouteWithName(
                Routes.TRACK_ADD,
                "music/add",
                new { controller = "Track", action = "Add" }
            );

            routes.MapRouteWithName(
                Routes.TRACK_EDIT,
                "music/edit/{id}",
                new { controller = "Track", action = "Edit" }
            );

            routes.MapRouteWithName(
                Routes.TRACK_META_DATA,
                "music/metaData/{id}",
                new { controller = "Track", action = "MetaData" }
            );

            routes.MapRouteWithName(
                Routes.TRACK_LISTEN,
                "music/listen/{id}",
                new { controller = "Track", action = "Listen" }
            );

            routes.MapRouteWithName(
                Routes.NEWSITEM_LISTINGS,
                "news/list/",
                new { controller = "NewsItem", action = "List" }
            );

            routes.MapRouteWithName(
                Routes.NEWSITEM_ADD,
                "news/add",
                new { controller = "NewsItem", action = "Add" }
            );

            routes.MapRouteWithName(
                Routes.NEWSITEM_INDEX,
                "news/{id}",
                new { controller = "NewsItem", action = "Index" }
            );

            routes.MapRouteWithName(
                Routes.NEWSITEM_VIEW,
                "news/{id}",
                new { controller = "NewsItem", action = "Index" }
            );

            routes.MapRouteWithName(
                Routes.NEWSITEM_EDIT,
                "news/edit/{id}",
                new { controller = "NewsItem", action = "Edit" }
            );

            routes.MapRouteWithName(
                Routes.WHOIS_VIEW,
                "WhoIs/{username}",
                new { controller = "WhoIs", action = "Index" }
            );

            routes.MapRouteWithName(
                Routes.RADIO,
                "Radio",
                new { controller = "Radio", action = "Index" }
            );

            routes.MapRouteWithName(
                Routes.RADIO_PLAYLIST,
                "radio/playlist",
                new { controller = "Radio", action = "playlist" }
            );

            
            routes.MapRouteWithName(
                Routes.TEMPORARY_FILE,
                "temporaryFile/{id}",
                new { controller = "TemporaryFile", action = "FetchTemporaryFileData" }
            );

            routes.MapRouteWithName(
                 Routes.ARTIST,
                 "{name}",
                 new { controller = "Artist", action = "Index" }
             );

            routes.MapRouteWithName(
                Routes.ARTIST_MUSIC,
                "{name}/music",
                new { controller = "Artist", action = "Music" }
            );

            routes.MapRouteWithName(
                Routes.ARTIST_GIGS,
                "{name}/gigs",
                new { controller = "Artist", action = "Gigs" }
            );

            routes.MapRouteWithName(
                Routes.ARTIST_TRACK,
                 "{name}/music/{id}",
                new { controller = "Artist", action = "Music" }
            );

            routes.MapRouteWithName(
                Routes.ARTIST_BECOME_A_FAN,
                "{profileAddress}/BecomeAFan",
                new { controller = "Artist", action = "BecomeAFan" }
            );

        }

        protected void Application_Start()
        {
            RegisterRoutes(RouteTable.Routes);

        }

        //protected void Application_Error(object sender, EventArgs e)
        //{
        //    Exception exception = Server.GetLastError();

        //    Response.Clear();

        //    HttpException httpException = exception as HttpException;

        //    RouteData routeData = new RouteData();
        //    routeData.Values.Add("controller", "Error");

        //    if (httpException != null)
        //    {

        //        switch (httpException.GetHttpCode())
        //        {
        //            case 404:
        //                // Page not found.
        //                routeData.Values.Add("action", "HandleHttpError");
        //                break;
    
        //        }

        //        // Clear the error on server.
        //        Server.ClearError();

        //        // Call target Controller and pass the routeData.
        //        IController errorController = new ErrorController();
        //        errorController.Execute(new RequestContext(
        //             new HttpContextWrapper(Context), routeData));
        //    }

        //}


        public override void Init() {  
            base.Init();  
            ConfigureIoC();

            System.Web.Mvc.ModelBinders.Binders[typeof(ListenTo.Shared.DO.Gig)] = ListenTo.Web.Helpers.IOCHelper.GetGigModelBinder();
            System.Web.Mvc.ModelBinders.Binders[typeof(ListenTo.Shared.DO.Artist)] = ListenTo.Web.Helpers.IOCHelper.GetArtistModelBinder();
            System.Web.Mvc.ModelBinders.Binders[typeof(ListenTo.Shared.DO.Track)] = ListenTo.Web.Helpers.IOCHelper.GetTrackModelBinder();
            System.Web.Mvc.ModelBinders.Binders[typeof(ListenTo.Shared.DO.NewsItem)] = ListenTo.Web.Helpers.IOCHelper.GetNewsItemModelBinder();
            System.Web.Mvc.ModelBinders.Binders[typeof(ListenTo.Shared.DO.UserProfile)] = ListenTo.Web.Helpers.IOCHelper.GetUserProfileModelBinder();
            System.Web.Mvc.ModelBinders.Binders[typeof(UploadFilePartialViewModel)] = ListenTo.Web.Helpers.IOCHelper.GetUploadFilePartialViewModelModelBinder();
            System.Web.Mvc.ModelBinders.Binders[typeof(UploadImagePopupViewModel)] = ListenTo.Web.Helpers.IOCHelper.GetUploadImagePopupViewModelModelBinder();    
        }  
   
        private void ConfigureIoC() {

            ControllerBuilder.Current.SetControllerFactory(typeof(ListenTo.Web.SpringControllerFactory));

        }

        void Application_AuthenticateRequest(Object Source, EventArgs Details)
        {

            try
            {
                string userLocale = ListenTo.Web.Helpers.LocaleHelpers.GetBestRFC3066Locale(this.Context.Request.UserLanguages);

                if (userLocale != String.Empty)
                {
                    System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture(userLocale);
                    System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(userLocale);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            System.Web.HttpCookie authCookie = Context.Request.Cookies[FormsAuthentication.FormsCookieName];

            if (authCookie == null)
                return;


            FormsAuthenticationTicket authTicket = FormsAuthentication.Decrypt(authCookie.Value);

            Guid id = new Guid(authTicket.UserData);

            IListenToUser user = new ListenToUser(
                ListenTo.Web.Helpers.IOCHelper.GetMembership().GetUser(),
                ListenTo.Web.Helpers.IOCHelper.GetUserManager()
            );

            Context.User = user;

        }

    }
}