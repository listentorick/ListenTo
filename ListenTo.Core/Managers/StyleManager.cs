using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Repository;
using ListenTo.Shared.RepositoryFilters;
using ListenTo.Shared.DTO;

namespace ListenTo.Core.Managers
{
    public class StyleManager: BaseManager, IStyleManager
    {

        #region IManager<Style> Members

        public ListenTo.Shared.DO.Style GetByID(Guid id)
        {
            return this.Repository.GetStyles().WithID(id).Single();
        }

        public ListenTo.Shared.DO.Style Save(ListenTo.Shared.Interfaces.DO.IDO dO, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }
        

        #endregion

        public IList<Style> GetStyles()
        {
            return this.Repository.GetStyles().ToList();
        }

        public IList<StyleSummary> GetStyleSummaries(Guid siteId)
        {
            return this.Repository.GetStyleSummaries(siteId);
        }

        public Style GetStyleWithName(string name)
        {
            return this.Repository.GetStyleWithName(name);
        }
    }
}
