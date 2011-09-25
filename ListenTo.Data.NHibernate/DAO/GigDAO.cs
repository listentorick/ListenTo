using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DAO;
using ListenTo.Shared.DO;
using NHibernate.Expression;
using NHibernate;

namespace ListenTo.Data.NHibernate.DAO
{

    public class GigDAO : HibernateDAO<Gig, Guid?>, ListenTo.Shared.Interfaces.DAO.IGigDAO
    {

        #region IGigDAO Members

        public IList<Gig> GetAllGigsByArtist(Guid artistId)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetAllGigsByArtistOnDate(Guid artistId, DateTime date)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetAllGigsByArtistAfterDate(Guid artistId, DateTime date)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetAllGigsByArtistBeforeDate(Guid artistId, DateTime date)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetAllGigsByArtistAtVenueOnDate(Guid artistId, Guid venueId, DateTime date)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetAllGigsByArtistAtVenueAfterDate(Guid artistId, Guid venueId, DateTime date)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetAllGigsByArtistAtVenueBeforeDate(Guid artistId, Guid venueId, DateTime date)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetAllGigsAtVenue(Guid venueId)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetAllGigsAtVenueOnDate(Guid venueId, DateTime date)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetAllGigsAtVenueAfterDate(Guid venueId, DateTime date)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetAllGigsAtVenueBeforeDate(Guid venueId, DateTime date)
        {
            throw new NotImplementedException();
        }

        public IList<Gig> GetGigsBySite(Guid siteId)
        {
            return this.GetAllByNamedQueryAndNamedParam("Gig.GetGigsBySite", "siteID", siteId);
        }

        public IList<Gig> GetGigsBySiteOnDate(Guid siteId, DateTime date)
        {
            string[] paramNames = new string[] { "siteId", "onDate" };
            object[] paramValues = new object[] { siteId, date };
            return this.GetAllByNamedQueryAndNamedParam("Gig.GetGigsBySiteOnDate", paramNames, paramValues);
        }

        public IList<Gig> GetGigsBySiteAfterDate(Guid siteId, DateTime date)
        {
            string[] paramNames = new string[]{"siteId", "afterDate"};
            object[] paramValues = new object[]{siteId, date};
            return this.GetAllByNamedQueryAndNamedParam("Gig.GetGigsBySiteAfterDate", paramNames, paramValues);
        }

        public IList<Gig> GetGigsBySiteBeforeDate(Guid siteId, DateTime date)
        {
            string[] paramNames = new string[] { "siteId", "beforeDate" };
            object[] paramValues = new object[] { siteId, date };
            return this.GetAllByNamedQueryAndNamedParam("Gig.GetGigsBySiteBeforeDate", paramNames, paramValues);
        }

        #endregion
    }
}