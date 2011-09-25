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

namespace ListenTo.Web.Models
{
    public class TagViewModel
    {
        public string Tag { get; set; }
        public int Count { get; set; }
        public string URL { get; set; }
    }
}
