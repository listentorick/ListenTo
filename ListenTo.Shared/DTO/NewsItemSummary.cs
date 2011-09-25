using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DTO
{
    public class NewsItemSummary : IDTO, IOwnableDO
    {

        public Guid ID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public ImageMetaData Thumbnail { get; set; }
        public bool IsPublished { get; set; }
        public Guid OwnerID { get; set; }
        public string OwnerUsername { get; set; }
        public DateTime Created { get; set; }
    }
}
