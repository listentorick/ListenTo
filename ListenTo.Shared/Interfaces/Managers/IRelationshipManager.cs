using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.DTO;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface IRelationshipManager
    {
        Relationship AddArtistFan(UserCredentials userCredentials, Guid artistId, Guid userId);
        Relationship AddRelationship(UserCredentials userCredentials, Relationship relationship);
        ListenTo.Shared.Utility.IPageOfList<ArtistFanRelationshipSummary> GetArtistFanRelationshipSummaryForArtist(UserCredentials user, int pageSize, int currentPageIndex, Guid artistId);
        ListenTo.Shared.Utility.IPageOfList<ArtistFanRelationshipSummary> GetArtistFanRelationshipSummaryForUser(UserCredentials user, int pageSize, int currentPageIndex, Guid userId);
        bool IsUserFanOfArtist(UserCredentials userCredentials, Guid artistId, Guid userId);
    }
}
