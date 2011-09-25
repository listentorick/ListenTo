using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class NewsItemFilters
    {

        public static IQueryable<NewsItem> WithID(this IQueryable<NewsItem> qry, Guid Id)
        {
            return from newsItem in qry
                   where newsItem.ID == Id
                   select newsItem;
        }

        public static IQueryable<NewsItem> IsPublished(this IQueryable<NewsItem> qry)
        {
            return from newsItem in qry
                   where newsItem.IsPublished == true
                   select newsItem;
        }


    }
}
