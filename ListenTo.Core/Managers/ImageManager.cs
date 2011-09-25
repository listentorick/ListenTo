using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Repository;
using ListenTo.Shared.RepositoryFilters;
using System.IO;
using ListenTo.Shared.Utility;
using ListenTo.Shared.Interfaces.Helpers;


namespace ListenTo.Core.Managers
{
    /// <summary>
    /// Images represent the meta data and the binary data
    /// ImageMetaData JUST represents the meta data i.e. width height
    /// The majority of the time, we are interested in the meta data.
    /// </summary>
    public class ImageManager : BaseManager, IImageManager
    {

        public IFileHelpers FileHelpers { get; set; }


        #region IManager<Image> Members

        /// <summary>
        /// Gets an image with the full meta data
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ListenTo.Shared.DO.Image GetByID(Guid id)
        {
            ListenTo.Shared.DO.ImageMetaData imageMetaData = this.GetImageMetaData(id);
            ListenTo.Shared.DO.Image image = Adapt(imageMetaData);
            image = (ListenTo.Shared.DO.Image)FileHelpers.PopulateFromFile(ImageHelpers.ConstructImagePath(image), image);
            return image;
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Deletes an image from the filesystem and the database
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public void Delete(Guid id)
        {
            ListenTo.Shared.DO.ImageMetaData imageMetaData = this.GetImageMetaData(id);
            if (imageMetaData != null)
            {
                string path = ImageHelpers.ConstructImagePath(imageMetaData);
                try
                {
                    //First remove the image
                    System.IO.File.Delete(path);
                    //Then remove the data from the database
                    this.Repository.DeleteImageMetaData(imageMetaData.ID);

                }
                catch (Exception e)
                {
                    throw;
                }
            }
        }


        private ListenTo.Shared.DO.Image CreateThumbnailImage(ListenTo.Shared.DO.Image image)
        {
            System.Drawing.Image mainImage = ImageHelpers.GetImage(image);
            System.Drawing.Image thumbnailImage = ImageHelpers.Thumbnail(mainImage, 40);
            ListenTo.Shared.DO.Image listenToThumbnailImage = ImageHelpers.GetImage(thumbnailImage);
            return listenToThumbnailImage;
        }

        /// <summary>
        /// Creates a thumbnail from the passed image and persists the thumbnail and the original image
        /// </summary>
        /// <param name="image"></param>
        public void HandleUploadedImage(ListenTo.Shared.DO.Image image, UserCredentials userCredentials)
        {
            ListenTo.Shared.DO.Image thumbnailImage = CreateThumbnailImage(image);
            image.Thumbnail = thumbnailImage;
            this.Save(thumbnailImage, userCredentials);
            this.Save(image, userCredentials);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="image"></param>
        public Image HandleUploadedImage(byte[] data, UserCredentials userCredentials)
        {
            ListenTo.Shared.DO.Image image = new Image();
            image.Data = data;

            //This will throw an exception if the data model is invalid. 
            ValidationRunner.Validate(image, userCredentials);
            
            //Construct an image object which contains all the meta data...
            image = Shared.Helpers.ImageHelpers.GetImage(image.Data);

            HandleUploadedImage(image, userCredentials);
            return image;
            
        }


        public ListenTo.Shared.DO.Image Save(ListenTo.Shared.Interfaces.DO.IDO dO, UserCredentials userCredentials)
        {
            ListenTo.Shared.DO.Image image = (ListenTo.Shared.DO.Image)dO;
            
            string imagePath = ImageHelpers.ConstructImagePath(image);

            //If a file already exists, delete it...
            if (System.IO.File.Exists(imagePath))
            {
                System.IO.File.Delete(imagePath);
            }

            //Save the image for the web
            ImageHelpers.SaveForWeb(image.Data, imagePath);

            //System.IO.File.WriteAllBytes(imagePath, image.Data);
            this.Repository.SaveImageMetaData(Adapt(image));
            return image;
        }

        public ImageMetaData Adapt(ListenTo.Shared.DO.Image image)
        {
            ImageMetaData imageMetaData = new ImageMetaData();
            imageMetaData.ID = image.ID;
            imageMetaData.Height = image.Height;
            imageMetaData.Width = image.Width;
            imageMetaData.Thumbnail = image.Thumbnail;
            return imageMetaData;
        }

        public ListenTo.Shared.DO.Image Adapt(ImageMetaData imageMetaData)
        {
            Image image = new Image();
            image.ID = imageMetaData.ID;
            image.Height = imageMetaData.Height;
            image.Width = imageMetaData.Width;
            image.Thumbnail = imageMetaData.Thumbnail;
            return image;
        }

        public ListenTo.Shared.DO.ImageMetaData GetImageMetaData(Guid id)
        {
            return this.Repository.GetImageMetaDatas().WithID(id).SingleOrDefault();
        }

        public IPageOfList<ImageMetaData> GetLatestImageMetaData(int pageSize, int currentPageIndex)
        {
            return this.Repository.GetImageMetaDatas().ToPageOfList(currentPageIndex, pageSize);
        }

        #endregion

    }
}
