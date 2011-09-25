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
using ListenTo.Web.Constants;
using ListenTo.Shared.DO;
using ListenTo.Shared.DTO;

namespace ListenTo.Web.Helpers.HtmlHelperExtensions
{
    public static class UrlHelpers
    {
        public static string AddGigUrl(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().AddGigUrl();
        }

        public static string GigListingsUrl(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().GigListingsUrl();
        }

        public static string ViewGigUrl(this HtmlHelper helper, Gig gig)
        {
            return IOCHelper.GetRouteHelpers().ViewGigUrl(gig);
        }

        public static string ViewVenueUrl(this HtmlHelper helper, Venue venue)
        {
            return IOCHelper.GetRouteHelpers().ViewVenueUrl(venue);
        }

        public static string AddArtistUrl(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().AddArtistUrl();
        }

        public static string ArtistMusicUrl(this HtmlHelper helper, Artist artist)
        {
            return IOCHelper.GetRouteHelpers().ArtistMusicUrl(artist);
        }

        public static string ArtistGigsUrl(this HtmlHelper helper, Artist artist)
        {
            return IOCHelper.GetRouteHelpers().ArtistGigsUrl(artist);
        }


        public static string ArtistListingsUrl(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().ArtistListingsUrl();
        }

        public static string ArtistListingsUrl(this HtmlHelper helper, string style)
        {
            return IOCHelper.GetRouteHelpers().ArtistListingsUrl(style);
        }

        public static string ViewArtistUrl(this HtmlHelper helper, Artist artist)
        {
            return IOCHelper.GetRouteHelpers().ViewArtistUrl(artist);
        }

        public static string ViewTrackUrl(this HtmlHelper helper, TrackSummary trackSummary)
        {
            return IOCHelper.GetRouteHelpers().ViewTrackUrl(trackSummary);
        }

        public static string ViewArtistUrl(this HtmlHelper helper, string artistProfileAddress)
        {
            return IOCHelper.GetRouteHelpers().ViewArtistUrl(artistProfileAddress);
        }

        public static string EditArtistUrl(this HtmlHelper helper, Artist artist)
        {
            return IOCHelper.GetRouteHelpers().EditArtistUrl(artist);
        }


        public static string EditArtistUrl(this HtmlHelper helper, Guid id)
        {
            return IOCHelper.GetRouteHelpers().EditArtistUrl(id);
        }

        public static string BecomeAFanUrl(this HtmlHelper helper, Artist artist)
        {
            return IOCHelper.GetRouteHelpers().BecomeAFanUrl(artist);
        }


        public static string EditGigUrl(this HtmlHelper helper, Gig gig)
        {
            return IOCHelper.GetRouteHelpers().EditGigUrl(gig);
        }

        public static string AddTrackUrl(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().AddTrackUrl();
        }

        public static string EditTrackUrl(this HtmlHelper helper, TrackSummary trackSummary)
        {
            return IOCHelper.GetRouteHelpers().EditTrackUrl(trackSummary);
        }


        public static string NewsItemListingsUrl(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().NewsItemListingsUrl();
        }

        public static string AddNewsItemUrl(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().AddNewsItemUrl();
        }

        public static string EditNewsItemUrl(this HtmlHelper helper, NewsItemSummary newsItemSummary)
        {
            return IOCHelper.GetRouteHelpers().EditNewsItemUrl(newsItemSummary);
        }

        public static string ViewNewsItemUrl(this HtmlHelper helper, Guid newsItemId)
        {
            return IOCHelper.GetRouteHelpers().ViewNewsItemUrl(newsItemId);
        }

        public static string ViewNewsItemUrl(this HtmlHelper helper, NewsItemSummary newsItemSummary)
        {
             return IOCHelper.GetRouteHelpers().ViewNewsItemUrl(newsItemSummary);
        }

        public static string ViewUserProfileUrl(this HtmlHelper helper, UserProfile userProfile)
        {
            return IOCHelper.GetRouteHelpers().ViewUserProfileUrl(userProfile);
        }

        public static string ViewUserProfileUrl(this HtmlHelper helper, string username)
        {
            return IOCHelper.GetRouteHelpers().ViewUserProfileUrl(username);
        }

        public static string ViewUserContent(this HtmlHelper helper, UserProfile userProfile)
        {
            return IOCHelper.GetRouteHelpers().ViewUserContent(userProfile);
        }

         public static string ViewUserContent(this HtmlHelper helper, string username)
         {
             return IOCHelper.GetRouteHelpers().ViewUserContent(username);
         }
       


        public static string ViewWhoIsUrl(this HtmlHelper helper, string username)
        {
            return IOCHelper.GetRouteHelpers().ViewWhoIsUrl(username);
        }

        public static string RegisterAccountUrl(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().RegisterAccountUrl();
        }

        public static string EditUserProfileUrl(this HtmlHelper helper, UserProfile userProfile)
        {
            return IOCHelper.GetRouteHelpers().EditUserProfileUrl(userProfile);
        }

        public static string RetrieveDetails(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().RetrieveDetails();
        }

        public static string DetailsRetrieved(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().DetailsRetrieved();
        }

        public static string TrackListingsUrl(this HtmlHelper helper, string styleName) {

            return IOCHelper.GetRouteHelpers().TrackListingsUrl(styleName);
        }


        public static string TrackListingsUrl(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().TrackListingsUrl();
        }

        public static string WhatsNewUrl(this HtmlHelper helper,string username)
        {
            return IOCHelper.GetRouteHelpers().WhatsNewUrl(username);
        }

        public static string WhatsNewUrl(this HtmlHelper helper, UserProfile userProfile)
        {
            return IOCHelper.GetRouteHelpers().WhatsNewUrl(userProfile);
        }

        public static string About(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().About();
        }

        public static string PrivacyPolicy(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().PrivacyPolicy();
        }

        public static string TermsAndConditions(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().TermsAndConditions();
        }

        public static string AddingContent(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().AddingContent();
        }

        public static string RSS(this HtmlHelper helper)
        {
            return IOCHelper.GetRouteHelpers().RSS();
        }

        public static string TemporaryFileUrl(this HtmlHelper helper, Guid temporaryFileId)
        {
            return IOCHelper.GetRouteHelpers().TemporaryFileUrl(temporaryFileId);
        }

    }
}
