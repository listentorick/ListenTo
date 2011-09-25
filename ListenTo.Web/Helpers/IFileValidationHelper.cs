using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ListenTo.Web.Helpers
{
    public interface IFileValidationHelper
    {
        /// <summary>
        /// Used by the UploadFilePartialViewModelBinder to determine that the file data is valid for the particular 
        /// upload scenario
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        bool IsValidFileType(byte[] data);
    }
}
