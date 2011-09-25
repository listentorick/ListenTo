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
using ListenTo.Shared.Interfaces.Do;
using ListenTo.Web.Models;
using ListenTo.Web.Helpers;

namespace ListenTo.Web.ModelBinders
{
    /// <summary>
    /// Attempts to create an System.Drawing.Image 
    /// </summary>
    public class UploadFilePartialViewModelModelBinderAttribute : CustomModelBinderAttribute
    {
        public override IModelBinder GetBinder()
        {
            return ListenTo.Web.Helpers.IOCHelper.GetUploadFilePartialViewModelModelBinder();
        }
    }

    /// <summary>
    /// This binder grabs any post data out of the form. Use this with the controller method HandleTemporaryFiles if you want 
    /// to be able to manage files across posts
    /// </summary>
    public class UploadFilePartialViewModelModelBinder: IModelBinder
    {
        public IModelBinderHelpers ModelBinderHelpers { get; set; }


        public const string POSTED_FILE = "postedFile";

        #region IModelBinder Members

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            UploadFilePartialViewModel model = null;

            Guid? id = ModelBinderHelpers.GetValueAndUpdateModelState<Guid?>(bindingContext, "FILEID");
           
            if (bindingContext.Model == null)
            {
                model = new UploadFilePartialViewModel(); 
            } else {
                model = (UploadFilePartialViewModel)bindingContext.Model;
            }

            if (!id.HasValue || id.Value == Guid.Empty)
            {
               id = Guid.NewGuid();
            }

            model.ID = id.Value;

            HttpPostedFileBase file = ListenTo.Web.Helpers.FileHelpers.GetFileFromRequest(controllerContext.HttpContext.Request, "POSTEDFILE");

            if (file != null && file.ContentLength > 0)
            {
                byte[] content = ListenTo.Web.Helpers.FileHelpers.GetContentFromHttpPostedFile(file);
                model.Data = content;
            }

            return model;

        }

        #endregion
    }
}