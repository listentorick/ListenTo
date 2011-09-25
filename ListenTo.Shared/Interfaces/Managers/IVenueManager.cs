using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Utility;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface IVenueManager : IManager <Venue>
    {
        /// <summary>
        /// Does not return deleted venues or venues associated with deleted towns
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        IPageOfList<Venue> GetVenuesWithNameLike(int pageSize, int currentPageIndex, string name);
        
        /// <summary>
        /// Can return deleted venues
        /// </summary>
        /// <returns></returns>
        IList<Venue> GetVenues();

    }
}
