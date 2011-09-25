using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Helpers
{
    public interface IBase64EncodeHelper
    {
        byte[] FromBase64String(string base64String);
        string ToBase64String(byte[] array);
    }
}
