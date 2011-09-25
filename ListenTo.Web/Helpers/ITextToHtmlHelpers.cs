using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Web.Helpers
{
    public interface ITextToHtmlHelpers
    {
        string TextToHtml(string text);

        string WordBreak(string text);
    }
}
