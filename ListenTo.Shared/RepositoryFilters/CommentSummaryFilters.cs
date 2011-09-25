using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DTO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class CommentSummaryFilters
    {

        public static IQueryable<CommentSummary> WithTargetID(this IQueryable<CommentSummary> qry, Guid Id)
        {
            return from comment in qry
                   where comment.TargetId == Id
                   select comment;
        }

    }

}
