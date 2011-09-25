using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.Interfaces.Do;

namespace ListenTo.Shared.DO
{
    /// <summary>
    ///This user is essentially our applications user/profile/credentials 
    // This object should be passed to all Managers so that authentication/auditing/logging etc can take place 
    /// </summary>
    public class User : BaseDO, IUserCredentials
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string EmailAddress { get; set; }
        public bool  IsValidated { get; set; }


    }
}
