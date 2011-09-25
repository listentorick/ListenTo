using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.DO
{
    public class ImageMetaData : BaseDO
    {
        public string Caption { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public ImageMetaData Thumbnail { get; set; }

    }
}
