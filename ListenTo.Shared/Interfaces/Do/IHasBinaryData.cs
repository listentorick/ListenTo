using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Do
{
    public interface IHasBinaryData
    {
        Guid ID
        {
            get;
            set;
        }

        byte[] Data { get; set; }
    }
}
