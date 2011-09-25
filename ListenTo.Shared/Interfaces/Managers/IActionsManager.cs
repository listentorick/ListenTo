using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface IActionsManager : IManager<ListenTo.Shared.DO.Action>
    {

        /// <summary>
        /// Add an action...
        /// </summary>
        /// <param name="action"></param>
        void AddAction(ListenTo.Shared.DO.Action action, ListenTo.Shared.DO.UserCredentials userCredentials);

        /// <summary>
        /// Returns a page of the users most recent actions
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DO.Action> GetUsersLatestActions(int pageSize, int currentPageIndex, Guid userId);


        /// <summary>
        /// Returns a page of  most recent actions for a particular site
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DO.Action> GetLatestActionsForSite(int pageSize, int currentPageIndex, Guid siteId);

        /// <summary>
        /// Gets the most recent actions related to an artist
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPageIndex"></param>
        /// <param name="artistId"></param>
        /// <returns></returns>
        ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DO.Action> GetLatestActionsAssociatedWithArtist(int pageSize, int currentPageIndex, Guid artistId);

    }


}
