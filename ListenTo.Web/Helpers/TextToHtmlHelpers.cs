using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using anrControls;
using System.Text.RegularExpressions;

namespace ListenTo.Web.Helpers
{
    public class TextToHtmlHelpers: ITextToHtmlHelpers
    {
        public string TextToHtml(string text)
        {
            if (text == null)
            {
                text = string.Empty;
            }
            else
            {
                Markdown md = new Markdown();
                SmartyPants sp = new SmartyPants();
                //By html encoding text, any markup contained will not be rendered on the browser as html tags.
                text = HttpUtility.HtmlEncode(text);
                text = ResolveUrlsToHtmlLinks(text);
                text = sp.Transform(md.Transform(text), ConversionMode.EducateDefault);
            }
            return text;
        }

        private Regex linkRegex = new Regex("((http://|www\\.)([A-Z0-9.-:]{1,})\\.[0-9A-Z?;~&#=\\-_\\./]{2,})", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        private string link = "<a href=\"{0}{1}\">{2}</a>"; 

        private string ResolveUrlsToHtmlLinks(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text;

            foreach (Match match in linkRegex.Matches(text))
            {
                if (!match.Value.Contains("://"))
                {
                    text = text.Replace(match.Value, string.Format(link, "http://", match.Value, match.Value));
                }
                else
                {
                    text = text.Replace(match.Value, string.Format(link, string.Empty, match.Value, match.Value));
                }
            }

            return text;
        }

        #region ITextToHtmlHelpers Members


        public string WordBreak(string text)
        {
            // [] define character sets..
            // ^ in the character set  negates the character set
            // \s represents a white space character
            // sp [^\s-] means that we will match anything but space characters or hypens
            // [^\s-]{5} repeats the expression 5 times...
            // brackets group statements together...
     
            //text = Regex.Replace(text,@"/([^\s-]{5})([^\s-]{5})/","$1&shy;$2");
            return text;
        }

        #endregion
    }
}
