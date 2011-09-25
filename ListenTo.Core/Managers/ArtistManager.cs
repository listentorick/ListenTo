using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.Utility;
using ListenTo.Shared.Interfaces.Repository;
using ListenTo.Shared.RepositoryFilters;
using System.Linq;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Enums;

namespace ListenTo.Core.Managers
{
    public class ArtistManager: BaseManager, IArtistManager
    {

        public IUserManager UserManager { get; set; }
        public IActionsManager ActionsManager { get; set; }

        #region IManager Members

        public IDO GetByID(Guid id)
        {
            throw new NotImplementedException();
        }

        public IDO Save(IDO dO)
        {
            throw new NotImplementedException();
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region IArtistManager Members


        public IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesBySite(int pageSize, int currentPageIndex, Guid siteId)
        {
            return this.Repository.GetArtistSummariesBySite(pageSize, currentPageIndex, siteId);
        }

        public IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesBySiteAndStyle(int pageSize, int currentPageIndex, Guid siteId, Guid styleId)
        {
            return this.Repository.GetArtistSummariesBySiteAndStyle(pageSize, currentPageIndex, siteId, styleId);
        }

        public IPageOfList<ListenTo.Shared.DTO.ArtistSummary> GetArtistSummariesByOwner(int pageSize, int currentPageIndex, Guid ownerId)
        {
            return this.Repository.GetArtistSummariesByOwner(pageSize, currentPageIndex, ownerId);
        }

        public IPageOfList<Artist> GetArtistsWithNameLike(int pageSize, int currentPageIndex, string name)
        {
            return this.Repository.GetArtists().WithNameLike(name).ToPageOfList(currentPageIndex, pageSize);
        }

        public IPageOfList<Artist> GetArtistsByOwner(int pageSize, int currentPageIndex, Guid ownerId)
        {
            return this.Repository.GetArtistsByOwner(ownerId).ToPageOfList(currentPageIndex, pageSize);
        }

        public Artist GetByProfileAddress(string profileAddress)
        {
            Artist artist = this.Repository.GetArtists().WithProfileAddress(profileAddress).SingleOrDefault();
            return artist;
        }

        public IPageOfList<Artist> GetArtists(int pageSize, int currentPageIndex)
        {
            return this.Repository.GetArtists().ToPageOfList(currentPageIndex, pageSize);
        }

        public IPageOfList<Artist> GetArtistsByStyle(int pageSize, int currentPageIndex, Guid styleId)
        {
            return this.Repository.GetArtistsByStyle(pageSize, currentPageIndex, styleId);
        }


        public IList<ArtistSummary> GetNRandomArtistSummaries(int numArtists)
        {
            return this.Repository.GetNRandomArtistSummaries(numArtists);
        }

        public IList<ArtistSummary> GetNRandomArtistSummariesBySite(Guid siteId, int numArtists)
        {
            return this.Repository.GetNRandomArtistSummariesBySite(siteId, numArtists);
        }

        public IList<Artist> GetNRandomArtists(int numArtists)
        {
            return this.Repository.GetNRandomArtists(numArtists).ToList();
        }

        public IList<Artist> GetNRandomArtistsBySite(Guid siteId, int numArtists)
        {
            return this.Repository.GetNRandomArtistsBySite(siteId, numArtists).ToList();
        }

        public int GetNumberOfArtistsBySite(Guid siteId)
        {
            return this.Repository.GetNumberOfArtistsBySite(siteId);
        }

        public int GetNumberOfArtistsOwnedBy(UserCredentials userCredentials, Guid ownerId)
        {
            return this.Repository.GetNumberOfArtistsOwnedBy(ownerId);
        }

        #endregion

        #region IManager<Artist> Members

        Artist IManager<Artist>.GetByID(Guid id)
        {
            return this.Repository.GetArtists().WithID(id).SingleOrDefault();
        }


        Artist IManager<Artist>.Save(IDO dO, UserCredentials userCredentials)
        {

            Artist artist = (Artist)dO;
            this.CheckOwnership(artist, userCredentials);

            //This will throw an exception if the data model is invalid. 
            bool isValid = ValidationRunner.Validate(artist, userCredentials);

            bool isNew = this.CheckIsNew(artist, userCredentials);

            artist = this.Repository.SaveArtist(artist);


            if (isNew)
            {
                ListenTo.Shared.DO.Action action = new ListenTo.Shared.DO.Action();
                action.ActionType = ActionType.ADDED_AN_ARTIST;
                action.ContentType = ContentType.ARTIST;
                action.ContentID = artist.ID;

                foreach (Site site in artist.Town.Sites)
                {
                    action.TargetSites.Add(site.ID);
                }

                action.OwnerID = artist.OwnerID;
                action.AssociatedArtistIds.Add(artist.ID);
                ActionsManager.AddAction(action, userCredentials);
            }

            return artist;

        }

        #endregion

    }
}
