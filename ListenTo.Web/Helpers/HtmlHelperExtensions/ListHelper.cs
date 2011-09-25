using System;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Collections.Generic;


namespace ListenTo.Web.Helpers.HtmlHelperExtensions
{

    public static class ListExtensions
    {

        public static string OrderedList<ITEMTYPE>(this HtmlHelper helper, IEnumerable<ITEMTYPE> items)
        {
            return "<ol>" + ListExtensions.GetListItems(items) + "</ol>";
        }

        public static string UnorderedList<ITEMTYPE>(this HtmlHelper helper, IEnumerable<ITEMTYPE> items)
        {
            return "<ul>" + ListExtensions.GetListItems(items) + "</ul>";
        }

        private static string GetListItems<ITEMTYPE>(IEnumerable<ITEMTYPE> items)
        {
            var builder = new StringBuilder();

            foreach (Object item in items)
                builder.AppendFormat("<li>{0}</li>", HttpUtility.HtmlEncode(item.ToString()));
            return builder.ToString();

        }
    }
}