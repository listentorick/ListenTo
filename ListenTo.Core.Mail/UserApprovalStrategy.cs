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
    public class UserApprovalStrategy : IUserApprovalStrategy
    {
        public ListenTo.Shared.Interfaces.Mail.IEmailSender EmailSender { get; set; }
        public ITemplateEngine TemplateEngine { get; set; }
        public IUserManager UserManager { get; set; }
        public string EncryptionKey { get; set; }
        public IEncryptionHelper EncryptionHelper { get; set; }

        public void RequestApproval(User user) {

            //Lets Generate the Key
            string validationKey = EncryptionHelper.EncryptData(EncryptionKey, user.ID.ToString());

            Hashtable templateParameters = new Hashtable();
            templateParameters.Add("User", user);
            templateParameters.Add("Key", validationKey);

            string bodyTemplate = TemplateHelpers.GetRegistrationEmailBodyTemplate();
            string processedBodyTemplate = TemplateEngine.Process(bodyTemplate, templateParameters);

            string subjectTemplate = TemplateHelpers.GetRegistrationEmailSubjectTemplate();
            string processedSubjectTemplate = TemplateEngine.Process(subjectTemplate, templateParameters);

            EmailSender.Send(MailHelpers.GetSourceEmailAddressForOutboundMail(), user.EmailAddress, processedSubjectTemplate, processedBodyTemplate);
        
        }

        public User Approve(string key)
        {
            User user = null;

            try
            {
                string decryptedData = EncryptionHelper.DecryptData(this.EncryptionKey, key);
                //Currently we're using and encrypted hash of the users id
                if (ListenTo.Shared.Helpers.FormatHelpers.IsGuid(decryptedData))
                {
                    user = UserManager.GetByID(new Guid(decryptedData));
                    if (user != null)
                    {
                        user.IsValidated = true;
                    }
                }
            }
            catch (Exception e)
            {
                //Log....
                throw;
            }

            return user;
        }

    }
}
