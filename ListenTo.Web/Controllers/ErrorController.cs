using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net;

namespace ListenTo.Web.Controllers
{

    public class ErrorController : Controller
    {

        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult HandleHttpError()
        {
            ViewResult view = null;
            switch (Response.StatusCode)
            {
                case (int)HttpStatusCode.InternalServerError:
                case (int)HttpStatusCode.NotFound:
                    view = View(Response.StatusCode.ToString());
                    break;
                default:
                    break;
            }

            return view;

        }
    }
}
