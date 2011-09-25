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
using System.Web.Routing;
using System.Text.RegularExpressions;
using System.Web.Mvc;

namespace ListenTo.Web
{
    public static class RegexRouteCollectionExtensions
    {
        public static Route MapRoute(this RouteCollection routes, string name, Regex urlPattern)
        {
            return routes.MapRoute(name, urlPattern, null, null);
        }
        public static Route MapRoute(this RouteCollection routes, string name, Regex urlPattern, object defaults)
        {
            return routes.MapRoute(name, urlPattern, defaults, null);
        }
        public static Route MapRoute(this RouteCollection routes, string name, Regex urlPattern, string[] namespaces)
        {
            return routes.MapRoute(name, urlPattern, null, null, namespaces);
        }
        public static Route MapRoute(this RouteCollection routes, string name, Regex urlPattern, object defaults, object constraints)
        {
            return routes.MapRoute(name, urlPattern, defaults, constraints, null);
        }
        public static Route MapRoute(this RouteCollection routes, string name, Regex urlPattern, object defaults, string[] namespaces)
        {
            return routes.MapRoute(name, urlPattern, defaults, null, namespaces);
        }
        public static Route MapRoute(this RouteCollection routes, string name, Regex urlPattern, object defaults, object constraints, string[] namespaces)
        {
            if (routes == null)
            {
                throw new ArgumentNullException("routes");
            }
            if (urlPattern == null)
            {
                throw new ArgumentNullException("urlPattern");
            }
            var route2 = new RegexRoute(urlPattern, new MvcRouteHandler())
            {
                Defaults = new RouteValueDictionary(defaults),
                Constraints = new RouteValueDictionary(constraints)
            };
            var item = route2;
            if ((namespaces != null) && (namespaces.Length > 0))
            {
                item.DataTokens = new RouteValueDictionary();
                item.DataTokens["Namespaces"] = namespaces;
            }
            routes.Add(name, item);
            return item;
        }
    }
}
