using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Interfaces.DO
{
    public interface IDO
    {
        Guid ID
        {
            get; 
            set;
        }

        DateTime Created
        {
            get;
            set;
        }

    }
}
