using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ListenTo.Shared.Enums;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Web.Models
{
    public class AddCommentViewModel : BaseListenToViewModel
    {
        public ContentType ContentType { get; set; }
        public Guid ContentTargetId { get; set; }
    }
}
