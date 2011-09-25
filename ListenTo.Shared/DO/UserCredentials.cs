using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Do;

namespace ListenTo.Shared.DO
{
    public class UserCredentials : IUserCredentials
    {
        public string Username { get; set; }
        public string Password { get; set; }
    }
}
