using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Utility;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface IImageManager: IManager<Image>
    {
        void HandleUploadedImage(ListenTo.Shared.DO.Image image, UserCredentials userCredentials);
        ListenTo.Shared.DO.Image HandleUploadedImage(byte[] data, UserCredentials userCredentials);
        ListenTo.Shared.DO.ImageMetaData GetImageMetaData(Guid id);
        IPageOfList<ImageMetaData> GetLatestImageMetaData(int pageSize, int currentPageIndex);
    }
}
