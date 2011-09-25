using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using ListenTo.Shared.Interfaces.Do;
using System.Web;

namespace ListenTo.Web.ModelBinders
{
    public interface IModelBinderHelpers
    {
         T GetValueAndUpdateModelState<T>(ModelBindingContext bindingContext, string key);
         T GetValue<T>(FormCollection formCollection, string key);
         HttpPostedFileBase GetFile(ModelBindingContext bindingContext, string key);
         string GetPrefixForCustomModelBinder(ModelBindingContext bindingContext);  
    }
}
