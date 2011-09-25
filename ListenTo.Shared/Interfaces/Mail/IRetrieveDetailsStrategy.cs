using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Mail
{
    public interface IRetrieveDetailsStrategy
    {
        void RetrieveDetails(User user);
    }
}
