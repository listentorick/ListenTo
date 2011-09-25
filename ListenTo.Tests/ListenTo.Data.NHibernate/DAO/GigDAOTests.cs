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
    public class GigDAOTests : AbstractDaoTests
    {

        /// <summary>
        /// A setter method to enable automatic DI of the DAO instance.
        /// </summary>
        public IGigDAO GigDAO
        {
            set { this._gigDAO = value; }
            get { return this._gigDAO; }
        }

        private IGigDAO _gigDAO;

        [Test]
        public void CanGetAllGigs()
        {
            IList<Gig> gigs = GigDAO.GetAll();
            Assert.That(gigs, Is.Not.Null);
            Assert.That(gigs, Is.Not.Empty);
        }

        [Test]
        public void CanGetGigsBySite()
        {
            Guid siteId = new Guid("{da50ad46-61a0-4ba2-96ff-7e3dddb3b761}");
            IList<Gig> gigs = GigDAO.GetGigsBySite(siteId);
            Assert.That(gigs, Is.Not.Null);
            Assert.That(gigs, Is.Not.Empty);
        }

        [Test]
        public void CanGetGigsBySiteAfterDate()
        {
            DateTime date = DateTime.Now;

            Guid siteId = new Guid("{da50ad46-61a0-4ba2-96ff-7e3dddb3b761}");
            IList<Gig> gigs = GigDAO.GetGigsBySiteAfterDate(siteId, date);
            Assert.That(gigs, Is.Not.Null);
            Assert.That(gigs, Is.Not.Empty);

            foreach(Gig gig in gigs) {
                
            }
        }
    }
}
