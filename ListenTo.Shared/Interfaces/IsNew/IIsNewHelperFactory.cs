using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.IsNew
{
    public interface IIsNewHelperFactory
    {
        IIsNewHelper CreateHelper(BaseDO o);
    }
}
