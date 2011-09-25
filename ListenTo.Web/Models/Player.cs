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
using ListenTo.Shared.DTO;

namespace ListenTo.Web.Models
{
    public class Player
    {
        public IList<TrackSummary> PlayList { get; set; }
        public Guid? FirstTrackId { get; set; }
    }
}
