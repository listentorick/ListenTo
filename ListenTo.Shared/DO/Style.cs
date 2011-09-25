using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DO
{
    public class Style : BaseDO, INamedDO
    {
        public string Name
        {
            get;
            set;
        }

    }
}
