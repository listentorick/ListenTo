using System;
using System.Net.Mail;
using System.Text;
using System.Net;


namespace ListenTo.Core.Mail
{

    /// <summary>
    /// Sends email via SMTP
    /// </summary>
	public class SmtpEmailSender : ListenTo.Shared.Interfaces.Mail.IEmailSender
	{
         public string Host { get; set; }
         public int Port { get; set; }
         public string AuthenticationUsername { get; set; }
         public string AuthenticationPassword { get; set; }

		public void Send(string from, string to, string subject, string message)
		{

           // if (ListenTo.Shared.Helpers.FormatHelpers.IsEmail(from) && ListenTo.Shared.Helpers.FormatHelpers.IsEmail(to))
		//	{
            MailMessage msgMail = new MailMessage(from, to, subject, message);
            SmtpClient client = new SmtpClient(this.Host, this.Port);
            client.Credentials = new NetworkCredential(AuthenticationUsername, AuthenticationPassword);
            client.Send(msgMail);
		//	}
		//	else
		//	{

		//	}
		}
	}
}
