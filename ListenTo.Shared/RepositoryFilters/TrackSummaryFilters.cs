using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DTO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class TrackSummaryFilters
    {

        public static IQueryable<TrackSummary> WithSiteID(this IQueryable<TrackSummary> qry, Guid siteId)
        {
            return from trackSummary in qry
                   where trackSummary.SiteId == siteId
                   select trackSummary;
        }

        public static IQueryable<TrackSummary> WithStyleID(this IQueryable<TrackSummary> qry, Guid styleId)
        {
            return from trackSummary in qry
                   where trackSummary.StyleId == styleId
                   select trackSummary;
        }
        

        public static IQueryable<TrackSummary> WithArtistID(this IQueryable<TrackSummary> qry, Guid artistId)
        {
            return from trackSummary in qry
                   where trackSummary.ArtistId == artistId
                   select trackSummary;
        }

        public static IQueryable<TrackSummary> WithStyleID(this IQueryable<TrackSummary> qry, IList<Guid> styleIds)
        {
            //We convert to a list since we need IEnumerble for this to work..
            List<Guid> styleIdList = styleIds.ToList();
            return (from trackSummary in qry
                   where styleIdList.Contains(trackSummary.StyleId)
                   select trackSummary);
        }

        public static IQueryable<TrackSummary> WithArtistID(this IQueryable<TrackSummary> qry, IList<Guid> artistIds)
        {
            //We convert to a list since we need IEnumerble for this to work..
            List<Guid> artistIdList = artistIds.ToList();
            return from trackSummary in qry
                   where artistIdList.Contains(trackSummary.ArtistId)
                   select trackSummary;
        }

        public static IQueryable<TrackSummary> WithID(this IQueryable<TrackSummary> qry, IList<Guid> Ids)
        {
            //This statement forces the IQueryable to be resolved (i.e. the query is executed)
            List<Guid> idsList = Ids.ToList();
            return from trackSummary in qry
                   where idsList.Contains(trackSummary.ID)
                   select trackSummary;
        }
    }
}
