using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Utility;
using ListenTo.Shared.Interfaces.Do;
using ListenTo.Shared.Interfaces.Actions;
using System.Threading;

namespace ListenTo.Core.Managers
{
  
    public class ActionsManager : BaseManager, IActionsManager
    {

        public IActionDataHelperFactory ActionDataHelperFactory { get; set; }
        public IActionPublicationQueue ActionPublicationQueue { get; set; }
        
        #region IActionsManager Members

        public void AddAction(ListenTo.Shared.DO.Action action, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            this.Save(action, userCredentials);
            this.ActionPublicationQueue.PublishAction(action);
        }

        public IPageOfList<ListenTo.Shared.DO.Action> DecorateWithActionData(IPageOfList<ListenTo.Shared.DO.Action> actions)
        {
            IActionDataHelper actionDataHelper;

            foreach (ListenTo.Shared.DO.Action action in actions)
            {
                actionDataHelper = ActionDataHelperFactory.CreateHelper(action);

                if (actionDataHelper!=null)
                {
                    action.ActionData =  actionDataHelper.GetActionData(action);
                }
            }

            return actions;

        }


        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DO.Action> GetUsersLatestActions(int pageSize, int currentPageIndex, Guid userId)
        {
            IPageOfList <ListenTo.Shared.DO.Action> actions = this.Repository.GetUsersLatestActions(pageSize, currentPageIndex, userId);

            return DecorateWithActionData(actions);

        }

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DO.Action> GetLatestActionsForSite(int pageSize, int currentPageIndex, Guid siteId)
        {
            //GetLatestActionsForSite will not return actions such as comments...
            IPageOfList<ListenTo.Shared.DO.Action> actions = this.Repository.GetLatestActionsForSite(pageSize, currentPageIndex, siteId);

            return DecorateWithActionData(actions);

        }

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DO.Action> GetLatestActionsAssociatedWithArtist(int pageSize, int currentPageIndex, Guid artistId)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region IManager<Action> Members

        public ListenTo.Shared.DO.Action GetByID(Guid id)
        {
            throw new NotImplementedException();
        }

        public ListenTo.Shared.DO.Action Save(ListenTo.Shared.Interfaces.DO.IDO dO, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ListenTo.Shared.DO.Action action = (ListenTo.Shared.DO.Action)dO;
            action = this.Repository.SaveAction(action);
            return action;
        }

        public void Delete(Guid id, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        #endregion

    }
}
