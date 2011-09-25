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
using ListenTo.Web.Constants;
using ListenTo.Web.Enums;
using System.Web.Mvc;
using System.Collections.Generic;

namespace ListenTo.Web.Helpers.HtmlHelperExtensions
{
    public static class SectionHelper
    {
        /// <summary>
        /// Returns true if the current View is within the "MenuSection" - Uses the mapping defined in GetSection
        /// </summary>
        /// <param name="helper"></param>
        /// <param name="menuSection"></param>
        /// <returns></returns>
        public static bool IsSection(this HtmlHelper helper, MenuSection menuSection)
        {
            return helper.GetSection() == menuSection;
        }

        /// <summary>
        /// Uses a map of section to routes to determine the section associated with the current route
        /// </summary>
        /// <param name="helper"></param>
        /// <returns></returns>
        public static MenuSection GetSection(this HtmlHelper helper)
        {
            Dictionary<string, MenuSection> d = new Dictionary<string, MenuSection>();

            d[Routes.HOME] = MenuSection.HOME;
            d[Routes.GIG] = MenuSection.GIGS;
            d[Routes.GIG_ADD] = MenuSection.GIGS;
            d[Routes.GIG_EDIT] = MenuSection.GIGS;
            d[Routes.GIG_LISTINGS] = MenuSection.GIGS;
            d[Routes.GIG_YEAR_LISTINGS] = MenuSection.GIGS;
            d[Routes.GIG_YEAR_AND_MONTH_LISTINGS] = MenuSection.GIGS;
            d[Routes.GIG_YEAR_AND_MONTH_AND_DAY_LISTINGS] = MenuSection.GIGS;

            d[Routes.ARTIST_ADD] = MenuSection.ARTISTS;
            d[Routes.ARTIST_EDIT] = MenuSection.ARTISTS;
            d[Routes.ARTIST_LISTINGS] = MenuSection.ARTISTS;
            d[Routes.ARTIST] = MenuSection.ARTISTS;

            d[Routes.ARTIST_MUSIC] = MenuSection.ARTISTS;
            d[Routes.ARTIST_TRACK] = MenuSection.ARTISTS;
            d[Routes.ARTIST_GIGS] = MenuSection.ARTISTS;
            d[Routes.ARTIST_BECOME_A_FAN] = MenuSection.ARTISTS;
            d[Routes.ARTIST_LISTINGS_BY_STYLE] = MenuSection.ARTISTS;
            d[Routes.COMMENT_ADD] = MenuSection.ARTISTS;

            d[Routes.USER_REGISTERED] = MenuSection.ARTISTS;
            d[Routes.USER_APPROVE] = MenuSection.ARTISTS;
            d[Routes.WHOIS_VIEW] = MenuSection.NA;

            d[Routes.TRACK] = MenuSection.TRACKS;
            d[Routes.TRACK_ADD] = MenuSection.TRACKS;
            d[Routes.TRACK_EDIT] = MenuSection.TRACKS;
            d[Routes.TRACK_LISTINGS] = MenuSection.TRACKS;
            d[Routes.TRACK_LISTINGS_BY_STYLE] = MenuSection.TRACKS;
            d[Routes.TRACK_META_DATA] = MenuSection.TRACKS;
            d[Routes.TRACK_LISTEN] = MenuSection.TRACKS;

            d[Routes.NEWSITEM_LISTINGS] = MenuSection.NEWSITEMS;
            d[Routes.NEWSITEM_VIEW] = MenuSection.NEWSITEMS;
            d[Routes.NEWSITEM_EDIT] = MenuSection.NEWSITEMS;
            d[Routes.NEWSITEM_ADD] = MenuSection.NEWSITEMS;
            d[Routes.NEWSITEM_INDEX] = MenuSection.NEWSITEMS;

            d[Routes.ACCOUNT_LOGIN] = MenuSection.ACCOUNTS;
            d[Routes.ACCOUNT_REGISTER] = MenuSection.ACCOUNTS;
            d[Routes.ACCOUNT_WHATS_NEW] = MenuSection.ACCOUNTS;
            d[Routes.ACCOUNT_EDIT_PROFILE] = MenuSection.ACCOUNTS;
            d[Routes.ACCOUNT_PROFILE] = MenuSection.ACCOUNTS;
            d[Routes.ACCOUNT_DETAILS_RETRIEVED] = MenuSection.ACCOUNTS;
            d[Routes.ACCOUNT_RETRIEVE_DETAILS] = MenuSection.ACCOUNTS;
            d[Routes.ACCOUNT_USER_CONTENT] = MenuSection.ACCOUNTS;

            d[Routes.VENUE] = MenuSection.NA;
            d[Routes.RADIO] = MenuSection.TRACKS;
            d[Routes.INFO_ADDING_CONTENT] = MenuSection.CONTENT;
            d[Routes.INFO_TERMS_AND_CONDITIONS] = MenuSection.NA;
            d[Routes.INFO_RSS] = MenuSection.NA;
            d[Routes.INFO_PRIVACY_POLICY] = MenuSection.NA;
            d[Routes.INFO_ABOUT] = MenuSection.NA;
            d[Routes.INFO_ERROR] = MenuSection.NA;
            d[Routes.TEMPORARY_FILE] = MenuSection.NA;

            d[Routes.IMAGE] = MenuSection.NA;
            d[Routes.IMAGE_UPLOAD] = MenuSection.NA;

            string routeName = helper.GetRouteName();

            MenuSection section = d[routeName];

            return section;
        }

        /// <summary>
        /// Works with the extension method RouteCollectionExtensions.MapRouteWithName
        /// </summary>
        /// <param name="helper"></param>
        /// <returns></returns>
        public static string GetRouteName(this HtmlHelper helper)
        {
            return (string)helper.ViewContext.RouteData.DataTokens["RouteName"];
        }

    }
}
