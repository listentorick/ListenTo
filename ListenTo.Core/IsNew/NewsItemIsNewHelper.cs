using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.Interfaces.IsNew;

namespace ListenTo.Core.IsNew
{
    public class NewsItemIsNewHelper: IIsNewHelper
    {
        #region IIsNewHelper Members

        public INewsItemManager NewsItemManager { get; set; }

        /// <summary>
        /// Is this newsItem considered to be new? In this case we treat a newsItem to be new if it isnt stored in the db
        /// </summary>
        /// <param name="baseDO"></param>
        /// <param name="userCredentials"></param>
        /// <returns></returns>
        public bool IsNew(ListenTo.Shared.DO.BaseDO baseDO, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            return NewsItemManager.GetByID(baseDO.ID) == null;
        }

        #endregion
    }
}
