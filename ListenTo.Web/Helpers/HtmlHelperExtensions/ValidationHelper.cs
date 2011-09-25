using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ListenTo.Web.Helpers.HtmlHelperExtensions
{
    public static class Validation
    {
        public static bool AreKeysInvalid(this HtmlHelper htmlHelper, string[] keys) {

            ModelState modelState;
            bool invalid = false;

            foreach (string key in keys)
            {
                if (htmlHelper.ViewData.ModelState.TryGetValue(key, out modelState))
                {
                    if (modelState.Errors.Count > 0)
                    {
                        invalid = true;
                        break;
                    }
                }
            }

            return invalid;
        }
    }
}
