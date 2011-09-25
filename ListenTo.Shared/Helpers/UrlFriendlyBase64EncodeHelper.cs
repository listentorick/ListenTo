using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Helpers;

namespace ListenTo.Shared.Helpers
{
    public class UrlFriendlyBase64EncodeHelper : IBase64EncodeHelper
    {
        //Using standard Base64 in URL requires encoding of '+' and '/' characters into special percent-encoded hexadecimal sequences ('+' = '%2B' and '/' = '%2F').
        //However since MVC decodes all incoming urls before it gets to the routing tables we cannot use this url encoding...
        //For this reason, a modified Base64 for URL variant exists, where no padding '=' will be used, and the '+' and '/' characters of standard Base64 are respectively replaced by '-' and '_'
        //See http://en.wikipedia.org/wiki/Base64
        private const string PLUS = "+";
        private const string URL_FRIENDLY_PLUS = "-";
        private const string FORWARDSLASH = "/";
        private const string URL_FRIENDLY_FORWARDSLASH = "_";

        public byte[] FromBase64String(string base64String)
        {
            byte[] data = null;

            if (base64String != null)
            {
                base64String = base64String.Replace(URL_FRIENDLY_PLUS, PLUS)
                                           .Replace(URL_FRIENDLY_FORWARDSLASH, FORWARDSLASH);
                data = Convert.FromBase64String(base64String);
            }

            return data;
        }

        public string ToBase64String(byte[] array)
        {
            string data = Convert.ToBase64String(array);

            if (data != null)
            {
                data = data.Replace(PLUS, URL_FRIENDLY_PLUS).
                            Replace(FORWARDSLASH, URL_FRIENDLY_FORWARDSLASH);
            }

            return data;
        }
    }
}
