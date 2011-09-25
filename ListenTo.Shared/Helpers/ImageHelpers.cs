using System;
using System.Drawing.Imaging;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Text;
using System.Linq;
namespace ListenTo.Shared.Helpers
{

	/// <summary>
	/// Graphics library for manipulating images in a standard way.
	/// </summary>
	public abstract class ImageHelpers
	{

		/// <summary>
		/// This will scale the image so that apsect ratio is maintained.
		/// The width/height will never exceed the values provided.
		/// The original image is not effected
		/// </summary>
		/// <param name="sourceImage"></param>
		/// <param name="width"></param>
		/// <param name="height"></param>
		/// <returns>The Scaled Image</returns>
		public static Image ScaleUnstretched(Image sourceImage, int width,
			int height)
		{

			double scaleFactor;
			double scaleX, scaleY;

			scaleX = width / (double)sourceImage.Width;
			scaleY = height / (double)sourceImage.Height;

			if(scaleX > scaleY)
			{
				scaleFactor = scaleY;
			}
			else
			{
				scaleFactor = scaleX;
			}

			System.Drawing.Image scaledImage = Scale(sourceImage,
				(int)(sourceImage.Width*(float)scaleFactor),
				(int)(sourceImage.Height*(float)scaleFactor));

			return scaledImage;

		}

        public static string ConstructImagePath(ListenTo.Shared.DO.ImageMetaData imageMetaData)
        {
            var absolutePath = System.Configuration.ConfigurationSettings.AppSettings["ApplicationPath"] + System.Configuration.ConfigurationSettings.AppSettings["ApplicationRelativeImageDirectoryPath"];
            absolutePath += "/" + imageMetaData.ID.ToString() + ".jpg";
            return absolutePath;
        }

        public static string ConstructImageUrl(ListenTo.Shared.DO.ImageMetaData imageMetaData)
        {
            return System.Configuration.ConfigurationSettings.AppSettings["ApplicationRelativeImageDirectoryPath"] + "/" + imageMetaData.ID.ToString() + ".jpg"; 
        }

        /// <summary>
        /// Only checks the headers....
        /// </summary>
        /// <param name="postedFile"></param>
        /// <returns></returns>
        public static bool IsFileImage(Byte[] data)
        {
            bool isImageHeader = false;

            byte[] header = new byte[4];

            //Grab the first 4 bytes
            for (int i = 0; i < 4; i++)
            {
                header[i] = data[i];
            }

            string[] imageHeaders = new[]{
                "\xFF\xD8", // JPEG
                "BM",       // BMP
                "GIF",      // GIF
                Encoding.ASCII.GetString(new byte[]{137, 80, 78, 71})}; // PNG

            //  postedFile.InputStream.Read(header, 0, header.Length);

            //Latin-1 aka ISO-8859-1 - the extended ascii character set
            string ascii = Encoding.GetEncoding("ISO-8859-1").GetString(header);

            isImageHeader = imageHeaders.Count(str => ascii.StartsWith(str)) > 0;
            //}

            return isImageHeader;
        }



        /// <summary>
        /// Gets a ListenTo Image object from a System.Drawing.Image object
        /// </summary>
        /// <param name="imageIn"></param>
        /// <returns></returns>
        public static ListenTo.Shared.DO.Image GetImage(Image imageIn)
        {
            byte[] data = ImageHelpers.ImageToByteArray(imageIn);
            return ImageHelpers.GetImage(data);
        }

        /// <summary>
        /// Converts a listento image into a System.Drawing image
        /// </summary>
        /// <param name="imageIn"></param>
        /// <returns></returns>
        public static Image GetImage(ListenTo.Shared.DO.Image imageIn)
        {
            return ImageHelpers.GetImageFromByteArray(imageIn.Data);
        }

        /// <summary>
        /// Creates a ListenTo Image from a byte array
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public static ListenTo.Shared.DO.Image GetImage(byte[] data)
        {
            System.Drawing.Image image = GetImageFromByteArray(data);
            ListenTo.Shared.DO.Image listenToImage = new ListenTo.Shared.DO.Image();
            listenToImage.Created = DateTime.Now;
            listenToImage.Data = data;
            listenToImage.Height = image.Height;
            listenToImage.Width = image.Width;
            listenToImage.ID = Guid.NewGuid();
            return listenToImage;
        }

        /// <summary>
        /// Converts a byte array into a System.Drawing.Image
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public static System.Drawing.Image GetImageFromByteArray(byte[] data)
        {

            MemoryStream ms = new MemoryStream(data);
            Image bitmap = null;
            try
            {
                bitmap = Image.FromStream(ms);
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                ms.Dispose();
            }
           
            return bitmap;
        }

        /// <summary>
        /// Converts a System.Drawing.Image object into a byte array
        /// </summary>
        /// <param name="imageIn"></param>
        /// <returns></returns>
        public static byte[] ImageToByteArray(System.Drawing.Image imageIn)
        {
            MemoryStream ms = new MemoryStream();
            imageIn.Save(ms, System.Drawing.Imaging.ImageFormat.Bmp);
            return ms.ToArray();
        }

		/// <summary>
		/// This will scale the image to the requested width and height.
		/// The original image is not effected
		/// </summary>
		/// <param name="originalImage"></param>
		/// <param name="width"></param>
		/// <param name="height"></param>
		/// <returns>The scaled image</returns>
		public static Image Scale(Image sourceImage, int width, int height)
		{
			//Build a bitmap
			Bitmap scaledImage = new Bitmap(width, height);

			//Make a Graphics object for the result Bitmap.
			Graphics outputImage = Graphics.FromImage(scaledImage);
			
			//Quality
			outputImage.CompositingQuality = CompositingQuality.HighQuality;
			outputImage.SmoothingMode = SmoothingMode.HighQuality;
			outputImage.InterpolationMode = InterpolationMode.HighQualityBicubic;

			//Copy the scaled image onto our bitmap object
			outputImage.DrawImage(sourceImage,0,0,scaledImage.Width+1,scaledImage.Height+1);

			outputImage.Dispose();
			outputImage = null;

			return scaledImage;

		}

