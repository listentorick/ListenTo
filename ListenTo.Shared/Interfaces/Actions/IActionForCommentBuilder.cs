using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Actions
{
    public interface IActionForCommentBuilder
    {
        /// <summary>
        /// Builds an action for the comment
        /// For example, if the comment is associated with a news item, then 
        /// the action will be associated with the sites that the news item belongs to and will have an
        /// action type of COMMENTED_ON_A_NEWS_ITEM
        /// </summary>
        /// <param name="comment"></param>
        /// <returns></returns>
        ListenTo.Shared.DO.Action BuildAction(Comment comment);
    }
}
