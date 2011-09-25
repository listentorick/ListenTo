using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DO
{
    public class Act : BaseDO
    {
        public Guid GigId { get; set; }
        public string Name { get; set; }
        public Artist Artist { get; set; }
    }
}
