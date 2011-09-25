using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class StyleFilters
    {

        public static IQueryable<Style> WithID(this IQueryable<Style> qry, Guid Id)
        {
            return from style in qry
                   where style.ID == Id
                   select style;
        }

        public static IQueryable<Style> WithName(this IQueryable<Style> qry, string name)
        {
            return from style in qry
                   where style.Name.ToLower().Trim() == name.ToLower().Trim()
                   select style;
        }

        
    }
}
