using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DO
{
    public class Artist : BaseDO, INamedDO
    {
        public string Name { get; set; }
        public string Profile { get; set; }
        public DateTime Formed { get; set; }
        public Style Style { get; set; }
        public Town Town { get; set; }
        public string OfficalWebsiteURL { get; set; }
        public string ProfileAddress { get; set; }
        public string Email { get; set; }
        public ImageMetaData ProfileImage { get; set; }
       
    }
}