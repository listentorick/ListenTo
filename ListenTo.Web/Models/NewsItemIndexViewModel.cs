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
using ListenTo.Shared.DO;

namespace ListenTo.Web.Models
{
    public class NewsItemIndexViewModel
    {
        public IList<CommentSummary> Comments { get; set; }
        public AddCommentViewModel AddCommentViewModel { get; set; }
        public NewsItem NewsItem { get; set; }
        public UserProfile AuthorUserProfile { get; set; }
    }
}
