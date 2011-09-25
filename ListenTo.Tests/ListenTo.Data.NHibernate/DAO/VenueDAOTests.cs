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
    public class VenueDAOTests : AbstractDaoTests
    {

        /// <summary>
        /// A setter method to enable automatic DI of the DAO instance.
        /// </summary>
        public IVenueDAO VenueDAO
        {
            set { this._venueDAO = value; }
            get { return this._venueDAO; }
        }

        private IVenueDAO _venueDAO;

        [Test]
        public void CanGetAllVenues()
        {
            IList<Venue> venues = VenueDAO.GetAll();
            Assert.That(venues, Is.Not.Null);
            Assert.That(venues, Is.Not.Empty);
        }


    }
}
