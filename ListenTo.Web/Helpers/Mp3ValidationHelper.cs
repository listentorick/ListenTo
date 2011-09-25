using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ListenTo.Web.Helpers
{
    public class Mp3ValidationHelper : IFileValidationHelper
    {
        #region IFileValidationHelper Members

        public bool IsValidFileType(byte[] data)
        {
            return ListenTo.Shared.Helpers.TrackHelpers.ContainsMP3Data(data);
        }

        #endregion
    }
}
