using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Shared.Enums;

namespace ListenTo.Core.Actions
{
    public class CommentOnNewsItemActionBuilder : IActionForCommentBuilder
    {
        public INewsItemManager NewsItemManager { get; set; }

        #region IActionForCommentBuilder Members


        /// <summary>
        /// Constructs an action for a comment associated with a news item
        /// </summary>
        /// <param name="comment"></param>
        /// <returns></returns>
        public ListenTo.Shared.DO.Action BuildAction(ListenTo.Shared.DO.Comment comment)
        {
            //Load the content so we can determine the site its associated with
            NewsItem newsItem = NewsItemManager.GetByID(comment.TargetId);

            if (newsItem == null)
            {
                throw new Exception("Cannot create Action for NewsItem Comment. NewsItem does not exist");
            }

            ListenTo.Shared.DO.Action action = new ListenTo.Shared.DO.Action();
            action.ContentID = comment.ID;
            action.ContentType = ContentType.COMMENT;
            action.ActionType = ActionType.COMMENTED_ON_A_NEWSITEM;
            action.Created = DateTime.Now;
            action.TargetSites = new List<Guid>();
            action.OwnerID = comment.OwnerID;
            foreach(Site site in newsItem.TargetSites){
                action.TargetSites.Add(site.ID);
            }

            return action;
        }

        #endregion
    }
}
