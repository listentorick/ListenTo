using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Do;

namespace ListenTo.Shared.Interfaces.Helpers
{
    public interface ITemporaryFileStrategy
    {
        string ConstructTempFilePath(IHasBinaryData hasBinaryData);
        string ConstructTempFileURL(IHasBinaryData hasBinaryData);
        void Create(IHasBinaryData bd);
        IHasBinaryData Fetch(IHasBinaryData hasBinaryData);

        void DeleteTemporaryFile(IHasBinaryData hasBinaryData);
    }
}
