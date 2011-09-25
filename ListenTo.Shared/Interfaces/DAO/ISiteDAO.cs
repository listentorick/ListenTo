using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.DAO
{
    public interface ISiteDAO: IGenericDAO<Site, Guid?>
    {
        Site GetSiteByURL(string url);
    }
}
