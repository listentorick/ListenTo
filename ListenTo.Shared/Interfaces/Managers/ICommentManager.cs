using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Utility;
using ListenTo.Shared.DTO;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface ICommentManager : IManager<Comment>
    {
        IPageOfList<CommentSummary> GetCommentSummaries(int pageSize, int currentPageIndex, Guid targetId);
    }
}
