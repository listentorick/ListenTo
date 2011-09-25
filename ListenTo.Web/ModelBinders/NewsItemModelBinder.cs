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
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Managers;
using System.Collections.Generic;
using ListenTo.Shared.Helpers;
using ListenTo.Web.Helpers;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Web.ModelBinders
{

    public class NewsItemBinderAttribute : CustomModelBinderAttribute
    {
        public override IModelBinder GetBinder()
        {
            NewsItemModelBinder newsItemModelBinder = (NewsItemModelBinder)ListenTo.Web.Helpers.IOCHelper.GetNewsItemModelBinder();
            return newsItemModelBinder;
        }

        public string Prefix
        {
            get;
            set;
        }
    }

    public class NewsItemModelBinder : IModelBinder
    {
        public string Prefix
        {
            get;
            set;
        }

        public IImageManager ImageManager { get; set; }

        public IModelBinderHelpers ModelBinderHelpers
        {
            get;
            set;
        }

        #region IModelBinder Members

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            HttpRequestBase request = controllerContext.HttpContext.Request;

            string prefix = ModelBinderHelpers.GetPrefixForCustomModelBinder(bindingContext);
        
            NewsItem newsItem = null;
            if (bindingContext.Model == null)
            {
                newsItem = new NewsItem();
                newsItem.ID = Guid.NewGuid();
            }
            else
            {
                newsItem = (NewsItem)bindingContext.Model;
            }

            newsItem.Name = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Name");
            newsItem.Description = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Description");
            newsItem.Body = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Body");

            newsItem.Created = DateTime.Now;

            OwnershipHelpers.SetOwner((IOwnableDO)newsItem, controllerContext.HttpContext.User);

            return newsItem;
        }

        #endregion
    }
}