using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class GigFilters
    {

        public static IQueryable<Gig> WithID(this IQueryable<Gig> qry, Guid Id)
        {
            return from gig in qry
                   where gig.ID == Id
                   select gig;
        }

        public static IQueryable<Gig> WithID(this IQueryable<Gig> qry, IQueryable<Guid> Ids)
        {
            return from gig in qry
                   where Ids.Contains(gig.ID)
                   select gig;
        }

        public static IQueryable<Gig> AtVenue(this IQueryable<Gig> qry, Guid venueId)
        {
            return from gig in qry
                   where gig.Venue.ID == venueId
                   select gig;
        }

        public static IQueryable<Gig> OnDate(this IQueryable<Gig> qry, DateTime date)
        {
            return from gig in qry
                   where gig.StartDate == date
                   select gig;
        }


        public static IQueryable<Gig> AfterDate(this IQueryable<Gig> qry, DateTime date)
        {
            return from gig in qry
                   where gig.StartDate >= date
                   select gig;
        }

        public static IQueryable<Gig> BeforeDate(this IQueryable<Gig> qry, DateTime date)
        {
            return from gig in qry
                   where gig.StartDate < date
                   select gig;
        }


        public static IQueryable<Gig> EarliestFirst(this IQueryable<Gig> qry)
        {
            return from gig in qry
                   orderby gig.StartDate 
                   select gig;
        }

        public static IQueryable<Gig> WithArtist(this IQueryable<Gig> qry, Guid artistId)
        {
            return from gig in qry
                   //where gig.Acts.Any(act => (null != act.Artist) && (act.Artist.ID == artistId))
                    where gig.Acts.Any(act => act.ID == artistId)
                    //where gig.Acts.Count(a => a.Artist != null && a.Artist.ID == artistId) 
                   //where gig.Acts.ToList().Any(act => act.ID == artistId)
                   orderby gig.StartDate
                   select gig;
        }

    }
}
