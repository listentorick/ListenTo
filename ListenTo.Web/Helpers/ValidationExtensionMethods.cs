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
using ListenTo.Shared.Validation;
using System.Web.Mvc;
using System.Collections.Generic;
using System.Web.Resources;

namespace ListenTo.Web.Helpers
{
    public static class ValidationExtensionMethods
    {
        public static ModelStateDictionary AddToModelState(this ValidationException validationException, ModelStateDictionary modelStateDictionary)
        {
            return validationException.AddToModelState(modelStateDictionary, string.Empty);
        }


        public static ModelStateDictionary AddToModelState(this ValidationException validationException, ModelStateDictionary modelStateDictionary, string prefix)
        {
            return AddValidationStateToModelState(validationException.ValidationStateDictionary, modelStateDictionary, prefix);
        }

        public static ModelStateDictionary AddToModelState(this ValidationStateDictionary validationStateDictionary, ModelStateDictionary modelStateDictionary, string prefix)
        {
            return AddValidationStateToModelState(validationStateDictionary, modelStateDictionary, prefix);
        }

        private static ModelStateDictionary AddValidationStateToModelState(ValidationStateDictionary validationStateDictionary, ModelStateDictionary modelStateDictionary, string prefix)
        {

            if (prefix != string.Empty)
            {
                prefix = prefix + ".";
            }
            foreach (KeyValuePair<string, ValidationState> entry in validationStateDictionary)
            {
                object res;
                //string errorMessages;
                foreach (string errorKey in entry.Value.Errors)
                {
                    res = HttpContext.GetGlobalResourceObject("ValidationStateKeys", errorKey);
                    if (res != null)
                    {
                        modelStateDictionary.AddModelError(prefix + entry.Key, (string)res);

                    }
                }
            }

            return modelStateDictionary;
        }

    }
}
