using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.Interfaces.Managers;

namespace ListenTo.Core.Actions
{
    public class DefaultUsersToInformAboutActionResolver : IUsersToInformAboutActionResolver
    {
        public IUserProfileManager UserProfileManager { get; set; }

        #region IUsersToInformAboutActionResolver Members

        public IList<ListenTo.Shared.DO.UserProfile> ResolveUsersToInformAboutAction(ListenTo.Shared.DO.Action action)
        {
            throw new NotImplementedException();
        }

        #endregion
    }
}
