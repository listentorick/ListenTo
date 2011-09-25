using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Interfaces.DO
{
    public interface ISuspendableDO
    {
        bool IsSuspended
        {
            get;
            set;
        }
    }
}
