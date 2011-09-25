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
using System.Web.Mvc;

namespace ListenTo.Web.Helpers
{
    public static class RouteCollectionExtensions
    {
        public static Route MapRouteWithName(this RouteCollection routes, string name, string url, object defaults)
        {
            return routes.MapRouteWithName(name, url, defaults, new { });
        }

        public static Route MapRouteWithName(this RouteCollection routes,
        string name, string url, object defaults, object constraints)
        {
            Route route = routes.MapRoute(name, url, defaults, constraints);
            route.DataTokens = new RouteValueDictionary();
            route.DataTokens.Add("RouteName", name);
            return route;
        }
    }

}
