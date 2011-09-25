using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Mail
{
    public interface IUserApprovalStrategy
    {
        void RequestApproval(User user);
        User Approve(string key);
    }
}
