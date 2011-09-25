using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Shared.DTO
{
    public class ArtistFanRelationshipSummary:IDTO
    {
        public Guid ID { get; set; }
        public Guid ArtistId { get; set; }
        public string ArtistName { get; set; }
        public string ArtistProfileAddress { get; set; }
        public ImageMetaData ArtistThumbnail { get; set; }
        public Guid UserId { get; set; }
        public string Username { get; set; }
        public ImageMetaData UserThumbnail { get; set; }

    }
}
