using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Helpers;
using System.Collections;
using ListenTo.Shared.Interfaces.Mail;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Interfaces.Helpers;

namespace ListenTo.Core.Mail
{
    public class RetrieveDetailsStrategy : IRetrieveDetailsStrategy
    {
        public ListenTo.Shared.Interfaces.Mail.IEmailSender EmailSender { get; set; }
        public ITemplateEngine TemplateEngine { get; set; }

        public void RetrieveDetails(User user)
        {

            Hashtable templateParameters = new Hashtable();
            templateParameters.Add("User", user);

            string bodyTemplate = TemplateHelpers.GetRetrieveDetailsEmailBodyTemplate();
            string processedBodyTemplate = TemplateEngine.Process(bodyTemplate, templateParameters);

            string subjectTemplate = TemplateHelpers.GetRetrieveDetailsEmailSubjectTemplate();
            string processedSubjectTemplate = TemplateEngine.Process(subjectTemplate, templateParameters);

            EmailSender.Send(MailHelpers.GetSourceEmailAddressForOutboundMail(), user.EmailAddress, processedSubjectTemplate, processedBodyTemplate);

        }
    }
}
