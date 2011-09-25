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
using System.Collections.Generic;

namespace ListenTo.Web.Models
{
    public class VenueIndexViewModel 
    {
        public Venue Venue { get; set; }
        public IList<Gig> UpcomingGigs { get; set; }
        public IList<Gig> RecentGigs { get; set; }
    }
}
