using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Core.Managers
{
    public class SiteManager : BaseManager, ISiteManager
    {

        #region IManager Members

        public Site GetByID(Guid id)
        {
            throw new NotImplementedException();
        }

        public Site Save(IDO dO, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        #endregion

        public Site GetSiteByURL(string URL)
        {
            return this.Repository.GetSiteByURL(URL);
        }
    }
}
