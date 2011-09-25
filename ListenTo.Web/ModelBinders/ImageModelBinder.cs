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
using System.Text;
using ListenTo.Shared.DO;
using System.Collections.Generic;
using ListenTo.Shared.Helpers;

namespace ListenTo.Web.ModelBinders
{
    /// <summary>
    /// Attempts to create an System.Drawing.Image 
    /// </summary>
    public class ImageModelBinderAttribute : CustomModelBinderAttribute
    {
        public override IModelBinder GetBinder()
        {
            return ListenTo.Web.Helpers.IOCHelper.GetImageModelBinder();
        }
    }

    public class ImageModelBinder : IModelBinder
    {

        public const string POSTED_FILE = "postedFile";

        #region IModelBinder Members

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            ListenTo.Shared.DO.Image image = null;

            HttpRequestBase request = controllerContext.HttpContext.Request;
            
            try
            {
                image = ListenTo.Web.Helpers.FileHelpers.GetImageFromRequest(request, POSTED_FILE);
            }
            catch (Exception e)
            {
                bindingContext.ModelState.AddModelError("POSTED_FILE", "File is not an image!");
            }

            return image;
        }

        #endregion
    }
}