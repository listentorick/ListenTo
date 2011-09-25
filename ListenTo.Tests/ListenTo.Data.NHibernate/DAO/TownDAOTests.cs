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
    public class TownDAOTests : AbstractDaoTests
    {

        /// <summary>
        /// A setter method to enable automatic DI of the DAO instance.
        /// </summary>
        public ITownDAO TownDAO
        {
            set { this._townDAO = value; }
            get { return this._townDAO; }
        }

        private ITownDAO _townDAO;

        [Test]
        public void CanGetAllTowns()
        {
            IList<Town> towns = TownDAO.GetAll();
            Assert.That(towns, Is.Not.Null);
            Assert.That(towns, Is.Not.Empty);
        }

        [Test]
        public void CanGetAllTownsRepresentedByASite()
        {
            //This guid represents ListenToManchester
            Guid siteId = new Guid("{da50ad46-61a0-4ba2-96ff-7e3dddb3b761}");
            IList<Town> towns = TownDAO.GetAllTownsRepresentedByASite(siteId);
            Assert.That(towns, Is.Not.Null);
            Assert.That(towns, Is.Not.Empty);
        }

    }
}
