using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class TownFilters
    {

        public static IQueryable<Town> WithID(this IQueryable<Town> qry, Guid Id)
        {
            return from town in qry
                   where town.ID == Id
                   select town;
        }
    }
}
