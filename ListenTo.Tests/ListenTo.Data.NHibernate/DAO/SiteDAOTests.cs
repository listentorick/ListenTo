using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using Spring.Context;
using Spring.Context.Support;
using log4net;
using Spring.Data.NHibernate;
using Spring.Transaction.Support;
using Spring.Transaction;
using Spring.Testing.NUnit;
using System.Diagnostics;
using ListenTo.Shared.Interfaces.DAO;
using ListenTo.Shared.DO;
using NUnit.Framework.SyntaxHelpers;


namespace Tests.ListenTo.Data.NHibernate.DAO
{
    [TestFixture]
    [Category("DB Tests")]
    public class SiteDAOTests : AbstractDaoTests
    {

        /// <summary>
        /// A setter method to enable automatic DI of the DAO instance.
        /// </summary>
        public ISiteDAO SiteDAO
        {
            set { this._siteDAO = value; }
            get { return this._siteDAO; }
        }

        private ISiteDAO _siteDAO;

        [Test]
        public void CanGetAllSites()
        {
            IList<Site> sites = SiteDAO.GetAll();
            Assert.That(sites, Is.Not.Null);
            Assert.That(sites, Is.Not.Empty);
        }

        [Test]
        public void CanGetSiteByURL()
        {
            string url = "localhost";
            Site site = SiteDAO.GetSiteByURL(url);
            Assert.That(site, Is.Not.Null);
        }

    }
}
