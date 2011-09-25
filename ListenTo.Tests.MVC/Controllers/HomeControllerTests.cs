using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using System.Web.Mvc;
using ListenTo.Web.Controllers;


namespace ListenTo.Tests.MVC.Controllers
{

    [TestFixture]
    public class HomeControllerTests
    {
        [Test]
        public void HomeController_Should_Contain_IndexMethod()
        {
            HomeController homeController = new HomeController();
            ActionResult result = homeController.Index();

            Assert.IsNotNull(result);
        }
    }

}
