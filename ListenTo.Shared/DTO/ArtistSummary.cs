using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DTO
{
    public class ArtistSummary: IDTO, IOwnableDO
    {
        public Guid ID { get; set; }
        public string Name { get; set; }
        public string ProfileAddress { get; set; }
        public ImageMetaData Thumbnail { get; set; }
        public Guid OwnerID { get; set; }
        public string OwnerUsername { get; set; }
        public DateTime Created { get; set; }
        public Guid StyleID { get; set; }
        public string StyleName { get; set; }
        public string TownName { get; set; }
        public Guid SiteId { get; set; }

    }
}
