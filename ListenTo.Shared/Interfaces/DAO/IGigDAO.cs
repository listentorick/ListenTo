using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.DAO
{
    public interface IGigDAO : IGenericDAO<Gig, Guid?>
    {

        IList<Gig> GetAllGigsByArtist(Guid artistId);
        IList<Gig> GetAllGigsByArtistOnDate(Guid artistId, DateTime date);
        IList<Gig> GetAllGigsByArtistAfterDate(Guid artistId, DateTime date);
        IList<Gig> GetAllGigsByArtistBeforeDate(Guid artistId, DateTime date);

        IList<Gig> GetAllGigsByArtistAtVenueOnDate(Guid artistId, Guid venueId, DateTime date);
        IList<Gig> GetAllGigsByArtistAtVenueAfterDate(Guid artistId, Guid venueId, DateTime date);
        IList<Gig> GetAllGigsByArtistAtVenueBeforeDate(Guid artistId, Guid venueId, DateTime date);

        IList<Gig> GetAllGigsAtVenue(Guid venueId);
        IList<Gig> GetAllGigsAtVenueOnDate(Guid venueId, DateTime date);
        IList<Gig> GetAllGigsAtVenueAfterDate(Guid venueId, DateTime date);
        IList<Gig> GetAllGigsAtVenueBeforeDate(Guid venueId, DateTime date);

        IList<Gig> GetGigsBySite(Guid siteId);
        IList<Gig> GetGigsBySiteOnDate(Guid siteId, DateTime date);
        IList<Gig> GetGigsBySiteAfterDate(Guid siteId, DateTime date);
        IList<Gig> GetGigsBySiteBeforeDate(Guid siteId, DateTime date);

    }
}
