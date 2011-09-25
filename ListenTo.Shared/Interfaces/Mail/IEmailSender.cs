using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Mail
{
    public interface IEmailSender
    {
        void Send(string from, string to, string subject, string message);
    }
}
