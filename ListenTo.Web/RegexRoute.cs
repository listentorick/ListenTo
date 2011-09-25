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
using System.Text.RegularExpressions;
using System.Web.Routing;

namespace ListenTo.Web
{
    public class RegexRoute : Route
    {
        #region Private Fields

        private readonly Regex _urlRegex;

        #endregion

        #region Constructors

        public RegexRoute(Regex urlPattern, IRouteHandler routeHandler)
            : this(urlPattern, null, routeHandler)
        {

        }

        public RegexRoute(Regex urlPattern, RouteValueDictionary defaults, IRouteHandler routeHandler)
            : base(null, defaults, routeHandler)
        {
            _urlRegex = urlPattern;
        }

        #endregion

        #region Public Overrides Methods

        public override RouteData GetRouteData(HttpContextBase httpContext)
        {
            var requestUrl = httpContext.Request.AppRelativeCurrentExecutionFilePath.Substring(2) + httpContext.Request.PathInfo;

            var match = _urlRegex.Match(requestUrl);

            RouteData data = null;

            if (match.Success)
            {
                data = new RouteData(this, RouteHandler);

                // add defaults first
                if (null != Defaults)
                {
                    foreach (var def in Defaults)
                    {
                        data.Values[def.Key] = def.Value;
                    }
                }

                // iterate matching groups
                for (var i = 1; i < match.Groups.Count; i++)
                {
                    var group = match.Groups[i];

                    if (!group.Success) continue;
                    var key = _urlRegex.GroupNameFromNumber(i);

                    if (!String.IsNullOrEmpty(key) && !Char.IsNumber(key, 0))
                    {
                        data.Values[key] = group.Value;
                    }
                }
            }

            return data;
        }

        #endregion
    }
}
