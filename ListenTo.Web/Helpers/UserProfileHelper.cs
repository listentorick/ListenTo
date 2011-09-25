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
using ListenTo.Shared.DTO;

namespace ListenTo.Web.Helpers
{
    public static class UserProfileHelper
    {
        public static bool UserProfileHasStyle(UserProfile userProfile, StyleSummary s)
        {
            bool hasStyle = false;

            foreach (ListenTo.Shared.DO.Style userStyle in userProfile.Styles)
            {
                if (userStyle.ID == s.ID)
                {
                    hasStyle = true;
                    break;
                }
            }

            return hasStyle;
        }
    }
}
