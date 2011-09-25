using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Interfaces.Repository;
using ListenTo.Shared.DO;
using ListenTo.Shared.Validation;

namespace ListenTo.Core.Managers
{
    public class UserProfileManager : BaseManager, IUserProfileManager
    {
        #region IRepository
        public IImageManager ImageManager { get; set; }
        #endregion

        #region IManager<UserProfile> Members

        public ListenTo.Shared.DO.UserProfile GetByID(Guid id)
        {
            return this.Repository.GetUserProfile(id);
        }

        public ListenTo.Shared.DO.UserProfile Save(ListenTo.Shared.Interfaces.DO.IDO dO, UserCredentials userCredentials)
        {
           UserProfile userProfile = (UserProfile)dO;

           //This will throw an exception if the data model is invalid. 
           bool isValid = ValidationRunner.Validate(userProfile, userCredentials);

           this.Repository.SaveUserProfile(userProfile);
           return userProfile;
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }


        #endregion

        #region IUserProfileManager Members

        public UserProfile GetByUsername(string username)
        {
            return this.Repository.GetUserProfileByUsername(username);
        }

        #endregion

        public UserProfile SetUsersProfileImage(UserProfile userProfile, byte[] data, UserCredentials userCredentials)
        {
            ListenTo.Shared.DO.Image image = ImageManager.HandleUploadedImage(data, userCredentials);
            userProfile.ProfileImage = image;
            this.Save(userProfile, userCredentials);
            return userProfile;
        }
    }
}
