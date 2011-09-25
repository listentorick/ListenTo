using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Ownership;

namespace ListenTo.Core.Ownership
{
    /// <summary>
    /// This helper implements the same interface as those helpers that the factory is aware of..
    /// It wraps additional logic of interogating the factory etc 
    /// </summary>
    public class OwnershipHelper : IOwnershipHelper
    {
        public IOwnershipHelperFactory OwnershipHelperFactory { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="baseDO"></param>
        /// <param name="userCredentials">The credentials of the user who wants to access the object</param>
        /// <returns></returns>
        public bool IsOwner(ListenTo.Shared.DO.BaseDO baseDO, UserCredentials userCredentials)
        {
            IOwnershipHelper helper = OwnershipHelperFactory.CreateHelper(baseDO);

            if (helper == null)
            {
                throw new Exception("There isnt a IOwnershipHelper defined for this");
            }

            bool isOwner = helper.IsOwner(baseDO, userCredentials);

            if (isOwner == false)
            {
                throw new Exception("The user does not own this object");
            }

            return isOwner;
        }
    }
}
