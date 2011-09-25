using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces;
using System.Collections;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Interfaces.Mail;

namespace ListenTo.Core.Actions
{
    public class SmtpPublisher : IActionPublisher
    {
        public IUsersToInformAboutActionResolver UsersToInformAboutActionResolver { get; set; }
        public ITemplateEngine TempateEngine { get; set; }
        public string BodyTemplateFilename { get; set; }
        public string SubjectTemplateFilename { get; set; }
        public IActionDataHelper ActionDataHelper { get; set; }
        public IEmailSender EmailSender { get; set; }
        
        #region IActionPublisher Members

        public void Publish(ListenTo.Shared.DO.Action action)
        {
            object data = ActionDataHelper.GetActionData(action);
            action.ActionData = data;

            IList<UserProfile> usersToEmail = UsersToInformAboutActionResolver.ResolveUsersToInformAboutAction(action);

            Hashtable templateParameters = null;
            string bodyTemplate;
            string subjectTemplate;

            foreach(UserProfile profile in usersToEmail){

                //Check that we have an email address and ensure we dont email the owner of the content!
                if(profile.Email!=string.Empty && profile.ID!=action.OwnerID){

                    try
                    {

                        templateParameters = new Hashtable();
                        templateParameters.Add("Action", action);
                        templateParameters.Add("UsersToEmail", usersToEmail);

                        //This shouldnt be static!
                        bodyTemplate = TemplateHelpers.GetTemplateFromFilename(BodyTemplateFilename);

                        //This shouldnt be static!
                        subjectTemplate = TemplateHelpers.GetTemplateFromFilename(SubjectTemplateFilename);

                        subjectTemplate = TempateEngine.Process(subjectTemplate, templateParameters);

                        bodyTemplate = TempateEngine.Process(bodyTemplate, templateParameters);

                        EmailSender.Send(MailHelpers.GetSourceEmailAddressForOutboundMail(), profile.Email, subjectTemplate, bodyTemplate);
                    }
                    catch (Exception e)
                    {
                        //swallow this and log it
                        //just because one of the emails failed doesnt men we dont want the others sent..
                        
                    }
                }
            }
        }

        #endregion
    }
}