		/// <summary>
		/// Crops an image based on the rectangle passed to it
		/// </summary>
		/// <param name="sourceImage"></param>
		/// <param name="viewPort"></param>
		/// <returns>The cropped image</returns>
		public static Image Crop(Image sourceImage,Rectangle viewPort)
		{
			//Build a bitmap
			Bitmap croppedImage = new Bitmap(viewPort.Width, viewPort.Height);
			
			Graphics drawingSurface = Graphics.FromImage(croppedImage);

			//Quality
			drawingSurface.CompositingQuality = CompositingQuality.HighQuality;
			drawingSurface.SmoothingMode = SmoothingMode.HighQuality;
			drawingSurface.InterpolationMode = InterpolationMode.HighQualityBicubic;

			Rectangle sourceRectangle = new
			Rectangle(0,0,viewPort.Width,viewPort.Height);

			drawingSurface.DrawImage(sourceImage,sourceRectangle,viewPort,GraphicsUnit.Pixel);

			drawingSurface.Dispose();
			drawingSurface = null;

			return croppedImage;

		}

		/// <summary>
		/// Crops an image to a square
		/// </summary>
		/// <param name="sourceImage"></param>
		/// <returns>The cropped image</returns>
		public static Image CropToSquare(Image sourceImage)
		{
			int dDimensions = 0;

			int sourceX = 0;
			int sourceY = 0;
			int sourceWidth = 0;
			int sourceHeight = 0;

			if(sourceImage.Width>sourceImage.Height)
			{
				dDimensions = sourceImage.Width - sourceImage.Height;
				sourceX = dDimensions/2;
				sourceY = 0;
				sourceWidth = sourceImage.Height;
				sourceHeight = sourceImage.Height;
			}
			else
			{
				dDimensions = sourceImage.Height - sourceImage.Width;
				sourceX = 0;
				sourceY = dDimensions/2;
				sourceWidth = sourceImage.Width;
				sourceHeight = sourceImage.Width;
			}

			//Crop Source image so that it becomes a square image
			Rectangle viewPort = new Rectangle(sourceX,sourceY,sourceWidth,sourceHeight);

			System.Drawing.Image outputImage = Crop(sourceImage,viewPort);

			return outputImage;

		}


		/// <summary>
		/// Returns a thumbnail of the image.
		/// The thumbnail has a background color
		/// </summary>
		/// <param name="sourceImage"></param>
		/// <returns>The thumbnail image</returns>
		public static Image ThumbnailWithBackground(Image sourceImage,int sideLength,Color color)
		{
			System.Drawing.Image foregroundImage = ScaleUnstretched(sourceImage,sideLength,sideLength);

			//Make a Graphics object for the result Bitmap.

			Bitmap backgroundImage = new Bitmap(sideLength, sideLength);
			Graphics drawingSurface = Graphics.FromImage(backgroundImage);

			//Quality
			drawingSurface.CompositingQuality = CompositingQuality.HighQuality;
			drawingSurface.SmoothingMode = SmoothingMode.HighQuality;
			drawingSurface.InterpolationMode = InterpolationMode.HighQualityBicubic;

			//Check to see which dimension has been shrunk
			int dh = (sideLength-foregroundImage.Height);
			int dw = (sideLength-foregroundImage.Width);

			if(dh!=0){dh=dh/2;}
			if(dw!=0){dw=dw/2;}

			drawingSurface.Clear(color);
			drawingSurface.DrawImage(foregroundImage,dw,dh,foregroundImage.Width+1,foregroundImage.Height+1);

			drawingSurface.Dispose();
			drawingSurface = null;

			return backgroundImage;

		}

		/// <summary>
		/// Returns a square thumbnail of the image.
		/// </summary>
		/// <param name="sourceImage"></param>
		/// <returns>The thumbnail image</returns>
		public static Image Thumbnail(Image sourceImage,int sideLength)
		{
			System.Drawing.Image croppedImage = CropToSquare(sourceImage);
			return ScaleUnstretched(croppedImage,sideLength,sideLength);
		}


		internal static ImageCodecInfo GetEncoderInfo(String mimeType)
		{
			int j;
			ImageCodecInfo[] encoders;
			encoders = ImageCodecInfo.GetImageEncoders();
			for(j = 0; j < encoders.Length; ++j)
			{
				if(encoders[j].MimeType == mimeType)
					return encoders[j];
			}
			return null;
		}

		public static void SaveJPGWithCompressionSetting( Image image, string szFileName, long lCompression )
		{
			EncoderParameters eps = new EncoderParameters(1);
			eps.Param[0] = new EncoderParameter( System.Drawing.Imaging.Encoder.Quality, lCompression );
			ImageCodecInfo ici = GetEncoderInfo("image/jpeg");
			image.Save( szFileName, ici, eps );
		}

        public static void SaveForWeb(byte[] data, string szFileName)
        {

            //We cant use GetImageFromByteArray because we cant manipulate the image 
            //once the source memory stream has been closed
            //therefore we have to duplicate code here :(

            MemoryStream ms = new MemoryStream(data);
            Image bitmap = null;
            try
            {
                bitmap = Image.FromStream(ms);
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                SaveJPGWithCompressionSetting(bitmap, szFileName, 50);
                ms.Dispose();
                bitmap.Dispose();
            }

        }

	}
}
