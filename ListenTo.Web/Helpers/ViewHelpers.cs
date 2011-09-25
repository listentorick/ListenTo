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
using System.Collections.Generic;
using System.Web.Mvc;
using System.Globalization;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Web.Security;
using System.Security.Principal;
using anrControls;
using System.Web.Routing;
using ListenTo.Web.Enums;
using System.Web.Mvc.Html;
using ListenTo.Shared.Enums;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Web.Constants;

namespace ListenTo.Web.Helpers
{
    public static class ViewHelpers
    {

        /// <summary>
        /// Creates a ReturnUrl for use with the Login page
        /// </summary>
        public static string GetReturnUrl(this ViewPage pg)
        {
            return GetReturnUrl(pg.Html.ViewContext);
        }

        /// <summary>
        /// Creates a ReturnUrl for use with the Login UserControl
        /// </summary>
        public static string GetReturnUrl(this ViewUserControl vuc)
        {
            return GetReturnUrl(vuc.Html.ViewContext);
        }

        public static string GetReturnUrl(ViewContext vc){

             string returnUrl = "";

             if (vc.HttpContext.Request.QueryString["ReturnUrl"] != null)
             {
                 returnUrl = vc.HttpContext.Request.QueryString["ReturnUrl"];
             }
             else
             {
                 returnUrl = vc.HttpContext.Request.Url.AbsoluteUri;
             }
             return returnUrl;
         }

    }
}
