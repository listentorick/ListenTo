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
using ListenTo.Shared.Interfaces.Helpers;
using ListenTo.Shared.Interfaces.Do;


namespace ListenTo.Web.ModelBinders
{
    public class ModelBinderHelpers: IModelBinderHelpers
    {

        #region IModelBinderHelpers Members

        public ITemporaryFileStrategy TemporaryFileStrategy { get; set; }

        public T GetValueAndUpdateModelState<T>(ModelBindingContext bindingContext, string key)
        {
            T result = default(T);

            ValueProviderResult valueResult;
            bindingContext.ValueProvider.TryGetValue(key, out valueResult);
            bindingContext.ModelState.SetModelValue(key, valueResult);
            if(valueResult!=null) {
                result = (T)valueResult.ConvertTo(typeof(T));
            }

            return result;
        }

        public T GetValue<T>(FormCollection formCollection, string key)
        {
            T result = default(T);

            ValueProviderResult valueResult;
            formCollection.ToValueProvider().TryGetValue(key, out valueResult);
            if (valueResult != null)
            {
                result = (T)valueResult.ConvertTo(typeof(T));
            }

            return result;
        }

        /// <summary>
        /// Gets 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        public HttpPostedFileBase GetFile(ModelBindingContext bindingContext, string key)
        {
            HttpPostedFileBase postedFile = this.GetValueAndUpdateModelState<HttpPostedFileBase>(bindingContext, key);
            return postedFile;
        }

        public string GetPrefixForCustomModelBinder(ModelBindingContext bindingContext)
        {
            string prefix = string.Empty;

            if (bindingContext.ModelName != string.Empty)
            {
                prefix = bindingContext.ModelName + ".";
            }

            return prefix;
        }

        #endregion
    }
}
