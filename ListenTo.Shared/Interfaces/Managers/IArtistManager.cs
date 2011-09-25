using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Utility;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface IArtistManager: IManager<Artist> 
    {
        IPageOfList<Artist> GetArtistsWithNameLike(int pageSize, int currentPageIndex, string name);
        IPageOfList<Artist> GetArtists(int pageSize, int currentPageIndex);
        Artist GetByProfileAddress(string profileAddress);
        IList<Artist> GetNRandomArtists(int numArtists);
        IList<Artist> GetNRandomArtistsBySite(Guid siteId, int numArtists);
        IList<ArtistSummary> GetNRandomArtistSummaries(int numArtists);
        IList<ArtistSummary> GetNRandomArtistSummariesBySite(Guid siteId, int numArtists);
        int GetNumberOfArtistsBySite(Guid siteId);
        IPageOfList<Artist> GetArtistsByOwner(int pageSize, int currentPageIndex, Guid ownerId);
        IPageOfList<Artist> GetArtistsByStyle(int pageSize, int currentPageIndex, Guid styleId);
        int GetNumberOfArtistsOwnedBy(UserCredentials userCredentials, Guid ownerId);
        IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesBySite(int pageSize, int currentPageIndex, Guid siteId);
        IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesBySiteAndStyle(int pageSize, int currentPageIndex, Guid siteId, Guid styleId);
        IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesByOwner(int pageSize, int currentPageIndex, Guid ownerId);
      

    }
}
