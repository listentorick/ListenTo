using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Shared.Interfaces.DAO;
using ListenTo.Shared.Interfaces.Repository;
using ListenTo.Shared.RepositoryFilters;
using System.Linq;
using ListenTo.Shared.Utility;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Enums;

namespace ListenTo.Core.Managers
{

    public class GigManager: BaseManager, IGigManager
    {

        public IActionsManager ActionsManager { get; set; }
        public IVenueManager VenueManager { get; set; }

        #region IManager Members

        public Gig GetByID(Guid id)
        {
            Gig gig = this.Repository.GetGigs().WithID(id).SingleOrDefault();
            return gig;
        }

        public Gig Save(IDO dO, UserCredentials userCredentials)
        {
            Gig gig = (Gig)dO;

            this.CheckOwnership(gig, userCredentials);

            //This will throw an exception if the data model is invalid. 
            bool isValid = ValidationRunner.Validate(gig, userCredentials);

            //Its possible that the venue *may* be new, so we need to persist the new venue
            //first.
            bool isVenueNew = this.CheckIsNew(gig.Venue, userCredentials);
            
            if (isVenueNew)
            {
                //Persist the venue...
                this.VenueManager.Save(gig.Venue, userCredentials);   
            }

            bool isNew = this.CheckIsNew(gig, userCredentials);

            gig = this.Repository.SaveGig(gig);

            if (isNew)
            {
                ListenTo.Shared.DO.Action action = new ListenTo.Shared.DO.Action();
                action.ActionType = ActionType.ADDED_A_GIG;
                action.ContentType = ContentType.GIG;
                action.ContentID = gig.ID;

                foreach (Site site in gig.Venue.Town.Sites)
                {
                    action.TargetSites.Add(site.ID);
                }

                action.OwnerID = gig.OwnerID;

                foreach (Act act in gig.Acts)
                {
                    if (act.Artist != null)
                    {
                        action.AssociatedArtistIds.Add(act.Artist.ID);
                    }
                }

                ActionsManager.AddAction(action, userCredentials);
            }

            return gig;

        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }


        #endregion

        #region IGigManager Members

        public IPageOfList<Gig> GetGigsBySiteAfterDate(int pageSize, int currentPageIndex, Guid siteID, DateTime startDate)
        {
            return this.Repository.GetGigs().AfterDate(startDate).EarliestFirst().ToPageOfList(currentPageIndex, pageSize);
        }

        public IPageOfList<Gig> GetUpcomingGigsAtVenue(int pageSize, int currentPageIndex, Guid venueId)
        {
            return this.Repository.GetGigs().AtVenue(venueId).AfterDate(DateTime.Now).ToPageOfList(currentPageIndex, pageSize); ;
        }

        public IPageOfList<Gig> GetUpcomingGigsWithArtist(int pageSize, int currentPageIndex, Guid artistId)
        {
            return this.Repository.GetGigsByArtist(artistId).AfterDate(DateTime.Now).ToPageOfList(currentPageIndex, pageSize); 
        }

        public IPageOfList<Gig> GetPreviousGigsWithArtist(int pageSize, int currentPageIndex, Guid artistId)
        {
            return this.Repository.GetGigsByArtist(artistId).BeforeDate(DateTime.Now).ToPageOfList(currentPageIndex, pageSize); 
        }

        public IPageOfList<Gig> GetMostRecentGigsAtVenue(int pageSize, int currentPageIndex, Guid venueId)
        {
            return this.Repository.GetGigs().AtVenue(venueId).BeforeDate(DateTime.Now).OrderByDescending(s => s.StartDate).ToPageOfList(currentPageIndex, pageSize); 
        }

        public IList<Gig> GetNRandomGigsBySiteAfterDate(int nGigs, Guid siteId, DateTime startDate)
        {
            return this.Repository.GetNRandomGigsBySiteAfterDate(nGigs, siteId, startDate).ToList();
        }

        #endregion


        #region IGigManager Members


        public void DeleteGigsAtVenue(Guid venueId, UserCredentials userCredentials)
        {
            IList<Gig> gigsAtVenue = this.Repository.GetGigsAtVenue(venueId);
            foreach (Gig gig in gigsAtVenue)
            {
                gig.IsDeleted = true;
                this.Save(gig, userCredentials);
            }
        }

        #endregion
    }
}
