using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.DAO
{
    public interface ITownDAO : IGenericDAO<Town, Guid?>
    {

      IList<Town> GetAllTownsRepresentedByASite(Guid siteID);

    }
}
