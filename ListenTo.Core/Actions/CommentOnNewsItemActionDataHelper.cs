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
    /// <summary>
    /// Grabs action data required by the smtp publisher for a comment on news item action
    /// </summary>
    public class CommentOnNewsItemActionDataHelper: IActionDataHelper
    {
        public INewsItemManager NewsItemManager { get; set; }
        public ICommentManager CommentManager { get; set; }

        #region IActionDataHelper Members

        public object GetActionData(ListenTo.Shared.DO.Action action)
        {
            CommentOnNewsItemActionData commentOnNewsItemActionData = new CommentOnNewsItemActionData();
            Comment comment = CommentManager.GetByID(action.ContentID);
            
            if (comment != null)
            {
                NewsItem newsItem = NewsItemManager.GetByID(comment.TargetId);

                if (newsItem != null)
                {
                    commentOnNewsItemActionData.NewsItem = newsItem;
                }
                else
                {
                    throw new Exception("NewsItem does not exist or is deleted");
                }
            }
            else
            {
                throw new Exception("Comment doesnt exist!");
            }

            return commentOnNewsItemActionData;
        }

        #endregion
    }
}
