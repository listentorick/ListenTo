using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Do;

namespace ListenTo.Shared.Interfaces.Helpers
{
    public interface IFileHelpers
    {
        IHasBinaryData PopulateFromFile(string filePath, IHasBinaryData dataObject);
        //bool IsFileImage(IHasBinaryData dataObject);
        bool IsFileJPG(Byte[] data);
        bool IsFileGIF(Byte[] data);
        bool IsFileBMP(Byte[] data);
        bool IsFilePNG(Byte[] data);
        bool IsFileImage(Byte[] data);

    }
}
