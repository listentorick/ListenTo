using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ListenTo.Web.Models;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Web.Constants;

namespace ListenTo.Web.ModelBinders
{
    public class UploadImagePopupViewModelModelBinder: IModelBinder
    {
        public IModelBinderHelpers ModelBinderHelpers { get; set; }
        public IImageManager ImageManager { get; set; }

        #region IModelBinder Members

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            UploadImagePopupViewModel model = null;

            Guid? id = ModelBinderHelpers.GetValueAndUpdateModelState<Guid?>(bindingContext, ViewIdentifiers.UPLOAD_IMAGE_POPUP_IMAGE_ID);

            if (bindingContext.Model == null)
            {
                model = new UploadImagePopupViewModel();
            }
            else
            {
                model = (UploadImagePopupViewModel)bindingContext.Model;
            }

            if (id.HasValue)
            {
                model.ImageMetaData = ImageManager.GetImageMetaData(id.Value);
            }

            return model;

        }

        #endregion
    }
}
