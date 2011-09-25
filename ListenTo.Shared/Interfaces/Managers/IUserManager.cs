using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface IUserManager : IManager<User>
    {
        bool ValidateUser(string username, string password);
        User GetUserByUsername(string username);
        void NewUserStrategy(IDO dO, UserCredentials userCredentials);
        bool Approve(string key);
        User GetUserByEmailAddress(string emailAddress);
        void RetrieveDetailsFromEmailAddress(string emailAddress, UserCredentials userCredentials);
    }
}
