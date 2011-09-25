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
using ListenTo.Shared.DO;
using System.Web.Mvc;
using System.Web;
using ListenTo.Shared.DTO;
using System.Collections.Generic;
using ListenTo.Web.Constants;
using ListenTo.Web.Enums;
using ListenTo.Shared.Interfaces.Helpers;
using System.Web.Routing;
namespace ListenTo.Web.Helpers
{
    /// <summary>
    /// This class should be instantiated once per request...
    /// </summary>
    public class RouteHelpers : IRouteHelpers
    {
        private UrlHelper UrlHelper { get; set; }

        public RouteHelpers()
        {
            var httpContext = new HttpContextWrapper(HttpContext.Current);
            var requestContext = new RequestContext(httpContext, new RouteData());
            UrlHelper = new UrlHelper(requestContext);
        }

        #region IRouteHelpers Members

        public string GigListingsUrl()
        {
            return UrlHelper.RouteUrl(Routes.GIG_LISTINGS);
        }

        public string AddGigUrl()
        {
            return UrlHelper.RouteUrl(Routes.GIG_ADD);
        }

        public string ViewGigUrl(Gig gig)
        {
            return UrlHelper.RouteUrl(Routes.GIG, new { gigId = gig.ID });
        }

        public string ViewVenueUrl(Venue venue)
        {
            return UrlHelper.RouteUrl("venue", new { venueId = venue.ID });
        }

        public string AddArtistUrl()
        {
            return UrlHelper.RouteUrl(Routes.ARTIST_ADD);
        }

        public string ArtistMusicUrl(Artist artist)
        {
            return UrlHelper.RouteUrl(Routes.ARTIST_MUSIC, new { name = artist.ProfileAddress });
        }

        public string ArtistGigsUrl(Artist artist)
        {
            return UrlHelper.RouteUrl(Routes.ARTIST_GIGS, new { name = artist.ProfileAddress });
        }

        public string ArtistListingsUrl()
        {
            return UrlHelper.RouteUrl(Routes.ARTIST_LISTINGS);
        }

        public string ArtistListingsUrl(string style)
        {
            return UrlHelper.RouteUrl(Routes.ARTIST_LISTINGS_BY_STYLE, new { style = style });
        }

        public string ViewArtistUrl(Artist artist)
        {
            return UrlHelper.RouteUrl(Routes.ARTIST, new { name = artist.ProfileAddress });
        }

        public string ViewTrackUrl(TrackSummary trackSummary)
        {
            return UrlHelper.RouteUrl(Routes.ARTIST_TRACK, new { name = trackSummary.ArtistProfileAddress, id = trackSummary.ID });
        }

        public string ViewArtistUrl(string artistProfileAddress)
        {
            return UrlHelper.RouteUrl(Routes.ARTIST, new { name = artistProfileAddress });
        }

        public string EditArtistUrl(Artist artist)
        {
         
            return UrlHelper.RouteUrl(Routes.ARTIST_EDIT, new { id = artist.ID });
        }


        public string EditArtistUrl(Guid id)
        {

            return UrlHelper.RouteUrl(Routes.ARTIST_EDIT, new { id = id });
        }


        public string BecomeAFanUrl(Artist artist)
        {
            return UrlHelper.RouteUrl(Routes.ARTIST_BECOME_A_FAN, new { profileAddress = artist.ProfileAddress });
        }

        public string EditGigUrl(Gig gig)
        {
            return UrlHelper.RouteUrl(Routes.GIG_EDIT, new { id = gig.ID });
        }

        public string AddTrackUrl()
        {
            return UrlHelper.RouteUrl(Routes.TRACK_ADD);
        }

        public string EditTrackUrl(TrackSummary trackSummary)
        {
            return UrlHelper.RouteUrl(Routes.TRACK_EDIT, new { id = trackSummary.ID });
        }

        public string NewsItemListingsUrl()
        {
            return UrlHelper.RouteUrl(Routes.NEWSITEM_LISTINGS);
        }

