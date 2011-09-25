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
using ListenTo.Shared.DTO;
using System.Collections.Generic;

namespace ListenTo.Web.Models
{
    public class RadioViewModel
    {
        public IList<StyleSummary> Styles { get; set; }
        public Player Player { get; set; }
        public IList<StyleSummary> StylesToSelect { get; set; }


    }
}
