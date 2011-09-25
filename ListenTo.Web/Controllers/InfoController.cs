using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Web.Mvc;

namespace ListenTo.Web.Controllers
{
    public class InfoController : ListenToController
    {
        public ActionResult Error()
        {
            return View();
        }

        public ActionResult AddingContent()
        {
            return View();
        }

        public ActionResult PrivacyPolicy()
        {
            return View();
        }

        public ActionResult TermsAndConditions()
        {
            return View();
        }

        public ActionResult About()
        {
            return View();
        }

        public ActionResult RSS()
        {
            return View();
        }
    }

}
