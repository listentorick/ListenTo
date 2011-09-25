using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.DO
{
    public class OwnerMetaData: BaseDO
    {
        public string Username { get; set; }
        public ImageMetaData ProfileImage { get; set; }
    }
}
