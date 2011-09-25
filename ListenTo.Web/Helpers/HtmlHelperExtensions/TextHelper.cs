using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Web.Mvc;
using anrControls;
using System.Text;
using System.Text.RegularExpressions;

namespace ListenTo.Web.Helpers.HtmlHelperExtensions
{
    public static class TextHelper
    {

        private static ITextToHtmlHelpers _textToHtmlHelpers;

        public static void SetTextToHtmlHelpers(ITextToHtmlHelpers textToHtmlHelpers)
        {
            _textToHtmlHelpers = textToHtmlHelpers;
        }
        /// <summary>
        /// Converts MarkDown and SmartyPants text into HTML
        /// </summary>
        /// <param name="helper"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        public static string TextToHtml(this HtmlHelper helper, string text)
        {
            text = _textToHtmlHelpers.TextToHtml(text);
            return text;
        }

        public static string Escape(this HtmlHelper helper, string text)
        {
           StringBuilder sb = new StringBuilder(HttpUtility.HtmlEncode(text));
           return sb.ToString();
        }

        public static string WordBreak(this HtmlHelper helper, string text)
        {
            return _textToHtmlHelpers.WordBreak(text);
        }
    }
}
