using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;

namespace ListenTo.Core.Actions
{

    /// <summary>
    /// Determines the users to inform about a comment applied to a newsitem
    /// </summary>
    public class UsersToInformAboutCommentOnNewsItemActionResolver : IUsersToInformAboutActionResolver
    {

        public IUserProfileManager UserProfileManager { get; set; }
        public ICommentManager CommentManager { get; set; }
        public INewsItemManager NewsItemManager { get; set; }

        #region IUsersToInformAboutActionResolver Members

        public IList<ListenTo.Shared.DO.UserProfile> ResolveUsersToInformAboutAction(ListenTo.Shared.DO.Action action)
        {
            IList<UserProfile> userProfiles = new List<UserProfile>();
            UserProfile newsItemOwnerUserProfile = null;
            Comment comment = CommentManager.GetByID(action.ContentID);

            if (comment != null)
            {
                NewsItem newsItem = NewsItemManager.GetByID(comment.TargetId);

                //Ensure that the news exists and isnt deleted
                if (newsItem != null && newsItem.IsDeleted==false)
                {
                    Guid ownerId = newsItem.OwnerID;
                    newsItemOwnerUserProfile = UserProfileManager.GetByID(ownerId);
                }
                else
                {
                    throw new Exception("NewsItem does not exist or is deleted");
                }

                userProfiles.Add(newsItemOwnerUserProfile);
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
