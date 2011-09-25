using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.DTO;

namespace ListenTo.Shared.EqualityComparers
{
    public class DTOEqualityComparer : IEqualityComparer<BaseDTO>
    {
        #region IEqualityComparer<BaseDTO> Members

        public bool Equals(BaseDTO x, BaseDTO y)
        {
            return x.ID == y.ID;
        }

        public int GetHashCode(BaseDTO obj)
        {
            return obj.ID.GetHashCode();
        }

        #endregion
    }
}

