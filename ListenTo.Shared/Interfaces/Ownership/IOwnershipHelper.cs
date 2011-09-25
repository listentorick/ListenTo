using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Ownership
{
    public interface IOwnershipHelper
    {
        bool IsOwner(BaseDO domainObject, UserCredentials userCredentials);
    }
}
