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

namespace ListenTo.Web.ModelBinders
{

    public class UserBinderAttribute : CustomModelBinderAttribute
    {
        public override IModelBinder GetBinder()
        {
            return ListenTo.Web.Helpers.IOCHelper.GetUserModelBinder();
        }
    }

    public class UserModelBinder : IModelBinder
    {
        public MembershipProvider Provider
        {
            get;
            set;
        }

        public IModelBinderHelpers ModelBinderHelpers
        {
            get;
            set;
        }


        #region IModelBinder Members


        /// <summary>
        /// This JUST binds the data to the user model. 
        /// The only valdation it performs is specific to the user interface and not the model
        /// </summary>
        /// <param name="bindingContext"></param>
        /// <returns></returns>
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            HttpRequestBase request = controllerContext.HttpContext.Request;

            User user = null;
            if (bindingContext.Model == null)
            {
                user = new User();
                user.ID = Guid.NewGuid();
            }
            else
            {
                user = (User)bindingContext.Model;
            }

            string username = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "Username");
            user.Username = username;

            string password = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "Password");
            string confirmPassword = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "ConfirmPassword");

            if (password != confirmPassword)
            {
                bindingContext.ModelState.AddModelBinderValidationError("ConfirmPassword", ModelBinderValidationStateKeys.USER_PASSWORDS_DONT_MATCH);
            }

            user.Password = password;

            string emailAddress = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "EmailAddress");
            string confirmEmailAddress = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "ConfirmEmail");


            if (emailAddress != confirmEmailAddress)
            {
                bindingContext.ModelState.AddModelBinderValidationError("ConfirmEmail", ModelBinderValidationStateKeys.USER_EMAILS_DONT_MATCH);
            }

            user.EmailAddress = emailAddress;

            string policy = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "Policy");

            if (policy == null)
            {
                bindingContext.ModelState.AddModelBinderValidationError("Policy", ModelBinderValidationStateKeys.POLICY_NOT_APPROVED);
            }

            return user;
        }

        #endregion




    }
}