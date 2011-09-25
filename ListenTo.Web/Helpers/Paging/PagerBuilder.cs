using System;
using System.Web.Routing;
using System.Web.Mvc;
using System.Text;
using System.Collections.Generic;
using ListenTo.Shared.Utility;

namespace ListenTo.Web.Helpers.Paging
{

    internal class PagerBuilder
    {
        private HtmlHelper _helper;
        private string _actionName;
        private string _controllerName;
        private int _totalPageCount;
        private int _pageIndex;
        private PagerOptions _options;
        private object _values;
    
        private int _startPageIndex;
        private int _endPageIndex;
  

        internal PagerBuilder(HtmlHelper helper, string actionName, string controllerName, int totalPageCount, int pageIndex, PagerOptions options, object values)
        {
            // Set defaults
            if (String.IsNullOrEmpty(actionName))
                actionName = (string)helper.ViewContext.RouteData.Values["action"];
            if (String.IsNullOrEmpty(controllerName))
                controllerName = (string)helper.ViewContext.RouteData.Values["controller"];
            if (options == null)
                options = new PagerOptions();



            // Assign to fields
            _helper = helper;
            _actionName = actionName;
            _controllerName = controllerName;
            _totalPageCount = totalPageCount;
            _pageIndex = pageIndex;
            _options = options;
            _values = values;

            // Calculate start page index
            _startPageIndex = pageIndex - (options.MaximumPageNumbers / 2);
            if (_startPageIndex + options.MaximumPageNumbers > _totalPageCount)
                _startPageIndex = _totalPageCount - options.MaximumPageNumbers;
            if (_startPageIndex < 0)
                _startPageIndex = 0;

            // Calculate end page index
            _endPageIndex = _startPageIndex + _options.MaximumPageNumbers;
            if (_endPageIndex > _totalPageCount)
                _endPageIndex = _totalPageCount;

        }


        internal IList<PagerItem> ToList()
        {
            var results = new List<PagerItem>();

            // Add previous link
            if (_options.ShowPrevious)
                AddPrevious(results);

            if (_options.ShowNumbers)
            {
                // Add range ellipsis
                AddPreRange(results);

                // Add page numbers
                AddPageNumbers(results);

                // Add range ellipsis
                AddPostRange(results);
            }

            // Add next link
            if (_options.ShowNext)
                AddNext(results);

            return results;
        }


        private void AddPrevious(List<PagerItem> results)
        {
            if (_pageIndex > 0)
            {
                var text = _options.PreviousText;
                var url = GenerateUrl(_pageIndex - 1);
                var item = new PagerItem(text, url, false);
                results.Add(item);
            }
        }


        private void AddPreRange(List<PagerItem> results)
        {
            if (_startPageIndex > 0)
            {
                var text = "...";
                var index = _startPageIndex - _options.MaximumPageNumbers;
                if (index < 0) index = 0;
                var url = GenerateUrl(index);
                var item = new PagerItem(text, url, false);
                results.Add(item);
            }
        }

        private void AddPageNumbers(List<PagerItem> results)
        {
            for (var pageIndex = _startPageIndex; pageIndex < _endPageIndex; pageIndex++)
            {
                var text = (pageIndex + 1).ToString();
                var url = GenerateUrl(pageIndex);
                var isSelected = pageIndex == _pageIndex;
                if (isSelected)
                    text = String.Format(_options.SelectedPageNumberFormatString, text);
                else
                    text = String.Format(_options.PageNumberFormatString, text);
                var item = new PagerItem(text, url, isSelected);
                results.Add(item);
            }
        }

        private void AddPostRange(List<PagerItem> results)
        {
            if (_endPageIndex < _totalPageCount)
            {
                var text = "...";
                var index = _startPageIndex + _options.MaximumPageNumbers;
                if (index > _totalPageCount) index = _totalPageCount;
                var url = GenerateUrl(index);
                var item = new PagerItem(text, url, false);
                results.Add(item);
            }
        }

        private void AddNext(List<PagerItem> results)
        {
            if (_pageIndex < (_totalPageCount-1))
            {
                var text = _options.NextText;
                var url = GenerateUrl(_pageIndex + 1);
                var item = new PagerItem(text, url, false);
                results.Add(item);
            }
        }

        private string GenerateUrl(int pageIndex)
        {
            string url = string.Empty;
            var pageLinkValueDictionary = new RouteValueDictionary(_helper.ViewContext.RouteData.Values);
            pageLinkValueDictionary.Add("page", pageIndex);
            var virtualPathData = RouteTable.Routes.GetVirtualPath(_helper.ViewContext.RequestContext, pageLinkValueDictionary);
            return virtualPathData.VirtualPath;
        }

        internal string RenderList()
        {
            var results = this.ToList();
            var sb = new StringBuilder();

            sb.AppendLine("<div class='pager'><dl><dt>Page:</dt>");
            foreach (PagerItem item in results)
            {
                if (item.IsSelected)
                    sb.AppendFormat("<dd class='currentPage'>{0}</dd>", item.Text);
                else
                    sb.AppendFormat("<dd>{0}</dd>", GenerateLink(item));
            }
            sb.AppendLine("</dl></div>");
 
            return sb.ToString();
        }

        private string GenerateLink(PagerItem item)
        {
            return String.Format("<a href='{0}'>{1}</a>", item.Url, _helper.Encode(item.Text));
        }
    }
}