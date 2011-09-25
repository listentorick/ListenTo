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
using ListenTo.Shared.Utility;
using ListenTo.Shared.DO;

namespace ListenTo.Web.Models
{
    /// <summary>
    /// The Model for the Artists Gigs View....
    /// </summary>
    public class ArtistsGigsViewModel: ArtistViewModel 
    {
        public IPageOfList<Gig> PreviousGigs { get; set; }
        public IPageOfList<Gig> UpcomingGigs { get; set; }
        public FansPartialViewModel FansPartialViewModel { get; set; }
     
    }
}
