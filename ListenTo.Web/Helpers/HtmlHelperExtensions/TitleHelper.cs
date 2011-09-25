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
using System.Web.Routing;

namespace ListenTo.Web.Helpers.HtmlHelperExtensions
{
    public static class TitleHelper
    {

        public static string Title(this HtmlHelper helper, string title)
        {
            return Title(helper, title, null);
        }

        public static string Title(this HtmlHelper helper, string title, object htmlAttributes)
        {
            // Create tag builder
            var builder = new TagBuilder("title");
            builder.SetInnerText(title);
            builder.MergeAttributes(new RouteValueDictionary(htmlAttributes));
            return builder.ToString();
        }

    }
}
