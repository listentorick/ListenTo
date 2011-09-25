using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Ownership
{
    public interface IOwnershipHelperFactory
    {
        IOwnershipHelper CreateHelper(BaseDO o);
    }
}
