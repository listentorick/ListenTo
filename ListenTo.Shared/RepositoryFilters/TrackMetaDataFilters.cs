using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class TrackMetaDataFilters
    {
        public static IQueryable<TrackMetaData> WithID(this IQueryable<TrackMetaData> qry, Guid Id)
        {
            return from trackMetaData in qry
                   where trackMetaData.ID == Id
                   select trackMetaData;
        }
    }
}
