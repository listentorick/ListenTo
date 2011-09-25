using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces;


namespace ListenTo.Shared.Helpers
{
    public class TinyUrlUrlShortener: IUrlShortener
    {
        #region ITinyUrl Members

        public string ShortenUrl(string url)
        {
            ListenTo.TinyUrl tinyUrl = new ListenTo.TinyUrl();
            return tinyUrl.MakeTinyUrl(url);
        }

        #endregion
    }
}
