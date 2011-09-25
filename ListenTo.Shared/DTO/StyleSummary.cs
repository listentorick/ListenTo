using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Shared.DTO
{
    public class StyleSummary : IDTO
    {
        public Guid ID { get; set; }
        public string Name { get; set; }
        public int NumberOfArtists { get; set; }
        public int NumberOfTracks { get; set; }

    }
}
