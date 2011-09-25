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

namespace ListenTo.Web.ModelBinders
{

    public class UserProfileBinderAttribute : CustomModelBinderAttribute
    {
        public override IModelBinder GetBinder()
        {
            return ListenTo.Web.Helpers.IOCHelper.GetUserProfileModelBinder();
        }
    }

    public class UserProfileModelBinder : IModelBinder
    {
        public IStyleManager StyleManager { get; set; }
        public ITownManager TownManager { get; set; }
        public IImageManager ImageManager { get; set; }

        public IModelBinderHelpers ModelBinderHelpers
        {
            get;
            set;
        }

        #region IModelBinder Members


        /// <summary>
        /// This JUST binds the data to the UserProfile model. 
        /// The only valdation it performs is specific to the interface and not the model
        /// </summary>
        /// <param name="bindingContext"></param>
        /// <returns></returns>
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            string prefix = string.Empty;
            if (bindingContext.FallbackToEmptyPrefix == false)
            {
                prefix = bindingContext.ModelName + ".";
            }

            UserProfile userProfile = null;
            if (bindingContext.Model == null)
            {
                userProfile = new UserProfile();
                userProfile.ID = Guid.NewGuid();
            }
            else
            {
                userProfile = (UserProfile)bindingContext.Model;
            }

            userProfile.Forename = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Forename");
            userProfile.Surname = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Surname");
            userProfile.Profile = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Profile");
        
            ////Grab the style
            string[] styles = ModelBinderHelpers.GetValueAndUpdateModelState<string[]>(bindingContext, "Styles");

            userProfile.Styles = new List<ListenTo.Shared.DO.Style>();

            if (styles != null)
            {
                foreach (string styleId in styles)
                {
                    if (FormatHelpers.IsGuid(styleId))
                    {
                        ListenTo.Shared.DO.Style style = StyleManager.GetByID(new Guid(styleId));
                        userProfile.Styles.Add(style);
                    }
                }
            }

            return userProfile;
        }

        #endregion
    }
}