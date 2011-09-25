using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Spring.Objects.Factory;
using ListenTo.Web.Helpers.HtmlHelperExtensions;

namespace ListenTo.Web.Helpers
{
    /// <summary>
    /// This processor allows us to inject into a static class!
    /// </summary>
    public class TextHelperProcessor : IInitializingObject
    {
        public ITextToHtmlHelpers TextToHtmlHelpers { get; set; }

        #region IInitializingObject Members

        public void AfterPropertiesSet()
        {
            TextHelper.SetTextToHtmlHelpers(this.TextToHtmlHelpers);
        }

        #endregion
    }
}
