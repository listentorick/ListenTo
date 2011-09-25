using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ListenTo.Shared.DO;

namespace ListenTo.Web.Models
{
    public class AddArtistViewModel
    {
        public Artist Artist { get; set; }
        public UploadImagePopupViewModel UploadImagePopupViewModel { get; set; }
    }
}
