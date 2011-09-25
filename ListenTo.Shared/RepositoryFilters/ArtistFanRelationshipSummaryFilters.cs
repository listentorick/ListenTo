
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class ArtistFanRelationshipSummaryFilters
    {

        public static IQueryable<ListenTo.Shared.DTO.ArtistFanRelationshipSummary> WithUserId(this IQueryable<ListenTo.Shared.DTO.ArtistFanRelationshipSummary> qry, Guid userId)
        {
            return from artistFanRelationshipSummary in qry
                   where artistFanRelationshipSummary.UserId == userId
                   select artistFanRelationshipSummary;
        }

        public static IQueryable<ListenTo.Shared.DTO.ArtistFanRelationshipSummary> WithArtistId(this IQueryable<ListenTo.Shared.DTO.ArtistFanRelationshipSummary> qry, Guid artistId)
        {
            return from artistFanRelationshipSummary in qry
                   where artistFanRelationshipSummary.ArtistId == artistId
                   select artistFanRelationshipSummary;
        }


        


    }
}
