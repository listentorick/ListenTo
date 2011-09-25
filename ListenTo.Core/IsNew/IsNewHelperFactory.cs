using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.IsNew;

namespace ListenTo.Core.IsNew
{
    public class IsNewHelperFactory : IIsNewHelperFactory
    {

        #region Ownership Helpers

        /// <summary>
        /// A list of OwnershipHelpers
        /// </summary>
        public IDictionary<Type, IIsNewHelper> IsNewHelpers { get; set; }

        #endregion

        #region IComponentHelperFactory Members

        public IIsNewHelper CreateHelper(BaseDO o)
        {
            IIsNewHelper foundHelper = null;
            this.HasHelper(o, out foundHelper);
            return foundHelper;
        }

        public bool HasHelper(object o, out IIsNewHelper isNewHelper)
        {
            //Check Direct Types
            Type type = o.GetType();
            isNewHelper = null;
            if (this.IsNewHelpers.ContainsKey(type))
            {
                isNewHelper = this.IsNewHelpers[o.GetType()];
            }
            return isNewHelper != null;
        }

        #endregion
    }
}
