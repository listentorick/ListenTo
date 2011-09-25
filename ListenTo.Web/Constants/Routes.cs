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

namespace ListenTo.Web.Constants
{
    public static class Routes
    {
        public const string HOME = "Home";
        public const string GIG = "Gig";
        public const string GIG_ADD = "GigAdd";
        public const string GIG_EDIT = "GigEdit";
        public const string GIG_LISTINGS = "GigListings";
        public const string GIG_YEAR_LISTINGS = "GigYearListings";
        public const string GIG_YEAR_AND_MONTH_LISTINGS = "GigYearAndMonthListings";
        public const string GIG_YEAR_AND_MONTH_AND_DAY_LISTINGS = "GigYearAndMonthAndDayListings";
        public const string GIG_DAY_LISTINGS = "GigDayListings";
        public const string ARTIST_ADD = "ArtistADD";
        public const string ARTIST_EDIT = "ArtistEdit";
        public const string ARTIST_LISTINGS = "ArtistListings";
        public const string ARTIST_LISTINGS_BY_STYLE = "ArtistListingsByStyle";
        public const string ARTIST = "Artist";
        public const string ARTIST_MUSIC = "ArtistMusic";
        public const string ARTIST_TRACK = "ArtistTrack";
        public const string ARTIST_GIGS = "ArtistGigs";
        public const string ARTIST_BECOME_A_FAN = "BecomeAFan";
        public const string COMMENT_ADD = "CommentAdd";
        public const string USER_REGISTERED = "UserRegistered";
        public const string USER_APPROVE = "UserApprove";
        public const string TRACK = "Track";
        public const string TRACK_ADD = "TrackAdd";
        public const string TRACK_EDIT = "TrackEdit";
        public const string TRACK_LISTINGS = "TrackListings";
        public const string TRACK_LISTINGS_BY_STYLE = "TrackListingsByStyle";
        public const string TRACK_META_DATA = "TrackMetaData";
        public const string TRACK_LISTEN = "TrackListen";
        public const string NEWSITEM_LISTINGS = "NewsItemListings";
        public const string NEWSITEM_VIEW = "NewsItemView";
        public const string NEWSITEM_EDIT = "NewsItemEdit";
        public const string NEWSITEM_ADD = "NewsItemAdd";
        public const string NEWSITEM_INDEX = "NewsItemIndex";
        public const string WHOIS_VIEW = "WhoIsView";
        public const string ACCOUNT_LOGIN = "AccountLogin";
        public const string ACCOUNT_REGISTER = "AccountRegister";
        public const string ACCOUNT_WHATS_NEW = "WhatsNew";
        public const string ACCOUNT_EDIT_PROFILE = "AccountEditProfile";
        public const string ACCOUNT_PROFILE = "AccountProfile";
        public const string ACCOUNT_AJAX_LOGIN = "ACCOUNT_AJAX_LOGIN";
        public const string ACCOUNT_USER_CONTENT = "ACCOUNT_USER_CONTENT";
        public const string VENUE = "Venue";
        public const string RADIO = "Radio";
        public const string RADIO_PLAYLIST = "RADIO_PLAYLIST";
        public const string INFO_ADDING_CONTENT = "INFO_ADDING_CONTENT";
        public const string INFO_ABOUT = "INFO_ABOUT";
        public const string INFO_TERMS_AND_CONDITIONS = "INFO_TERMS_AND_CONDITIONS";
        public const string INFO_PRIVACY_POLICY = "INFO_PRIVACY_POLICY";
        public const string INFO_RSS = "INFO_RSS";
        public const string INFO_ERROR = "INFO_ERROR";
        public const string ACCOUNT_RETRIEVE_DETAILS = "ACCOUNT_RETRIEVE_DETAILS";
        public const string ACCOUNT_DETAILS_RETRIEVED = "ACCOUNT_DETAILS_RETRIEVED";
        public const string TEMPORARY_FILE = "TEMPORARY_FILE";
        public const string IMAGE_UPLOAD = "IMAGE_UPLOAD";
        public const string IMAGE = "IMAGE";
    }
}
