using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.DO
{
    /// <summary>
    /// An example of where used... the page displaying the track info. We dont need the byte data here though
    /// </summary>
    public class TrackMetaData : BaseDO
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public Style Style { get; set; }
        public Artist Artist { get; set; }
        public string Engineer { get; set; }
        public string Studio { get; set; }
        public string Producer { get; set; }
    }
}
