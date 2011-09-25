using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Interfaces.IsNew;
using ListenTo.Shared.DO;

namespace ListenTo.Core.IsNew
{
    public class VenueIsNewHelper : IIsNewHelper
    {
        #region IIsNewHelper Members

        public IVenueManager VenueManager { get; set; }

        /// <summary>
        /// Is this venue considered to be new? In this case we treat a venue to be new if it isnt stored in the db
        /// </summary>
        /// <param name="baseDO"></param>
        /// <param name="userCredentials"></param>
        /// <returns></returns>
        public bool IsNew(ListenTo.Shared.DO.BaseDO baseDO, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            return VenueManager.GetByID(baseDO.ID) == null;
        }

        #endregion
    }
}
