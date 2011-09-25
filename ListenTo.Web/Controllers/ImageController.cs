using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ListenTo.Web.Models;
using ListenTo.Web.Helpers;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Web.Security;
using ListenTo.Shared.Validation;
using ListenTo.Shared.DO;

namespace ListenTo.Web.Controllers
{
    public class ImageController: ListenToController
    {
        public IImageManager ImageManager { get; set; }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Upload()
        {
            UploadImageViewModel uploadImageViewModel = new UploadImageViewModel();
            uploadImageViewModel.UploadFilePartialViewModel = new UploadFilePartialViewModel();
            return View(uploadImageViewModel);
        }

        [Authorize]
        [AcceptVerbs("POST")]
        [ValidateInput(false)]
        public ActionResult Upload(UploadFilePartialViewModel file)
        {

            UploadImageViewModel uploadImageViewModel = new UploadImageViewModel();
            uploadImageViewModel.UploadFilePartialViewModel = file;

            IListenToUser user = (IListenToUser)this.HttpContext.User;

            try
            {
                //So that files which arent valid arent persisted, we use the ImageFileValidationHelper..
                file = (UploadFilePartialViewModel)this.HandleTemporaryFile(file, new ImageFileValidationHelper());
            }               
            catch (InvalidFileTypeException e)
            {
                LOG.Info("Attempt to upload invalid image",e);
            }
            
            ListenTo.Shared.DO.Image image = null;
            
            try
            {
                image = ImageManager.HandleUploadedImage(file.Data, user.UserCredentials);
                uploadImageViewModel.ImageUploadSuccesful = true;
                uploadImageViewModel.Image = image;
                LOG.Info("User " + this.User.Identity.Name + " uploaded an image with id " + image.ID);

            }
            catch (ValidationException e)
            {
                e.AddToModelState(ViewData.ModelState);
                LOG.Info("Attempt to upload invalid image", e);
            }

            return View(uploadImageViewModel);
        }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Index(Guid id)
        {
            ImageMetaData imageMetaData = ImageManager.GetImageMetaData(id);
            return View(imageMetaData);
        }


    }
}
