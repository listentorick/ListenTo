using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface ISiteManager : IManager<Site>
    {
        Site GetSiteByURL(string url);
        //IList<Site> GetSitesByTown(Guid townID);
 
    }
}
