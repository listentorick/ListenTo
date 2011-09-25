using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Ownership;

namespace ListenTo.Core.Ownership
{
    public class OwnershipHelperFactory : IOwnershipHelperFactory
    {

        #region Ownership Helpers
        
        /// <summary>
        /// A list of OwnershipHelpers
        /// </summary>
        public IDictionary<Type, IOwnershipHelper> OwnershipHelpers { get; set; }

        #endregion

        #region IComponentHelperFactory Members

        public IOwnershipHelper CreateHelper(BaseDO o)
        {
            IOwnershipHelper foundHelper = null;
            this.HasComponentHelper(o, out foundHelper);
            return foundHelper;
        }

        public bool HasComponentHelper(object o, out IOwnershipHelper ownershipHelper)
        {
            //Check Direct Types
            Type type = o.GetType();
            ownershipHelper = null;
            if (this.OwnershipHelpers.ContainsKey(type))
            {
                ownershipHelper = this.OwnershipHelpers[o.GetType()];
            }
            return ownershipHelper != null;
        }

        #endregion
    }
}
