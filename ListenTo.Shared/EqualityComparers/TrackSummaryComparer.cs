using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.DTO;

namespace ListenTo.Shared.EqualityComparers
{
    public class TrackSummaryEqualityComparer : IEqualityComparer<TrackSummary>
    {
        #region IEqualityComparer<TrackSummary> Members

        public bool Equals(TrackSummary x, TrackSummary y)
        {
            return x.ID == y.ID;
        }

        public int GetHashCode(TrackSummary obj)
        {
            return obj.ID.GetHashCode();
        }

        #endregion
    }
}

