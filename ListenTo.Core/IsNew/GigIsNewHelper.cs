using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Interfaces.IsNew;
using ListenTo.Shared.DO;

namespace ListenTo.Core.IsNew
{
    public class GigIsNewHelper : IIsNewHelper
    {
        #region IIsNewHelper Members

        public IGigManager GigManager { get; set; }

        /// <summary>
        /// Is this gig considered to be new? In this case we treat a newsItem to be new if it isnt stored in the db
        /// </summary>
        /// <param name="baseDO"></param>
        /// <param name="userCredentials"></param>
        /// <returns></returns>
        public bool IsNew(ListenTo.Shared.DO.BaseDO baseDO, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            return GigManager.GetByID(baseDO.ID) == null;
        }

        #endregion
    }
}
