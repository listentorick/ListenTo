using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ListenTo.Web.Helpers
{
    public class ImageFileValidationHelper : IFileValidationHelper
    {
        public bool IsValidFileType(byte[] data)
        {
            return ListenTo.Shared.Helpers.ImageHelpers.IsFileImage(data);
        }
    }
}
