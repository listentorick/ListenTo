using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ListenTo.Web.Models
{
    public class RegisterUserViewModel
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string EmailAddress { get; set; }
        public string ConfirmEmailAddress { get; set; }
        public bool RecievesNewsletter { get; set; }
        public bool Policy { get; set; }
    }
}
