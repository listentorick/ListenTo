using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ListenTo.Shared.DO;

namespace ListenTo.Web.Models
{
    public class UploadImageViewModel
    {
        public UploadFilePartialViewModel UploadFilePartialViewModel { get; set; }
        public bool ImageUploadSuccesful { get; set; }
        public Image Image { get; set; }
    }
}