        public string AddNewsItemUrl()
        {
            return UrlHelper.RouteUrl(Routes.NEWSITEM_ADD);
        }

        public string EditNewsItemUrl( NewsItemSummary newsItemSummary)
        {
            return UrlHelper.RouteUrl(Routes.NEWSITEM_EDIT, new { id = newsItemSummary.ID });
        }

        public string ViewNewsItemUrl(Guid newsItemId)
        {
            return UrlHelper.RouteUrl(Routes.NEWSITEM_VIEW, new { id = newsItemId });
        }

        public string ViewNewsItemUrl(NewsItemSummary newsItemSummary)
        {
            return UrlHelper.RouteUrl(Routes.NEWSITEM_VIEW, new { id = newsItemSummary.ID });
        }

        public string ViewUserProfileUrl(UserProfile userProfile)
        {
            return UrlHelper.RouteUrl(Routes.ACCOUNT_PROFILE, new { username = userProfile.Username });
        }

        public string ViewUserProfileUrl(string username)
        {
            return UrlHelper.RouteUrl(Routes.ACCOUNT_PROFILE, new { username = username });
        }

        public string ViewUserContent(UserProfile userProfile)
        {
            return UrlHelper.RouteUrl(Routes.ACCOUNT_USER_CONTENT, new { username = userProfile.Username });
        }

        public string ViewUserContent(string username)
        {
            return UrlHelper.RouteUrl(Routes.ACCOUNT_USER_CONTENT, new { username = username });
        }

        public string ViewWhoIsUrl(string username)
        {
            return UrlHelper.RouteUrl(Routes.WHOIS_VIEW, new { username = username });
        }

        public string RegisterAccountUrl()
        {
            return UrlHelper.RouteUrl(Routes.ACCOUNT_REGISTER);
        }

        public string EditUserProfileUrl(UserProfile userProfile)
        {
            return UrlHelper.RouteUrl(Routes.ACCOUNT_EDIT_PROFILE, new { id = userProfile.ID });
        }

        public string TrackListingsUrl()
        {
            return UrlHelper.RouteUrl(Routes.TRACK_LISTINGS);
        }

        public string TrackListingsUrl(string style)
        {
            return UrlHelper.RouteUrl(Routes.TRACK_LISTINGS_BY_STYLE, new { style = style });
        }

        public string WhatsNewUrl(string username)
        {
            return UrlHelper.RouteUrl(Routes.ACCOUNT_WHATS_NEW, new { username = username });
        }

        public string WhatsNewUrl(UserProfile userProfile)
        {
            return UrlHelper.RouteUrl(Routes.ACCOUNT_WHATS_NEW, new { username = userProfile.Username });
        }

        public string AddingContent()
        {
            return UrlHelper.RouteUrl(Routes.INFO_ADDING_CONTENT);
        }

        public string About()
        {
            return UrlHelper.RouteUrl(Routes.INFO_ABOUT);
        }

        public string PrivacyPolicy()
        {
            return UrlHelper.RouteUrl(Routes.INFO_PRIVACY_POLICY);
        }

        public string RSS()
        {
            return UrlHelper.RouteUrl(Routes.INFO_RSS);
        }

        public string TermsAndConditions()
        {
            return UrlHelper.RouteUrl(Routes.INFO_TERMS_AND_CONDITIONS);
        }

        public string DetailsRetrieved()
        {
            return UrlHelper.RouteUrl(Routes.ACCOUNT_DETAILS_RETRIEVED);
        }

        public string RetrieveDetails()
        {
            return UrlHelper.RouteUrl(Routes.ACCOUNT_RETRIEVE_DETAILS);
        }


        public string TemporaryFileUrl(Guid temporaryFileId)
        {
            return UrlHelper.RouteUrl(Routes.TEMPORARY_FILE, new { id = temporaryFileId });
        }

        #endregion
    }
}
