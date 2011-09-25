using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Utility;

namespace ListenTo.Shared.Interfaces.Managers
{
    /// <summary>
    /// Defines the Interface for the GigManager
    /// </summary>
    public interface IGigManager : IManager<Gig>
    {
        /// <summary>
        /// Returns gigs which havent been deleted by site after a particular date 
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="siteID"></param>
        /// <param name="startDate"></param>
        /// <returns></returns>
        IPageOfList<Gig> GetGigsBySiteAfterDate(int pageSize, int currentPageIndex, Guid siteID, DateTime startDate);


        /// <summary>
        /// Upcoming Gigs (which havent been deleted) from a particular venue
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="venueId"></param>
        /// <returns></returns>
        IPageOfList<Gig> GetUpcomingGigsAtVenue(int pageSize, int currentPageIndex, Guid venueId);

        /// <summary>
        /// Recent Gigs (which havent been deleted) from a particular venue
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="venueId"></param>
        /// <returns></returns>
        IPageOfList<Gig> GetMostRecentGigsAtVenue(int pageSize, int currentPageIndex, Guid venueId);

        /// <summary>
        /// Upcoming gigs(which havent been deleted) from a particular artist
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="artistId"></param>
        /// <returns></returns>
        IPageOfList<Gig> GetUpcomingGigsWithArtist(int pageSize, int currentPageIndex, Guid artistId);

        /// <summary>
        /// Previous gigs(which havent been deleted) from a particular artist
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="artistId"></param>
        /// <returns></returns>
        IPageOfList<Gig> GetPreviousGigsWithArtist(int pageSize, int currentPageIndex, Guid artistId);

        /// <summary>
        /// Random gigs(which havent been deleted) after a particular date
        /// </summary>
        /// <param name="nGigs"></param>
        /// <param name="siteId"></param>
        /// <param name="startDate"></param>
        /// <returns></returns>
        IList<Gig> GetNRandomGigsBySiteAfterDate(int nGigs, Guid siteId, DateTime startDate);

        /// <summary>
        /// Logically deletes any gigs at the venue
        /// </summary>
        /// <param name="venueId"></param>
        /// <param name="userCredentials"></param>
        void DeleteGigsAtVenue(Guid venueId, UserCredentials userCredentials);
    }
}
