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
    /// <summary>
    /// Builds an action for a comment on a user profile
    /// </summary>
    public class CommentOnUserProfileActionBuilder : IActionForCommentBuilder
    {
        public IUserProfileManager UserProfileManager { get; set; }

        #region IActionForCommentBuilder Members

        public ListenTo.Shared.DO.Action BuildAction(ListenTo.Shared.DO.Comment comment)
        {
            //Load the content so we can determine the site its associated with
            UserProfile userProfile = UserProfileManager.GetByID(comment.TargetId);

            if (userProfile == null)
            {
                throw new Exception("Cannot create Action for UserProfile Comment. UserProfile does not exist");
            }

            ListenTo.Shared.DO.Action action = new ListenTo.Shared.DO.Action();
            action.ContentID = comment.ID;
            action.ContentType = ContentType.COMMENT;
            action.ActionType = ActionType.COMMENTED_ON_A_USERPROFILE;
            action.Created = DateTime.Now;
            action.TargetSites = new List<Guid>();
            action.OwnerID = comment.OwnerID;

            foreach(Site site in userProfile.Town.Sites){
                action.TargetSites.Add(site.ID);
            }

            return action;
        }

        #endregion
    }
}
