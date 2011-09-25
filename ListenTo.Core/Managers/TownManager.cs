using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Repository;
using ListenTo.Shared.RepositoryFilters;

namespace ListenTo.Core.Managers
{
    public class TownManager: BaseManager, ITownManager
    {

        #region IManager Members

        public Town GetByID(Guid id)
        {
            return this.Repository.GetTowns().WithID(id).Single();
        }

        public Town Save(ListenTo.Shared.Interfaces.DO.IDO dO, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        #endregion

        public IList<Town> GetTowns()
        {
            return this.Repository.GetTowns().ToList();
        }
    }
}
