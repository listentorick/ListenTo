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
using ListenTo.Shared.DO;
using System.Collections.Generic;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Web.Models
{
    public class WhoIsIndexViewModel
    {
        public IList<CommentSummary> Comments { get; set; }
        public UserProfile UserProfile { get; set; }
        public IList<ListenTo.Shared.DO.Action> UsersActions { get; set; }
        public BandsLikedPartialViewModel BandsLikedPartialViewModel { get; set; }
        public AddCommentViewModel AddCommentViewModel { get; set; }
          
    }
}
