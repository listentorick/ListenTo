using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class VenueFilters
    {

        public static IQueryable<Venue> WithID(this IQueryable<Venue> qry, Guid Id)
        {
            return from venue in qry
                   where venue.ID == Id
                   select venue;
        }


        public static IQueryable<Venue> NameLike(this IQueryable<Venue> qry, string name)
        {
            return from venue in qry
                   where venue.Name.Contains(name)
                   select venue;
        }

    }
}
