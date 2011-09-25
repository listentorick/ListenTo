using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class ActFilters
    {

        public static IQueryable<Act> WithGigID(this IQueryable<Act> qry, Guid Id)
        {
            return from act in qry
                   where act.GigId == Id
                   select act;
        }

        public static IQueryable<Act> WithArtistID(this IQueryable<Act> qry, Guid Id)
        {
            return from act in qry
                   where act.Artist !=null && act.Artist.ID == (Guid?)Id
                   select act;
        }
    }
}
