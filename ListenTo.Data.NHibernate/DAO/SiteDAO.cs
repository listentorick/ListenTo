using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DAO;
using ListenTo.Shared.DO;
using NHibernate.Expression;
using NHibernate;

namespace ListenTo.Data.NHibernate.DAO
{
    public class SiteDAO : HibernateDAO<Site, Guid?>, ListenTo.Shared.Interfaces.DAO.ISiteDAO
    {

        #region ISiteDAO Members

        public Site GetSiteByURL(string URL)
        {
            IList<Site> sites = this.GetAllByNamedQueryAndNamedParam(
                "Site.GetSiteByURL",
                "URL",
                URL);

            if (sites != null && sites.Count > 0)
                return sites[0];
            else
	            return null;
        }

        #endregion
    }
}
