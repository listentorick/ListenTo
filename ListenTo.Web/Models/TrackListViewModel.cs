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
using ListenTo.Shared.DTO;
using ListenTo.Shared.Utility;

namespace ListenTo.Web.Models
{
    public class TrackListViewModel
    {
        public TagCloudViewModel StyleTagCloudViewModel {get;set;}
        public IPageOfList<TrackSummary> Tracks { get; set; }
        public ListenTo.Shared.DO.Style StyleFilter { get; set; }
    }
}
