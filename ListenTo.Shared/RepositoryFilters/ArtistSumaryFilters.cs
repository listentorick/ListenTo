
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class ArtistSummaryFilters
    {

        public static IQueryable<ListenTo.Shared.DTO.ArtistSummary> WithStyleId(this IQueryable<ListenTo.Shared.DTO.ArtistSummary> qry, Guid styleId)
        {
            return from artist in qry
                   where artist.StyleID == styleId
                   select artist;
        }

        public static IQueryable<ListenTo.Shared.DTO.ArtistSummary> WithSiteId(this IQueryable<ListenTo.Shared.DTO.ArtistSummary> qry, Guid siteId)
        {
            return from artist in qry
                   where artist.SiteId == siteId
                   select artist;
        }

        public static IQueryable<ListenTo.Shared.DTO.ArtistSummary> WithOwnerId(this IQueryable<ListenTo.Shared.DTO.ArtistSummary> qry, Guid ownerId)
        {
            return from artist in qry
                   where artist.OwnerID == ownerId
                   select artist;
        }
        public static IQueryable<ListenTo.Shared.DTO.ArtistSummary> WithID(this IQueryable<ListenTo.Shared.DTO.ArtistSummary> qry, IQueryable<Guid> Ids)
        {
            return from artist in qry
                   where Ids.Contains(artist.ID)
                   select artist;
        }

    }
}
