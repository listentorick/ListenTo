using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Utility;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface IWhatsNewManager
    {
        IPageOfList<IDTO> GetWhatsNewSummaries(int pageSize, int currentPageIndex, Guid siteId);
        IPageOfList<IDTO> GetWhatsNewSummariesOwnedByUser(int pageSize, int currentPageIndex, Guid siteId, Guid UserId);

    }
}
