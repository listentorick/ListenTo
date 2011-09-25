using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Do;

namespace ListenTo.Shared.DO
{
    public class Track: TrackMetaData, IHasBinaryData
    {
        public byte[] Data { get; set; }

    }
}
