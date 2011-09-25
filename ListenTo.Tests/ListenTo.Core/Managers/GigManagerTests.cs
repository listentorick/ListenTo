using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Core;
using ListenTo.Shared.DO;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using ListenTo.Shared.Interfaces.DAO;
using ListenTo.Core.Managers;

namespace Tests.ListenTo.Core.Managers
{
    [TestFixture]
    public class GigManagerTests : AbstractIocSupportedTests
    {
        /// <summary>
        /// This test checks that the gigDAO.GetById is called once when gigManager.GetByID is called and the correct id is passed through
        /// </summary>
        [Test]
        public void GetById_Calls_GigDAO_Method_GetById_Once_And_Returns_A_Gig()
        {
            MockRepository mocks = new MockRepository();

            Guid gigId = Guid.NewGuid();
            Gig gig = new Gig();
            gig.ID = gigId;

            IGigDAO gigDAO = mocks.DynamicMock<IGigDAO>();
            GigManager gigManager = new GigManager();
            gigManager.GigDAO = gigDAO;

            Expect.Call(gigDAO.GetById(gigId))
               .Constraints(Is.Equal(gigId))
               .Repeat.Once()
               .Return(gig);
                
            mocks.ReplayAll();

            Gig result = gigManager.GetByID(gigId);

            mocks.VerifyAll();

            Assert.AreEqual(gig.ID, result.ID);
       
        }


        private IList<Gig> CreateListOfGigs(int numGigs, DateTime startDate)
        {
            IList<Gig> gigs = new List<Gig>();

            for (int i = 0; i < numGigs; i++)
            {
                Guid gigId = Guid.NewGuid();
                Gig gig = new Gig();
                gig.ID = gigId;
                gig.StartDate = startDate;
                gigs.Add(gig);
            }

            return gigs;
        }

        /// <summary>
        /// This test checks that the gigDAO.GetById is called once when gigManager.GetByID is called and the correct id is passed through
        /// </summary>
        [Test]
        public void GetGigsBySiteAfterDate_Calls_GigDAO_Method_GetGigsBySiteAfterDate_Once_And_Returns_Gigs()
        {
            MockRepository mocks = new MockRepository();
            
            DateTime startDate = DateTime.Now;
            int numGigs = 10;
            List<Gig> gigs = (List<Gig>)CreateListOfGigs(numGigs, startDate);

            Guid siteId = Guid.NewGuid();

            IGigDAO gigDAO = mocks.DynamicMock<IGigDAO>();
            GigManager gigManager = new GigManager();
            gigManager.GigDAO = gigDAO;

            Expect.Call(gigDAO.GetGigsBySiteAfterDate(siteId, startDate))
               .Constraints(new AbstractConstraint[] { Is.Equal(siteId), Is.Equal(startDate) })
               .Repeat.Once()
               .Return(gigs);

            mocks.ReplayAll();

            List<Gig> result = (List<Gig>)gigManager.GetGigsBySiteAfterDate(siteId, startDate);

            mocks.VerifyAll();

        }
    }
}

