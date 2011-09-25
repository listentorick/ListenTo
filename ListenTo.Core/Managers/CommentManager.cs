using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.RepositoryFilters;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Utility;
using ListenTo.Shared.Enums;
using ListenTo.Shared.Interfaces.Actions;

namespace ListenTo.Core.Managers
{
    public class CommentManager: BaseManager, ICommentManager
    {
        public IActionForCommentBuilderFactory ActionForCommentBuilderFactory { get; set; }
        public IActionsManager ActionsManager { get; set; }

        #region ICommentManager Members
        
        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.DTO.CommentSummary> GetCommentSummaries(int pageSize, int currentPageIndex, Guid targetId)
        {
            return this.Repository.GetCommentSummaries().WithTargetID(targetId).ToPageOfList(currentPageIndex, pageSize);
        }

        #endregion

        #region IManager<Comment> Members

        public ListenTo.Shared.DO.Comment GetByID(Guid id)
        {
            return this.Repository.GetComments().WithID(id).SingleOrDefault();
        }

        public ListenTo.Shared.DO.Comment Save(ListenTo.Shared.Interfaces.DO.IDO dO, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ListenTo.Shared.DO.Comment comment = (ListenTo.Shared.DO.Comment)dO;

            this.CheckOwnership(comment, userCredentials);

            //Construct an action
            //The actual action type is dependent upon the content type of the comment
            //should check is new here
            comment = this.Repository.SaveComment(comment);

            //Using the factory try to grab an IActionForCommentBuilder instance
            //We will use this to build the action.
            IActionForCommentBuilder actionForCommentBuilder = ActionForCommentBuilderFactory.GetBuilder(comment);
            
            ListenTo.Shared.DO.Action action = null;
            
            if (actionForCommentBuilder != null)
            {
                //we can build an action!
                action = actionForCommentBuilder.BuildAction(comment);
            }

            if (action != null)
            {
                //We have an action, so save it
                ActionsManager.AddAction(action, userCredentials);
            }

            return comment;
        }

        public void Delete(Guid id, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }


        #endregion

    }
}
