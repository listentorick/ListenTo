using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class SiteFilters
    {

        public static IQueryable<Site> WithURL(this IQueryable<Site> qry, string URL)
        {
            return from site in qry
                   where site.URL == URL
                   select site;
        }

        public static IQueryable<Site> WithID(this IQueryable<Site> qry, IQueryable<Guid> Ids)
        {
            return from site in qry
                   where Ids.Contains(site.ID)
                   select site;
        }

    }
}
