using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.DTO;

namespace ListenTo.Shared.Interfaces.Helpers
{
    public interface IRouteHelpers
    {
        string GigListingsUrl();
        string AddGigUrl();
        string ViewGigUrl(Gig gig);
        string ViewVenueUrl(Venue venue);
        string AddArtistUrl();
        string ArtistMusicUrl(Artist artist);
        string ArtistGigsUrl(Artist artist);
        string ArtistListingsUrl();
        string ArtistListingsUrl(string style);
        string ViewArtistUrl(Artist artist);
        string ViewTrackUrl(TrackSummary trackSummary);
        string ViewArtistUrl(string artistProfileAddress);
        string EditArtistUrl(Artist artist);
        string EditArtistUrl(Guid id);
        string BecomeAFanUrl(Artist artist);
        string EditGigUrl(Gig gig);
        string AddTrackUrl();
        string EditTrackUrl(TrackSummary trackSummary);
        string NewsItemListingsUrl();
        string AddNewsItemUrl();
        string EditNewsItemUrl(NewsItemSummary newsItemSummary);
        string ViewNewsItemUrl(Guid newsItemId);
        string ViewNewsItemUrl(NewsItemSummary newsItemSummary);
        string ViewUserProfileUrl(UserProfile userProfile);
        string ViewUserProfileUrl(string username);
        string ViewUserContent(UserProfile userProfile);
        string ViewUserContent(string username);
        string ViewWhoIsUrl(string username);
        string RegisterAccountUrl();
        string EditUserProfileUrl(UserProfile userProfile);
        string TrackListingsUrl();
        string TrackListingsUrl(string style);
        string WhatsNewUrl(UserProfile userProfile);
        string WhatsNewUrl(string username);
        string AddingContent();
        string About();
        string PrivacyPolicy();
        string RSS();
        string TermsAndConditions();
        string DetailsRetrieved();
        string RetrieveDetails();
        string TemporaryFileUrl(Guid temporaryFileId);

    }
}
