using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Validation
{
    public static class ValidationStateKeys
    {
        public const string ARTIST_NEEDS_A_TOWN = "ARTIST_NEEDS_A_TOWN";
        public const string ARTIST_NEEDS_A_STYLE = "ARTIST_NEEDS_A_STYLE";
        public const string ARTIST_NEEDS_A_PROFILE_ADDRESS = "ARTIST_NEEDS_A_PROFILE_ADDRESS";
        public const string ARTIST_PROFILE_ADDRESS_MUST_BE_ALPHA_NUMERIC = "ARTIST_PROFILE_ADDRESS_MUST_BE_ALPHA_NUMERIC";
        public const string ARTIST_PROFILE_ADDRESS_MUST_BE_UNIQUE = "ARTIST_PROFILE_ADDRESS_MUST_BE_UNIQUE";
        public const string ARTIST_NEEDS_A_NAME = "ARTIST_NEEDS_A_NAME";
        public const string ARTIST_EMAIL_ADDRESS_INVALID = "ARTIST_EMAIL_ADDRESS_INVALID";

        public const string COMMENT_BODY_INVALID = "COMMENT_BODY_INVALID";

        public const string GIG_NEEDS_AT_LEAST_ONE_ACT = "GIG_NEEDS_AT_LEAST_ONE_ACT";
        public const string GIG_NEEDS_A_NAME = "GIG_NEEDS_A_NAME";
        public const string GIG_NEEDS_A_VENUE = "GIG_NEEDS_A_VENUE";
        public const string GIG_NAME_IS_TOO_LONG = "GIG_NAME_IS_TOO_LONG";
        public const string GIG_DESCRIPTION_IS_TOO_LONG = "GIG_DESCRIPTION_IS_TOO_LONG";

        public const string USER_USERNAME_INVALID = "USER_USERNAME_INVALID";
        public const string USER_USERNAME_NOT_AVAILABLE = "USER_USERNAME_NOT_AVAILABLE";
        public const string USER_USERNAME_TOO_SHORT = "USER_USERNAME_TOO_SHORT";
        public const string USER_NEEDS_A_USERNAME = "USER_NEEDS_A_USERNAME";
        public const string USER_USERNAME_MUST_BE_ALPHA_NUMERIC = "USER_USERNAME_MUST_BE_ALPHA_NUMERIC";

        public const string USER_PASSWORD_TOO_SHORT = "USER_PASSWORD_TOO_SHORT";
        public const string USER_NEEDS_A_PASSWORD = "USER_NEEDS_A_PASSWORD";

        public const string USER_NEEDS_A_EMAILADDRESS = "USER_NEEDS_A_EMAILADDRESS";
        public const string USER_NEEDS_A_VALID_EMAILADDRESS = "USER_NEEDS_A_VALID_EMAILADDRESS";
        public const string USER_NEEDS_A_UNIQUE_EMAILADDRESS = "USER_NEEDS_A_UNIQUE_EMAILADDRESS";

        public const string TRACK_NEEDS_A_STYLE = "TRACK_NEEDS_A_STYLE";
        public const string TRACK_NEEDS_A_NAME = "TRACK_NEEDS_A_NAME";
        public const string TRACK_NEEDS_AN_MP3 = "TRACK_NEEDS_AN_MP3";
        public const string TRACK_NEEDS_A_VALID_MP3 = "TRACK_NEEDS_A_VALID_MP3";
        public const string TRACK_NEEDS_AN_ARTIST = "TRACK_NEEDS_AN_ARTIST";

        public const string NEWSITEM_NEEDS_A_NAME = "NEWSITEM_NEEDS_A_NAME";
        public const string NEWSITEM_NAME_IS_TOO_LONG = "NEWSITEM_NAME_IS_TOO_LONG";
        public const string NEWSITEM_NEEDS_A_DESCRIPTION = "NEWSITEM_NEEDS_A_DESCRIPTION";
        public const string NEWSITEM_DESCRIPTION_IS_TOO_LONG = "NEWSITEM_DESCRIPTION_IS_TOO_LONG";
        public const string NEWSITEM_NEEDS_A_BODY = "NEWSITEM_NEEDS_A_BODY";
        public const string NEWSITEM_BODY_IS_TOO_LONG = "NEWSITEM_BODY_IS_TOO_LONG";
        public const string NEWSITEM_SHOULD_BE_PUBLISHED_TO_AT_LEAST_ONE_SITE = "NEWSITEM_SHOULD_BE_PUBLISHED_TO_AT_LEAST_ONE_SITE";

        public const string FILE_IS_NOT_AN_IMAGE = "FILE_IS_NOT_AN_IMAGE";
        public const string FILE_NEEDS_DATA = "FILE_NEEDS_DATA";

        public const string USERPROFILE_FORENAME_IS_TOO_LONG = "USERPROFILE_FORENAME_IS_TOO_LONG";
        public const string USERPROFILE_SURNAME_IS_TOO_LONG = "USERPROFILE_SURNAME_IS_TOO_LONG";
        public const string USERPROFILE_PROFILE_IS_TOO_LONG = "USERPROFILE_PROFILE_IS_TOO_LONG";

        public const string VENUE_NEEDS_NAME = "VENUE_NEEDS_NAME";
        public const string VENUE_NAME_IS_TOO_LONG = "VENUE_NAME_IS_TOO_LONG";

    }
}
