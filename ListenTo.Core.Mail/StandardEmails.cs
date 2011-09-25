//using System;
//using System.Threading;
//using ListenTo.Library.Security;
//using System.Configuration;
//using System.Collections;

//namespace ListenTo.Core.Mail
//{
//    /// <summary>
//    /// Summary description for StandardEmails.
//    /// </summary>
//    public class StandardEmails
//    {

//        //EMAIL Authentication Details

//        private string _smptpServer;
//        private string _emailAuthenticationUsername;
//        private string _emailAuthenticationPassword;

//        //EMAIL Templates

//        private string _emailTemplatePath;
//        private string _registrationEmailTemplateFilename;
//        private string _newsletterEmailTemplateFilename;
//        private string _forgottenLoginTemplateFilename;

//        private string _applicationPath;

//        public string SmptpServer
//        {
//            get{return _smptpServer;}
//        }

//        public string EmailAuthenticationUsername
//        {
//            get{return _emailAuthenticationUsername;}
//        }

//        public string EmailAuthenticationPassword
//        {
//            get{return _emailAuthenticationPassword;}
//        }

//        public string EmailTemplatePath
//        {
//            get{return _emailTemplatePath;}
//        }

//        public string RegistrationEmailTemplateFilename
//        {
//            get{return _registrationEmailTemplateFilename;}
//        }

//        public string NewsletterEmailTemplateFilename
//        {
//            get{return _newsletterEmailTemplateFilename;}
//        }

//        public string ForgottenLoginTemplateFilename
//        {
//            get{return _forgottenLoginTemplateFilename;}
//        }
		

//        public string ApplicationPath
//        {
//            get{return _applicationPath;} 
//        }

//        public StandardEmails(string applicationPath)
//        {
		
//            _smptpServer = ConfigurationSettings.AppSettings["SmptpServer"];
//            _emailAuthenticationUsername = ConfigurationSettings.AppSettings["EmailAuthenticationUsername"];
//            _emailAuthenticationPassword = ConfigurationSettings.AppSettings["EmailAuthenticationPassword"];
			
//            _emailTemplatePath = ConfigurationSettings.AppSettings["EmailTemplatePath"];

//            _registrationEmailTemplateFilename = ConfigurationSettings.AppSettings["RegistrationEmailTemplateFilename"];
//            _newsletterEmailTemplateFilename = ConfigurationSettings.AppSettings["NewsletterEmailTemplateFilename"];
//            _forgottenLoginTemplateFilename = ConfigurationSettings.AppSettings["ForgottenLoginTemplateFilename"];

//            _applicationPath = applicationPath;
//        }

//        public void SendRegistrationConfirmationEmail(UserIdentity userIdentity)
//        {
		
//            System.IO.FileInfo templateFile = null;
//            System.IO.TextReader templateTextReader = null;

//            string registrationEmailTemplateFilename = this.ApplicationPath + this._emailTemplatePath + this.RegistrationEmailTemplateFilename;
			
//            //Load the template
//            try
//            {
//                    templateFile = new System.IO.FileInfo(registrationEmailTemplateFilename);
//                    templateTextReader = templateFile.OpenText();

//                    SmtpEmailSender emailSender = new SmtpEmailSender(this.SmptpServer,0,this.EmailAuthenticationUsername,this.EmailAuthenticationPassword);

//                    Email listenToRegistrationConfirmationEmail = new Email(emailSender,this.EmailAuthenticationUsername,templateTextReader.ReadToEnd().ToString());
						
//                    //Create Hashtable for the template
//                    Hashtable templateParameters = new Hashtable();
//                    templateParameters.Add("UserIdentity",userIdentity);

//                    //Create Recipient
//                    Recipient recipient = new Recipient(userIdentity.EmailAddress,"Welcome to ListenTo",templateParameters);
//                    listenToRegistrationConfirmationEmail.Recipients.Add(recipient);
						
//                    listenToRegistrationConfirmationEmail.Send();
//                //}

//            }
//            catch(System.Exception e)
//            {
				
//                throw e;
//                //((ListenToPage)this.Page).HandleError("Error sending Registration confirmation email: " + e.Message.ToString());
//            }
//            finally
//            {
//                if(templateTextReader!=null) templateTextReader.Close();
				
			
//            }
//        }


//        public void SendForgottenLoginEmail(UserIdentity userIdentity)
//        {
		
//            System.IO.FileInfo templateFile = null;
//            System.IO.TextReader templateTextReader = null;

//            string forgottenLoginTemplateFilename = this.ApplicationPath + this._emailTemplatePath + this.ForgottenLoginTemplateFilename;
			
//            //Load the template
//            try
//            {
//                templateFile = new System.IO.FileInfo(forgottenLoginTemplateFilename);
//                templateTextReader = templateFile.OpenText();

//                SmtpEmailSender emailSender = new SmtpEmailSender(this.SmptpServer,0,this.EmailAuthenticationUsername,this.EmailAuthenticationPassword);

//                Email listenToForgottenLoginEmail = new Email(emailSender,this.EmailAuthenticationUsername,templateTextReader.ReadToEnd().ToString());
					
//                //Load the UserIdentity object 
//                //Create Hashtable for the template
//                Hashtable templateParameters = new Hashtable();
//                templateParameters.Add("UserIdentity",userIdentity);

//                //Create Recipient
//                Recipient recipient = new Recipient(userIdentity.EmailAddress,"Forgotten ListenTo Login Details",templateParameters);
//                listenToForgottenLoginEmail.Recipients.Add(recipient);
					
//                listenToForgottenLoginEmail.Send();

				
//                //}

//            }
//            catch(System.Exception e)
//            {
//                throw e;
//                //((ListenToPage)this.Page).HandleError("Error sending forgotten login details email: " + e.Message.ToString());
//            }
//            finally
//            {
//                if(templateTextReader!=null) templateTextReader.Close();
				
			
//            }
		
//        }
//    }
//}
