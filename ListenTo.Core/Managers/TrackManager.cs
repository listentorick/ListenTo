using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.RepositoryFilters;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Utility;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Helpers;

namespace ListenTo.Core.Managers
{
    public class TrackManager: BaseManager, ITrackManager
    {

        public IFileHelpers FileHelpers { get; set; }

        #region ITrackManager Members

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummaries(int pageSize, int currentPageIndex, Guid siteId)
        {
            return this.Repository.GetTrackSummariesBySite(siteId).ToPageOfList(currentPageIndex, pageSize);
        }

        public IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesForArtist(int pageSize, int currentPageIndex, Guid artistId)
        {
            return this.Repository.GetTrackSummariesByArtist(artistId).ToPageOfList(currentPageIndex, pageSize);
        }

        public IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesForSite(int pageSize, int currentPageIndex, Guid siteId)
        {
            return this.Repository.GetTrackSummariesBySite(siteId).ToPageOfList(currentPageIndex, pageSize);
        }

        public IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesBySiteAndStyle(int pageSize, int currentPageIndex, Guid siteId, Guid styleId)
        {
            return this.Repository.GetTrackSummariesBySiteAndStyle(pageSize, currentPageIndex, siteId, styleId);
        }

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.TrackSummary> GetTrackSummariesBySiteAndStylesAndArtists(int pageSize, int currentPageIndex, Guid siteId, IList<Guid> styleIds, IList<Guid> artistIds)
        {
            return this.Repository.GetTrackSummariesBySiteAndStylesAndArtists(pageSize, currentPageIndex, siteId, styleIds, artistIds);
        }

        public IList<ListenTo.Shared.DTO.TrackSummary> GetNRandomlyOrderedTrackSummariesBySiteAndStylesAndArtists(int num, Guid siteId, IList<Guid> styleIds, IList<Guid> artistIds)
        {
            return this.Repository.GetNRandomlyOrderedTrackSummariesBySiteAndStylesAndArtists(num, siteId, styleIds, artistIds);
        }

        #endregion

        #region IManager<Track> Members

        public ListenTo.Shared.DO.Track GetByID(Guid id)
        {
            ListenTo.Shared.DO.TrackMetaData trackMetaData = this.GetTrackMetaData(id);
            ListenTo.Shared.DO.Track track = null;

            if (trackMetaData != null)
            {
                track = Adapt(trackMetaData);
                track = (ListenTo.Shared.DO.Track)FileHelpers.PopulateFromFile(TrackHelpers.ConstructTrackPath(track), track);
            }

            return track;
        }

        public ListenTo.Shared.DO.Track Save(ListenTo.Shared.Interfaces.DO.IDO dO, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ListenTo.Shared.DO.Track track = (ListenTo.Shared.DO.Track)dO;

            this.CheckOwnership(track, userCredentials);

            //This will throw an exception if the data model is invalid. 
            bool isValid = ValidationRunner.Validate(track, userCredentials);

            string trackPath = TrackHelpers.ConstructTrackPath(track);

            //If a file already exists, delete it...
            if (System.IO.File.Exists(trackPath))
            {
                System.IO.File.Delete(trackPath);
            }

            System.IO.File.WriteAllBytes(trackPath, track.Data);
            this.Repository.SaveTrackMetaData((TrackMetaData)track);
            return track;
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }


        #endregion

        public ListenTo.Shared.DO.TrackMetaData GetTrackMetaData(Guid id)
        {
            return this.Repository.GetTrackMetaDatas().WithID(id).SingleOrDefault();
        }


        public ListenTo.Shared.DO.Track Adapt(TrackMetaData trackMetaData)
        {
            Track track = new Track();
            track.ID = trackMetaData.ID;
            track.Artist = trackMetaData.Artist;
            track.Created = trackMetaData.Created;
            track.Description = trackMetaData.Description;
            track.Engineer = trackMetaData.Engineer;
            track.Name = trackMetaData.Name;
            track.OwnerID = trackMetaData.OwnerID;
            track.Studio = trackMetaData.Studio;
            track.Style = trackMetaData.Style;
            track.Producer = trackMetaData.Producer;
            return track;
        }



    }
}
