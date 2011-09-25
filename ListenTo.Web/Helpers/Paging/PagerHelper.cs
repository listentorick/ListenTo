using System;
using System.Web.Mvc;
using System.Collections.Generic;
using ListenTo.Shared.Utility;

namespace ListenTo.Web.Helpers.Paging
{
    public static class PagerHelper
    {
        public static IList<PagerItem> PagerList<T>(this HtmlHelper helper, IPageOfList<T> pageOfList)
        {
            return PagerList<T>(helper, pageOfList.TotalPageCount, pageOfList.PageIndex, null, null, null, null);
        }

        public static IList<PagerItem> PagerList<T>(this HtmlHelper helper, IPageOfList<T> pageOfList, PagerOptions options)
        {
            return PagerList<T>(helper, pageOfList.TotalPageCount, pageOfList.PageIndex, null, null, options, null);
        }


        public static IList<PagerItem> PagerList<T>(this HtmlHelper helper, int totalPageCount, int pageIndex, string actionName, string controllerName, PagerOptions options, object values)
        {
            var builder = new PagerBuilder
                (
                    helper,
                    actionName,
                    controllerName,
                    totalPageCount,
                    pageIndex,
                    options,
                    values
                );
            return builder.ToList();
        }

        public static string Pager<T>(this HtmlHelper helper, IPageOfList<T> pageOfList)
        {
            return Pager(helper, pageOfList.TotalPageCount, pageOfList.PageIndex, null, null, null, null);
        }

        public static string Pager<T>(this HtmlHelper helper, PageOfList<T> pageOfList, PagerOptions options)
        {
            return Pager(helper, pageOfList.TotalPageCount, pageOfList.PageIndex, null, null, options, null);
        }

        public static string Pager(this HtmlHelper helper, int totalPageCount, int pageIndex, string actionName, string controllerName, PagerOptions options, object values)
        {
            var builder = new PagerBuilder
                (
                    helper, 
                    actionName, 
                    controllerName, 
                    totalPageCount, 
                    pageIndex, 
                    options, 
                    values
                );
            return builder.RenderList();

        }
    }
}