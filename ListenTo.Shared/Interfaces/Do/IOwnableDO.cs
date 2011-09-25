using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Interfaces.DO
{
    public interface IOwnableDO
    {
        Guid OwnerID
        {
            get;
            set;
        }
    }
}
