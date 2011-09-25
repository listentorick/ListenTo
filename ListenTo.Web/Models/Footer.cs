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
using System.Collections.Generic;
using ListenTo.Shared.DO;
using ListenTo.Shared.DTO;

namespace ListenTo.Web.Models
{
    public class Footer
    {
        public IList<ArtistSummary> Artists { get; set; }
        public IList<Gig> Gigs { get; set; }
    }
}
