using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Helpers
{
    public interface IEncryptionHelper
    {
         string EncryptData(String strKey, String strData);
         string DecryptData(String strKey, String strData);
    }
}
