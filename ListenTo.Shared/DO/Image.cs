using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Do;

namespace ListenTo.Shared.DO
{
    public class Image : ImageMetaData, IHasBinaryData
    {
        public byte[] Data { get; set; }
       
    }
}
