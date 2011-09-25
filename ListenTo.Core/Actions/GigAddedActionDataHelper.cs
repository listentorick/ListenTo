using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.ActionData;

namespace ListenTo.Core.Actions
{
    public class GigAddedActionDataHelper : IActionDataHelper
    {
        public IGigManager GigManager { get; set; }

        #region IActionDataHelper Members

        public object GetActionData(ListenTo.Shared.DO.Action action)
        {
            GigAddedActionData gigAddedActionData = new GigAddedActionData();
            gigAddedActionData.Gig = GigManager.GetByID(action.ContentID);
            return gigAddedActionData;
        }

        #endregion
    }
}
