using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DAO;
using ListenTo.Shared.DO;

namespace ListenTo.Data.NHibernate.DAO
{
    public class TownDAO : HibernateDAO<Town, Guid?>, ListenTo.Shared.Interfaces.DAO.ITownDAO
    {

        #region ITownDAO Members

        public IList<Town> GetAllTownsRepresentedByASite(Guid siteID)
        {
            return this.GetAllByNamedQueryAndNamedParam("Town.GetAllTownsRepresentedByASite", "SiteID", siteID);
        }

        #endregion
    }
}
