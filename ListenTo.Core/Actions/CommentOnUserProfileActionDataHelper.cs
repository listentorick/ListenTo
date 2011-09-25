using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.ActionData;
using ListenTo.Shared.DO;

namespace ListenTo.Core.Actions
{
    public class CommentOnUserProfileActionDataHelper : IActionDataHelper
    {
        public ICommentManager CommentManager { get; set; }
        public IUserProfileManager UserProfileManager { get; set; }
 
        #region IActionDataHelper Members

        public object GetActionData(ListenTo.Shared.DO.Action action)
        {
            CommentOnUserProfileActionData commentOnUserProfileActionData = new CommentOnUserProfileActionData();
            Comment comment = CommentManager.GetByID(action.ContentID);

            if (comment != null)
            {
                UserProfile userProfile = UserProfileManager.GetByID(comment.TargetId);

                if (userProfile != null)
                {
                    commentOnUserProfileActionData.UserProfile = userProfile;
                }
                else
                {
                    throw new Exception("UserProfile does not exist or is deleted");
                }
            }
            else
            {
                throw new Exception("Comment doesnt exist!");
            }

            return commentOnUserProfileActionData;
        }

        #endregion
    }
}
