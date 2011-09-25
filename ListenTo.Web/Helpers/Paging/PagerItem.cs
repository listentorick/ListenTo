using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Web.Helpers.Paging
{
    public class PagerItem
    {
        public PagerItem(string text, string url, bool isSelected)
        {
            this.Text = text;
            this.Url = url;
            this.IsSelected = isSelected;
        }

        public string Text { get; set; }
        public string Url { get; set; }
        public bool IsSelected { get; set; }
    }
}
