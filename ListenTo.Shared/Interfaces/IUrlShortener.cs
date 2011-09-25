using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces
{
    public interface IUrlShortener
    {
        string ShortenUrl(string url);
    }
}
