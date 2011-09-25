using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Enums;
using ListenTo.Shared.Interfaces.Actions;

namespace ListenTo.Core.Actions
{
    public class ActionDataHelperFactory: IActionDataHelperFactory
    {

        #region Ownership Helpers
        
        /// <summary>
        /// A list of OwnershipHelpers
        /// </summary>
        public IDictionary<string, IActionDataHelper> ActionDataHelpers { get; set; }

        #endregion


        #region IActionDataHelperFactory Members

        public IActionDataHelper CreateHelper(ListenTo.Shared.DO.Action action)
        {
            IActionDataHelper foundHelper = null;

            string actionName = Enum.GetName(typeof(ActionType), action.ActionType); 

            if (this.ActionDataHelpers.ContainsKey(actionName))
            {
                foundHelper = this.ActionDataHelpers[actionName];
            }

            return foundHelper;
        }

        #endregion

    }
}
