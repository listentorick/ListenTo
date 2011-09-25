using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Interfaces.DO
{
    public interface INamedDO
    {
        Guid ID
        {
            get;
            set;
        }

        string Name
        {
            get;
            set;
        }

    }
}