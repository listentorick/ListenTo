using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.EqualityComparers
{
    public class DOEqualityComparer : IEqualityComparer<BaseDO>
    {
        #region IEqualityComparer<BaseDO> Members

        public bool Equals(BaseDO x, BaseDO y)
        {
            return x.ID == y.ID;
        }

        public int GetHashCode(BaseDO obj)
        {
            return obj.ID.GetHashCode();
        }

        #endregion
    }
}

