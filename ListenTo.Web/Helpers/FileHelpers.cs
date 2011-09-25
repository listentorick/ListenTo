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
using ListenTo.Web.Models;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Web.Security;
using System.Text;

namespace ListenTo.Web.Helpers
{
    public abstract class FileHelpers
    {

        /// <summary>
        /// Gets 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        public static HttpPostedFileBase GetFileFromRequest(HttpRequestBase request, string key)
        {
            HttpPostedFileBase postedFile = request.Files[key];
            return postedFile;
        }

        public static HttpPostedFileBase GetFileFromRequest(HttpRequestBase request)
        {
            return GetFileFromRequest(request,"postedFile");
        }

        public static byte[] GetContentFromHttpPostedFile(HttpPostedFileBase postedFile)
        {
            //int contentLength = postedFile.ContentLength;
            //byte[] buf = new byte[contentLength];
            //postedFile.InputStream.Read(buf, 0, contentLength);
            //return buf;


            //int contentLength = postedFile.ContentLength;
            //byte[] data = new byte[contentLength];
            //for (int pos = 0; pos < contentLength; pos++)
            //{
            //    pos += postedFile.InputStream.Read(data, pos, contentLength - pos);
            //}

            int contentLength = postedFile.ContentLength;
            byte[] data = new byte[contentLength];
            for (int pos = 0; pos < contentLength; )
            {
                int len = postedFile.InputStream.Read(data, pos, contentLength - pos);
                if (len == 0)
                {
                    throw new ApplicationException("Upload aborted.");
                }
                pos += len;
            }


            return data;

        }

        private static bool IsFileAudio(HttpPostedFileBase postedFile)
        {
            //Assume that we are only ever uploading one file at a time.
            return postedFile.ContentType.StartsWith("audio");
        }

        /// <summary>
        /// Only checks the headers....
        /// </summary>
        /// <param name="postedFile"></param>
        /// <returns></returns>
        public static bool IsFileImage(Byte[] postedFileAsByteArray)
        {
            bool isImageHeader = false; 
           // if (postedFile.ContentLength > 0)
           // {
                byte[] header = new byte[4];

                //Grab the first 4 bytes
                for(int i=0; i<4;i++){
                    header[i] = postedFileAsByteArray[i];
                }

                string[] imageHeaders = new[]{
                "\xFF\xD8", // JPEG
                "BM",       // BMP
                "GIF",      // GIF
                Encoding.ASCII.GetString(new byte[]{137, 80, 78, 71})}; // PNG

              //  postedFile.InputStream.Read(header, 0, header.Length);

                //Latin-1 aka ISO-8859-1 - the extended ascii character set
                string ascii =  Encoding.GetEncoding("ISO-8859-1").GetString(header);

                isImageHeader = imageHeaders.Count(str => ascii.StartsWith(str)) > 0;
            //}

            return isImageHeader;
        }

        /// <summary>
        /// CHNAGE THIS SO WE PASS IN THE BYTE ARRAY - currently this will read the stream which is forward only!
        /// WE WILL NOT BE ABLE TO REACCESS THE DATA!!!
        /// </summary>
        /// <param name="postedFile"></param>
        /// <returns></returns>
        //public static bool IsFileMp3(HttpPostedFileBase postedFile)
        //{
        //    bool isFileAudio = false;

        //    if(IsFileAudio(postedFile)) {
        //        ListenTo.Core.Audio.MP3Info mp3Info = new ListenTo.Core.Audio.MP3Info();
        //        isFileAudio = mp3Info.ReadMP3Information(postedFile.InputStream);
        //    }
        //    return isFileAudio;
        //}


        public static ListenTo.Shared.DO.Image UpdateImageFromRequest(ListenTo.Shared.DO.Image image, HttpRequestBase request, string key)
        {
            ListenTo.Shared.DO.Image tempImage = GetImageFromRequest(request, key);
            if (tempImage != null)
            {
                image.Width = tempImage.Width;
                image.Height = tempImage.Height;
                image.Data = tempImage.Data;
            }
            return image;
        }

        public static ListenTo.Shared.DO.Image GetImageFromRequest(HttpRequestBase request, string key)
        {
            ListenTo.Shared.DO.Image image = null;
            HttpPostedFileBase file = Helpers.FileHelpers.GetFileFromRequest(request, key);


            if (file != null && file.ContentLength != 0 )
            {
                try
                {
                    Byte[] fileData = GetContentFromHttpPostedFile(file);

                    if (IsFileImage(fileData))
                    {
                        image = ImageHelpers.GetImage(fileData);
                    }
                }
                catch (Exception e)
                {
                    //The file is not an image even though the headers are correct!
                    //Log the exception
                    throw;
                }
            }
            return image;
        }

        /// <summary>
        /// This helper is designed to handle image data associated with the standard image upload View. 
        /// It extracts the data from the form keys provided.
        /// It will try to find an existing image to match against the imageIdKey key
        /// It will delete images if a deleteImageKey exists
        /// It will also always persist the image. This is done to allow image previewing etc
        /// </summary>
        /// <param name="imageManager"></param>
        /// <param name="request"></param>
        /// <param name="imageIdKey"></param>
        /// <param name="deleteImageKey"></param>
        /// <param name="fileDataKey"></param>
        /// <returns></returns>
        public static ListenTo.Shared.DO.Image ManageImageUploadData( IImageManager imageManager, HttpContextBase context, string imageIdKey, string deleteImageKey, string fileDataKey)
        {
            HttpRequestBase request = context.Request;
            //Manage the image - encapsulate this logic elsewhere...
            ListenTo.Shared.DO.Image image = null;
            string imageId = request.Form[imageIdKey];
            string deleteImage = request.Form[deleteImageKey];
            //We have an existing image
            if (FormatHelpers.IsGuid(imageId))
            {

                image = imageManager.GetByID(new Guid(imageId));
                if (image != null)
                {
                    if (deleteImage == null || deleteImage != "on")
                    {
                        //Now update the image with any relevant post data
                        //this ensures that the image data applied will replace the original data...
                        image = ListenTo.Web.Helpers.FileHelpers.UpdateImageFromRequest(image, request, fileDataKey);
                    }
                    else
                    {
                        //delete the image
                        image = null;
                    }
                }
            }
            else
            {
                //We dont have an existing image
                image = ListenTo.Web.Helpers.FileHelpers.GetImageFromRequest(request, fileDataKey);
            }
            
            if (image != null)
            {
                IListenToUser user = (IListenToUser)context.User;
                imageManager.HandleUploadedImage(image,user.UserCredentials);
            }

            return image;
        }




    }
}
