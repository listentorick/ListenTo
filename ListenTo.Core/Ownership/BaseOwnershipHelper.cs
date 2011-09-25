using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.Interfaces.Ownership;

namespace ListenTo.Core.Ownership
{
    public class BaseOwnershipHelper
    {
        public IUserManager UserManager { get; set; }

        public bool IsOwner<T,U>(U domainObject, UserCredentials userCredentials, T manager)
            where T : IManager<U>
            where U : BaseDO
        {
            bool isOwner = false;
            User validatedUser = null;
            if (UserManager.ValidateUser(userCredentials.Username, userCredentials.Password))
            {
                validatedUser = UserManager.GetUserByUsername(userCredentials.Username);

                if (validatedUser != null)
                {
                    BaseDO domainObjectFromRepository = manager.GetByID(domainObject.ID);

                    if (domainObjectFromRepository != null)
                    {
                        //This object exists in the repository so we ne too validate...
                        isOwner = domainObjectFromRepository.OwnerID == validatedUser.ID;
                    }
                    else
                    {   //Since the user has obviously just created this object, they are the owner...
                        isOwner = true;
                    }

                }
            }
            return isOwner;
        }
    }
}
