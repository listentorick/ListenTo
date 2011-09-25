using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface IUserProfileManager: IManager<UserProfile> 
    {
        UserProfile GetByUsername(string username);
        UserProfile SetUsersProfileImage(UserProfile userProfile, byte[] data, UserCredentials userCredentials);
    }
}
