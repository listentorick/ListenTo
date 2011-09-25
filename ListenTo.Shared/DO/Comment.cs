using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.Enums;

namespace ListenTo.Shared.DO
{
    public class Comment : BaseDO
    {
        public string Body { get; set; }
        public Guid TargetId { get; set; }
        public ContentType ContentType { get; set; }
    }
}