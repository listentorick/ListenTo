using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Repository;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Validation;
using ListenTo.Shared.Interfaces.IsNew;
using ListenTo.Shared.Interfaces.Ownership;

namespace ListenTo.Core.Managers
{
    public class BaseManager
    {
        public IValidationRunner ValidationRunner { get;set; }

        public IRepositoryFactory RepositoryFactory { get; set; }
        public IRepository Repository { get { return RepositoryFactory.GetRepository(); } }
        public IOwnershipHelperFactory OwnershipHelperFactory { get; set; }
        public IIsNewHelperFactory IsNewHelperFactory { get; set; }
       
        public bool CheckOwnership(ListenTo.Shared.DO.BaseDO baseDO, UserCredentials userCredentials)
        {
            IOwnershipHelper helper = OwnershipHelperFactory.CreateHelper(baseDO);
            bool isOwner = helper.IsOwner(baseDO, userCredentials);

            if (isOwner == false)
            {
                throw new Exception("The user does not own this object");
            }

            return isOwner;
        }

        public bool CheckIsNew(ListenTo.Shared.DO.BaseDO baseDO, UserCredentials userCredentials)
        {
            IIsNewHelper helper = IsNewHelperFactory.CreateHelper(baseDO);

            if (helper == null)
            {
                throw new Exception("There isnt a IsNewHelper defined for this");
            }

            bool isNew = helper.IsNew(baseDO, userCredentials);

            return isNew;
        }
    }
}
