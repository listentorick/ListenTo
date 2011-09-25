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
using ListenTo.Shared.Interfaces.DO;
using System.Web.Routing;
using ListenTo.Web.Security;
using System.Security.Principal;

namespace ListenTo.Web.Helpers.HtmlHelperExtensions
{
    public static class OwnershipHelpers
    {
        public static string ActionOwnerLink(this HtmlHelper helper, ListenTo.Shared.DO.Action action, string defaultLinkText)
        {
            return helper.ActionOwnerLink(action, defaultLinkText, null);
        }

        public static string ActionOwnerLink(this HtmlHelper helper, ListenTo.Shared.DO.Action action, string defaultLinkText, object htmlAttributes)
        {
            string friendlyUsername = defaultLinkText;
            string username = action.OwnerUsername;
            string url = helper.ViewWhoIsUrl(username);
            if (!helper.IsOwner(action))
            {
                friendlyUsername = username;
            }

            var builder = new TagBuilder("a");
            builder.SetInnerText(friendlyUsername);
            builder.Attributes.Add("href", url);
            builder.MergeAttributes(new RouteValueDictionary(htmlAttributes));
            return builder.ToString();
        }

        public static bool IsOwner(this HtmlHelper helper, IOwnableDO ownableDO)
        {
            bool isOwner = false;
            IPrincipal userPrincipal = helper.ViewContext.HttpContext.User;
            if (userPrincipal.Identity.IsAuthenticated)
            {
                IListenToUser user = (IListenToUser)helper.ViewContext.HttpContext.User;
                isOwner = user.UserId == ownableDO.OwnerID;
            }
            return isOwner;
        }
    }
}
