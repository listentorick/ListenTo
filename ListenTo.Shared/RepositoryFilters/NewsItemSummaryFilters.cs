using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DTO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class NewsItemSummaryFilters
    {

        public static IQueryable<NewsItemSummary> WithID(this IQueryable<NewsItemSummary> qry, Guid Id)
        {
            return from newsItemSummary in qry
                   where newsItemSummary.ID == Id
                   select newsItemSummary;
        }
 
        public static IQueryable<NewsItemSummary> WithID(this IQueryable<NewsItemSummary> qry, IQueryable<Guid> Ids)
        {
            return from newsItemSummary in qry
                   where Ids.Contains(newsItemSummary.ID)
                   select newsItemSummary;
        }

        public static IQueryable<NewsItemSummary> WithID(this IQueryable<NewsItemSummary> qry, IList<Guid> Ids)
        {
            return from newsItemSummary in qry
                   where Ids.Contains(newsItemSummary.ID)
                   select newsItemSummary;
        }

        public static IQueryable<NewsItemSummary> IsPublished(this IQueryable<NewsItemSummary> qry)
        {
            return from newsItemSummary in qry
                   where newsItemSummary.IsPublished == true
                   select newsItemSummary;
        }

        public static IQueryable<NewsItemSummary> WithOwnerID(this IQueryable<NewsItemSummary> qry, Guid ownerId)
        {
            return from newsItemSummary in qry
                   where newsItemSummary.OwnerID == ownerId
                   select newsItemSummary;
        }

    }

}
