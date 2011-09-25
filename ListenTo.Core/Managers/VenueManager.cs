using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.Interfaces.Repository;
using ListenTo.Shared.Utility;
using ListenTo.Shared.RepositoryFilters;
using System.Linq;

namespace ListenTo.Core.Managers
{
    public class VenueManager: BaseManager, IVenueManager
    {
        public IGigManager GigManager { get; set; }

        #region IManager Members

        public Venue GetByID(Guid id)
        {
            Venue venue = this.Repository.GetVenues().WithID(id).SingleOrDefault();
            return venue;
        }

        public Venue Save(IDO dO, UserCredentials userCredentials)
        {
            Venue venue = (Venue)dO;

            this.CheckOwnership(venue, userCredentials);

            //This will throw an exception if the data model is invalid. 
            bool isValid = ValidationRunner.Validate(venue, userCredentials);

            //Its possible that the venue *may* be new, so we need to persist the new venue
            //first.
            bool isVenueNew = this.CheckIsNew(venue, userCredentials);

            if (isVenueNew)
            {
                //Persist the venue...
                this.Repository.SaveVenue(venue);
            }

            return venue;
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {

            Venue venue = this.GetByID(id);
            if (venue != null)
            {
                this.CheckOwnership(venue, userCredentials);

                venue.IsDeleted = true;
                this.Save(venue, userCredentials);

                GigManager.DeleteGigsAtVenue(venue.ID, userCredentials);

            }
            else
            {
                throw new Exception("The venue you are trying to delete does not exist");
            }
            
        }

        #endregion

        #region IVenueManager Members

        public IPageOfList<Venue> GetVenuesWithNameLike(int pageSize, int currentPageIndex, string name)
        {
            return this.Repository.GetVenues().NameLike(name).ToPageOfList(currentPageIndex, pageSize);
        }

        public IList<Venue> GetVenues()
        {
            return this.Repository.GetVenues().ToList();
        }

        #endregion

    }
}
