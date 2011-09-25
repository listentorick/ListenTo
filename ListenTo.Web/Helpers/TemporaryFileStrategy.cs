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
using ListenTo.Shared.Interfaces.Do;
using ListenTo.Shared.Interfaces.Helpers;
using System.IO;

namespace ListenTo.Web.Helpers
{
    public class TemporaryFileStrategy : ITemporaryFileStrategy
    {
       public IFileHelpers FileHelpers {get;set;}
       public IRouteHelpers RouteHelpers { get; set; }

        public string ConstructTempFilePath(IHasBinaryData hasBinaryData)
        {
            var absolutePath = System.Configuration.ConfigurationSettings.AppSettings["ApplicationPath"] + System.Configuration.ConfigurationSettings.AppSettings["ApplicationRelativeTempFileDirectoryPath"] + "/" + hasBinaryData.ID + ".temp";
        
            return absolutePath;
        }

        public string ConstructTempFileURL(IHasBinaryData hasBinaryData)
        {
            return RouteHelpers.TemporaryFileUrl(hasBinaryData.ID);
        }
        
        public void Create(IHasBinaryData bd)
        {
            string filePath = this.ConstructTempFilePath(bd);

            //If a file already exists, delete it...
            if (System.IO.File.Exists(filePath))
            {
                System.IO.File.Delete(filePath);
            }

            System.IO.File.WriteAllBytes(filePath, bd.Data);
        }

        public IHasBinaryData Fetch(IHasBinaryData hasBinaryData)
        {
            string path = ConstructTempFilePath(hasBinaryData);
            try
            {
                hasBinaryData = FileHelpers.PopulateFromFile(path, hasBinaryData);
            }
            catch (FileNotFoundException e)
            {
                //There is no file - therefore we consume this exception
            }

            return hasBinaryData;

        }

        #region ITemporaryFileStrategy Members


        public void DeleteTemporaryFile(IHasBinaryData hasBinaryData)
        {
            string filePath = this.ConstructTempFilePath(hasBinaryData);

            //If a file already exists, delete it...
            if (System.IO.File.Exists(filePath))
            {
                System.IO.File.Delete(filePath);
            }
        }

        #endregion
    }
}
