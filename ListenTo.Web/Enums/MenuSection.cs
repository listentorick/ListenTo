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

namespace ListenTo.Web.Enums
{
    /// <summary>
    /// Enumeration used to represent different sections of the application
    /// </summary>
    public enum MenuSection
    {
        HOME, GIGS, ARTISTS, TRACKS, NEWSITEMS, ACCOUNTS, NA, CONTENT
    }
}
