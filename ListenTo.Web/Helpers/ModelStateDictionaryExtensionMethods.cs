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

namespace ListenTo.Web.Helpers
{

    public static class ModelStateDictionaryExtensionMethods
    {
        public static void AddModelBinderValidationError(this ModelStateDictionary modelStateDictionary, string key, string resourceKey)
        {
            string resourceText = string.Empty;

            object res = HttpContext.GetGlobalResourceObject("ModelBinderValidationStateKeys", resourceKey);
            if (res != null)
            {
                resourceText = (string)res;
                modelStateDictionary.AddModelError(key, resourceText);
            }
        }
    }
}
