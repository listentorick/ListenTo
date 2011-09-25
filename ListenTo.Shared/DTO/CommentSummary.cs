using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Shared.DTO
{
    public class CommentSummary:IDTO
    {
        public Guid ID { get; set; }
        public string Body { get; set; }
        public Guid OwnerId { get; set; }
        public string OwnerUsername {get;set;}
        public ImageMetaData OwnerThumbnail { get; set; }
        public Guid TargetId { get; set; }
        public DateTime Created { get; set; }
    }
}
