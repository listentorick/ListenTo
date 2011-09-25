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
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Web.Security;
using ListenTo.Shared.Interfaces.Helpers;

namespace ListenTo.Web.Helpers
{
    public class IOCHelper
    {
        private static IRouteHelpers _routeHelpers = null;
        public static object GetObject(string name)
        {
            Spring.Context.IConfigurableApplicationContext ctx = (Spring.Context.IConfigurableApplicationContext)Spring.Context.Support.WebApplicationContext.Current;
            Spring.Objects.Factory.Config.IConfigurableListableObjectFactory objectFactory = ctx.ObjectFactory;
            object obj = objectFactory.GetObject(name);
            return obj;
        }

        public static IRouteHelpers GetRouteHelpers()
        {
            if (_routeHelpers == null)
            {
                _routeHelpers= (IRouteHelpers)IOCHelper.GetObject("RouteHelpers");
            }
            return _routeHelpers;
        }

        public static IModelBinder GetTrackModelBinder()
        {
            return (IModelBinder)IOCHelper.GetObject("TrackModelBinder");
        }


        public static IModelBinder GetGigModelBinder()
        {
            return (IModelBinder)IOCHelper.GetObject("GigModelBinder");   
        }

        public static IModelBinder GetUserModelBinder()
        {
            return (IModelBinder)IOCHelper.GetObject("UserModelBinder");
        }

        public static IModelBinder GetImageModelBinder()
        {
            return (IModelBinder)IOCHelper.GetObject("ImageModelBinder");
        }

        public static IModelBinder GetArtistModelBinder()
        {
            return (IModelBinder)IOCHelper.GetObject("ArtistModelBinder");
        }

        public static IMembership GetMembership()
        {
            return new MembershipWrapper();
        }

        public static IUserManager GetUserManager()
        {
            return (IUserManager)IOCHelper.GetObject("UserManager");
        }

        public static IModelBinder GetCommentModelBinder()
        {
            return (IModelBinder)IOCHelper.GetObject("CommentModelBinder");
        }

        public static IModelBinder GetUserProfileModelBinder()
        {
            return (IModelBinder)IOCHelper.GetObject("UserProfileModelBinder");
        }

        public static IModelBinder GetNewsItemModelBinder()
        {
            return (IModelBinder)IOCHelper.GetObject("NewsItemModelBinder");
        }

        public static IModelBinder GetUploadFilePartialViewModelModelBinder()
        {
            return (IModelBinder)IOCHelper.GetObject("UploadFilePartialViewModelModelBinder");
        }

        public static ITemporaryFileStrategy GetTemporaryFileStrategy()
        {
            return (ITemporaryFileStrategy)IOCHelper.GetObject("TemporaryFileStrategy");
        }

        public static IModelBinder GetUploadImagePopupViewModelModelBinder()
        {
            return (IModelBinder)IOCHelper.GetObject("UploadImagePopupViewModelModelBinder");
        }
        

    }
}


