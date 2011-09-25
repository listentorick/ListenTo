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
    public class BinaryDataResult : ActionResult
    {
        public BinaryDataResult() { }

        public Byte[] Data { get; set; }

        public override void ExecuteResult(ControllerContext context)
        {
            // verify properties
            if (Data == null)
            {
                throw new ArgumentNullException("Data");
            }
            context.HttpContext.Response.Clear();
            //context.HttpContext.Response.ContentType = "audio/mpeg";
            context.HttpContext.Response.AddHeader("Content-Length", Data.Length.ToString());
            context.HttpContext.Response.BinaryWrite(Data);
        }
    }

}
