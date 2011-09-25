using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Enums;
using ListenTo.Shared.Interfaces.Actions;

namespace ListenTo.Core.Actions
{
    public class ActionForCommentBuilderFactory : IActionForCommentBuilderFactory
    {
        /// <summary>
        /// ContentType refers to the type of content the comment is applied to
        /// </summary>
        public IDictionary<ContentType, IActionForCommentBuilder> ActionForCommentBuilders { get; set; }

        #region IActionForCommentBuilderFactory Members

        /// <summary>
        /// returns an instance of a IActionForCommentBuilder
        /// which is responsible for constructing an action 
        /// for the comment of the correct type and populating the target site data
        /// </summary>
        /// <param name="comment"></param>
        /// <returns></returns>
        public IActionForCommentBuilder GetBuilder(ListenTo.Shared.DO.Comment comment)
        {
            IActionForCommentBuilder builder = null;
            this.HasBuilder(comment.ContentType, out builder);
            return builder;
        }

        public bool HasBuilder(ContentType ct, out IActionForCommentBuilder builder)
        {
            builder = null;
            if (this.ActionForCommentBuilders.ContainsKey(ct))
            {
                builder = this.ActionForCommentBuilders[ct];
            }
            return builder!=null;
        }

        #endregion
    }
}
