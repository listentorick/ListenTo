using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Do
{
    public interface IUserCredentials
    {
         string Username { get; set; }
         string Password { get; set; }
    }
}
