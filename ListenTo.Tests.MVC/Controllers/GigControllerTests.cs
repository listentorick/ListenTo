using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using System.Web.Mvc;
using ListenTo.Web.Controllers;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Tests.Shared;

namespace ListenTo.Tests.MVC.Controllers
{
    [TestFixture]
    public class GigControllerTests
    {

        [Test]
        public void GigController_Should_Contain_Index_Method_Which_Accepts_GigID_And_Returns_A_Gig()
        {

            MockRepository mocks = new MockRepository();

            Guid gigId = Guid.NewGuid();
            Gig gig = new Gig();
            gig.ID = gigId;

            //Mock the GigManager
            IGigManager gigManager = mocks.DynamicMock<IGigManager>();
            GigController gigController = new GigController();
            gigController.GigManager = gigManager;

            Expect.Call(gigManager.GetByID(gigId))
                .Constraints(Is.Equal(gigId))
                .Repeat.Once()
                .Return(gig);

            mocks.ReplayAll();

            ViewResult result = (ViewResult)gigController.Index(gigId);
            Gig returnedData = (Gig)(result.ViewData.Model);

            mocks.VerifyAll();

            Assert.IsNotNull(returnedData);
            Assert.AreEqual(gig.ID, returnedData.ID);

        }

        /// <summary>
        /// This tests how we expect the controller to infer the date based upon the passed year, month and day
        /// If we dont pass a Year, Month or Day we expect todays year, month and day to be used
        /// </summary>
        [Test]
        [Category("List")]
        public void List_Method_Calls_GetGigsBySiteAfterDate_With_DateNow_When_Year_Month_Day_Are_Not_Provided()
        {
            DateTime expectedDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
            TestGigControllersListMethod(expectedDate, null, null, null);
        }

        /// <summary>
        /// This tests how we expect the controller to infer the date based upon the passed year, month and day
        /// If we pass a Year and Month only we expect the day to be set to 1 i.e. year/month/01
        /// </summary>
        [Test]
        [Category("List")]
        public void List_Method_Calls_GetGigsBySiteAfterDate_With_Date_YM1_When_Just_A_Year_And_Month_Are_Provided()
        {
            int year = DateTime.Now.Year;
            int month = DateTime.Now.Month;

            DateTime expectedDate = new DateTime(year, month, 1);
            TestGigControllersListMethod(expectedDate, year, month, null);
        }

        /// <summary>
        /// This tests how we expect the controller to infer the date based upon the passed year, month and day
        /// If we just pass a year we expect year/01/01
        /// </summary>
        [Test]
        [Category("List")]
        public void List_Method_Calls_GetGigsBySiteAfterDate_With_Y11_When_Just_Year_Provided()
        {
            int year = DateTime.Now.Year;

            DateTime expectedDate = new DateTime(year, 01, 01);
            TestGigControllersListMethod(expectedDate, year, null, null);
        }

        /// <summary>
        /// This tests how we expect the controller to infer the date based upon the passed year, month and day
        /// If we just pass a year we expect year/01/01
        /// </summary>
        [Test]
        [Category("List")]
        public void List_Method_Calls_GetGigsBySiteAfterDate_With_YMD_When_Year_Month_Day_Are_Provided()
        {
            int year = DateTime.Now.Year;
            int month = DateTime.Now.Month;
            int day = DateTime.Now.Day;

            DateTime expectedDate = DateTime.Now.Date;
            TestGigControllersListMethod(expectedDate, expectedDate.Year, expectedDate.Month, expectedDate.Day);
        }

        private void TestGigControllersListMethod(DateTime expectedDate, int? year, int? month, int? day)
        {
            MockRepository mocks = new MockRepository();

            Guid siteId = new Guid("da50ad46-61a0-4ba2-96ff-7e3dddb3b761");

            IList<Gig> gigs = GigHelpers.ConstructGigs(10, expectedDate, null);

            //Mock the GigManager
            IGigManager gigManager = mocks.DynamicMock<IGigManager>();
            GigController gigController = new GigController();
            gigController.GigManager = gigManager;

            Expect.Call(gigManager.GetGigsBySiteAfterDate(siteId, expectedDate))
                .Constraints(new AbstractConstraint[] { Is.Equal(siteId), Is.Equal(expectedDate) })
                .Repeat.Once()
                .Return(gigs);

            mocks.ReplayAll();

            ViewResult result = (ViewResult)gigController.List(year, month, day);
            List<Gig> returnedData = (List<Gig>)(result.ViewData.Model);

            mocks.VerifyAll();

        }

    }
}