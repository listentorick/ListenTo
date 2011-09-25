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
using ListenTo.Shared.DTO;
using System.Collections.Generic;

namespace ListenTo.Web.Models
{
    public class EditProfileViewModel
    {
        public UserProfile UserProfile { get; set; }
        public IList<StyleSummary> StyleSummaries { get; set; }
        public UploadImagePopupViewModel UploadImagePopupViewModel { get; set; }
    }
}
