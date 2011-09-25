using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Interfaces.DO
{
    public interface IDeleteableDO
    {
        bool IsDeleted
        {
            get;
            set;
        }
    }
}
