using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace ListenTo.Shared.Helpers
{
    public class MailHelpers
    {
        public static string GetSourceEmailAddressForOutboundMail()
        {
            return "info@listentomanchester.co.uk";
        }
    }
}
