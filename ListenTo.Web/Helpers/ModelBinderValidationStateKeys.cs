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

namespace ListenTo.Web.Helpers
{
    public static class ModelBinderValidationStateKeys
    {
        public const string USER_PASSWORDS_DONT_MATCH = "USER_PASSWORDS_DONT_MATCH";
        public const string USER_EMAILS_DONT_MATCH = "USER_EMAILS_DONT_MATCH";
        public const string POLICY_NOT_APPROVED = "POLICY_NOT_APPROVED";
        public const string CANNOT_SPECIFY_VENUE_ID_AND_VENUE_NAME = "CANNOT_SPECIFY_VENUE_ID_AND_VENUE_NAME";
    }
}
