using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class ImageFilters
    {

        public static IQueryable<Image> WithID(this IQueryable<Image> qry, Guid Id)
        {
            return from image in qry
                   where image.ID == Id
                   select image;
        }
    }
}
