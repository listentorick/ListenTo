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
using ListenTo.Shared.Enums;

namespace ListenTo.Web.ModelBinders
{

    public class CommentBinderAttribute : CustomModelBinderAttribute
    {
        public override IModelBinder GetBinder()
        {
            return ListenTo.Web.Helpers.IOCHelper.GetCommentModelBinder();
        }
    }

    public class CommentModelBinder : IModelBinder
    {

        public IModelBinderHelpers ModelBinderHelpers { get; set; }

        #region IModelBinder Members

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            HttpRequestBase request = controllerContext.HttpContext.Request;

            Comment comment = null;
            if (bindingContext.Model == null)
            {
                comment = new Comment();
                comment.ID = Guid.NewGuid();
            }
            else
            {
                comment = (Comment)bindingContext.Model;
            }

            comment.Body = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "CommentBody");
            comment.ContentType = ModelBinderHelpers.GetValueAndUpdateModelState<ContentType>(bindingContext, "ContentType");
            comment.TargetId = ModelBinderHelpers.GetValueAndUpdateModelState<Guid>(bindingContext, "TargetId");
          
            OwnershipHelpers.SetOwner((IOwnableDO)comment, controllerContext.HttpContext.User);

            return comment;
        }

        #endregion
    }
}