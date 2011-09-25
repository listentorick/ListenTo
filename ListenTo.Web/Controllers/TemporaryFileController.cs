using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using ListenTo.Shared.Interfaces.Helpers;
using ListenTo.Shared.Interfaces.Do;
using ListenTo.Web.Models;

namespace ListenTo.Web.Controllers
{
    public class TemporaryFileController : ListenToController
    {
        ITemporaryFileStrategy TemporaryFileStrategy {get;set;}
        public BinaryDataResult FetchTemporaryFileData(Guid Id)
        {
            IHasBinaryData binaryData = new UploadFilePartialViewModel();
            binaryData.ID = Id;
            binaryData = TemporaryFileStrategy.Fetch(binaryData);
            return BinaryDataResult(binaryData.Data);
        }

        public BinaryDataResult BinaryDataResult(byte[] data)
        {
            BinaryDataResult result = new BinaryDataResult { Data = data };
            return result;
        }
    }
}
