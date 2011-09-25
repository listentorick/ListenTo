using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Do;
using ListenTo.Shared.Interfaces.Helpers;
using System.IO;

namespace ListenTo.Shared.Helpers
{
    public class FileHelpers : IFileHelpers
    {
        public IHasBinaryData PopulateFromFile(string filePath, IHasBinaryData dataObject)
        {
            FileStream fs = null;

            try
            {
                fs = System.IO.File.Open(filePath, FileMode.Open);
                if (fs != null)
                {
                    byte[] bytes = new byte[fs.Length];
                    fs.Read(bytes, 0, bytes.Length);
                    dataObject.Data = bytes;
                }
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                }
            }

            return dataObject;
        }

        /// <summary>
        /// Only checks the headers....
        /// </summary>
        /// <param name="postedFile"></param>
        /// <returns></returns>
        public bool IsFileImage(Byte[] data)
        {
            bool isImageHeader = false;

            if(IsFileJPG(data) || 
                IsFileBMP(data) || 
                IsFileGIF(data) || 
                IsFilePNG(data)){
                    isImageHeader = true;
            }

            return isImageHeader;
        }

        public bool HeaderStartsWith(Byte[] data, string headerStart)
        {
            byte[] header = new byte[4];

            //Grab the first 4 bytes
            for (int i = 0; i < 4; i++)
            {
                header[i] = data[i];
            }
            //Latin-1 aka ISO-8859-1 - the extended ascii character set
            string ascii = Encoding.GetEncoding("ISO-8859-1").GetString(header);

            return ascii.StartsWith(headerStart);

        }

        public bool IsFileJPG(Byte[] data)
        {
            return HeaderStartsWith(data,"\xFF\xD8");
        }

        public bool IsFileGIF(Byte[] data)
        {
            return HeaderStartsWith(data, "GIF");
        }

        public bool IsFileBMP(Byte[] data)
        {
            return HeaderStartsWith(data, "BM");
        }

        public bool IsFilePNG(Byte[] data)
        {
            return HeaderStartsWith(data, Encoding.ASCII.GetString(new byte[] { 137, 80, 78, 71 }));
        }

        public bool IsFileImage(IHasBinaryData dataObject)
        {
            return this.IsFileImage(dataObject.Data);
        }




    }
}
