using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DTO
{
    /// <summary>
    /// This will be used for generating summary lists of tracks
    /// </summary>
    public class TrackSummary : BaseDTO, IOwnableDO
    {
      
        public string Name { get; set; }
        public string Description { get; set; }
        public Guid OwnerID { get; set; }
        public string OwnerUsername { get; set; }
        public ImageMetaData OwnerThumbnail { get; set; }

        public Guid ArtistId { get; set; }
        public string ArtistName { get; set; }
        public string ArtistProfileAddress { get; set; }
        public ImageMetaData ArtistThumbnail { get; set; }

        public Guid StyleId { get; set; }
        public string StyleName { get; set; }
        public Guid SiteId { get; set; }
        public DateTime Created { get; set; }
    }
}
