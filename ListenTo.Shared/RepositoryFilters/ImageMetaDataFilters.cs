using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class ImageMetaDataFilters
    {
        public static IQueryable<ImageMetaData> WithID(this IQueryable<ImageMetaData> qry, Guid Id)
        {
            return from imageMetaData in qry
                   where imageMetaData.ID == Id
                   select imageMetaData;
        }
    }
}
