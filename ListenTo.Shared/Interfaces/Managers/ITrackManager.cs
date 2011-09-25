using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface ITrackManager: IManager<Track>
    {
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummaries(int pageSize, int currentPageIndex, Guid siteId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesForArtist(int pageSize, int currentPageIndex, Guid artistId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesForSite(int pageSize, int currentPageIndex, Guid siteId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesBySiteAndStyle(int pageSize, int currentPageIndex, Guid siteId, Guid styleId);
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesBySiteAndStylesAndArtists(int pageSize, int currentPageIndex, Guid siteId, IList<Guid> styleIds, IList<Guid> artistIds);
        IList<ListenTo.Shared.DTO.TrackSummary> GetNRandomlyOrderedTrackSummariesBySiteAndStylesAndArtists(int num, Guid siteId, IList<Guid> styleIds, IList<Guid> artistIds);
        ListenTo.Shared.DO.TrackMetaData GetTrackMetaData(Guid id);
    }
}
