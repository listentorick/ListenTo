using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Actions
{
    /// <summary>
    /// This is part of the smtp action publisher - it is used to resolve a list of users to inform
    /// of the action
    /// </summary>
    public interface IUsersToInformAboutActionResolver
    {
        /// <summary>
        /// This should return a list of userprofiles belonging to the users we should inform of this action
        /// The default resolver will inform the owner of the action 
        /// </summary>
        /// <param name="action"></param>
        /// <returns></returns>
        IList<UserProfile> ResolveUsersToInformAboutAction(ListenTo.Shared.DO.Action action);
    }
}
