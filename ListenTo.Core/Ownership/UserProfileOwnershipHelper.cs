using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Ownership;

namespace ListenTo.Core.Ownership
{
    public class UserProfileOwnershipHelper: BaseOwnershipHelper, IOwnershipHelper
    {
        public IUserProfileManager UserProfileManager { get; set; }

        #region IOwnershipHelper Members

        public bool IsOwner(BaseDO domainObject, UserCredentials userCredentials)
        {
            return this.IsOwner<IUserProfileManager, UserProfile>((UserProfile)domainObject, userCredentials, UserProfileManager);
        }

        #endregion
    }
}
