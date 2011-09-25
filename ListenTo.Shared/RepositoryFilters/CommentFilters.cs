using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class CommentFilters
    {

        public static IQueryable<Comment> WithID(this IQueryable<Comment> qry, Guid Id)
        {
            return from comment in qry
                   where comment.ID == Id
                   select comment;
        }

    }

}
