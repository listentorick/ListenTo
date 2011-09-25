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

namespace ListenTo.Web.Models
{
    public class ArtistIndexViewModel: ArtistViewModel
    {
        public IList<CommentSummary> Comments { get; set; }
        public Gig NextGig { get; set; }
        public UserProfile AuthorsUserProfile { get; set; }
        public FansPartialViewModel FansPartialViewModel { get; set; }
        public AddCommentViewModel AddCommentViewModel { get; set; }
    }
}
