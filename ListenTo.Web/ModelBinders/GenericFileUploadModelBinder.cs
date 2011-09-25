using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ListenTo.Shared.Interfaces.Do;
using ListenTo.Web.Helpers;
using ListenTo.Shared.Interfaces.Helpers;

namespace ListenTo.Web.ModelBinders
{
    /// <summary>
    /// This binder is used only to upload files and to track a temporary file between posts.
    /// It is not designed to manage deletion of files. 
    /// THIS IS NOT ITS RESPONSIBILITY.
    /// 
    /// NOTE that the ID does NOT map on to a persisted file.. its used for tracking temporary files.
    /// 
    /// </summary>
    public class GenericFileUploadModelBinder<T>:IModelBinder where T:IHasBinaryData, new()
    {

        public IModelBinderHelpers ModelBinderHelpers { get; set; }
        public ITemporaryFileStrategy TemporaryFileStrategy { get; set; }
        public IFileValidationHelper FileValidationHelper { get; set; }

        #region IModelBinder Members

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            IHasBinaryData hasBinaryData = new T();

            PopulateHasBinaryData(hasBinaryData, controllerContext, bindingContext);

            return hasBinaryData;
        }

        #endregion

        public abstract IHasBinaryData ConstructHasBinaryDataInstance();

        private IHasBinaryData PopulateHasBinaryData(IHasBinaryData hasBinaryData, ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            Guid? id = ModelBinderHelpers.GetValueAndUpdateModelState<Guid?>(bindingContext, "FILEID");

            if (id.HasValue==false)
            {
                id = Guid.NewGuid();
            }
     
            hasBinaryData.ID = id.Value;

            HttpPostedFileBase file = ListenTo.Web.Helpers.FileHelpers.GetFileFromRequest(controllerContext.HttpContext.Request, "POSTEDFILE");

            if (file != null && file.ContentLength > 0)
            {
                byte[] content = ListenTo.Web.Helpers.FileHelpers.GetContentFromHttpPostedFile(file);

                //Is the file valid - the validation helper may be looking for images or mp3s etc
                if (FileValidationHelper.IsValidFileType(content))
                {
                    hasBinaryData.Data = content;
                    TemporaryFileStrategy.Create(hasBinaryData);
                }
            }
            else
            {
                //Do we have a temp file, if so repopulate......
                hasBinaryData = TemporaryFileStrategy.Fetch(hasBinaryData);
            }

            return hasBinaryData;
        }
    }
}
