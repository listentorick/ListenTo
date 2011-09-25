using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;

namespace ListenTo.Core.Actions
{
    public class UsersToInformAboutCommentOnUserProfileActionResolver : IUsersToInformAboutActionResolver
    {
        public IUserProfileManager UserProfileManager { get; set; }
        public ICommentManager CommentManager { get; set; }

        #region IUsersToInformAboutActionResolver Members

        public IList<ListenTo.Shared.DO.UserProfile> ResolveUsersToInformAboutAction(ListenTo.Shared.DO.Action action)
        {
            IList<UserProfile> userProfiles = new List<UserProfile>();
            Comment comment = CommentManager.GetByID(action.ContentID);

            if (comment != null)
            {
                UserProfile userProfile = UserProfileManager.GetByID(comment.TargetId);

                if (userProfile != null)
                {
                    userProfiles.Add(userProfile);
                }
                else
                {
                    throw new Exception("UserProfile  does not exist");
                }
            }
            else
            {
                throw new Exception("Comment does not exist");
            }

            return userProfiles;
        }

        #endregion
    }
}
