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

    public class ArtistBinderAttribute : CustomModelBinderAttribute
    {
        public override IModelBinder GetBinder()
        {
            return ListenTo.Web.Helpers.IOCHelper.GetArtistModelBinder();
        }
    }

    public class ArtistModelBinder : IModelBinder
    {
        public IArtistManager ArtistManager { get; set; }
        public IStyleManager StyleManager { get; set; }
        public ITownManager TownManager { get; set; }
        public IImageManager ImageManager { get; set; }

        public IModelBinderHelpers ModelBinderHelpers{get;set; }

        #region IModelBinder Members

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            HttpRequestBase request = controllerContext.HttpContext.Request;

            string prefix = ModelBinderHelpers.GetPrefixForCustomModelBinder(bindingContext);


            Artist artist = null;
            if (bindingContext.Model == null)
            {
                artist = new Artist();
                artist.ID = Guid.NewGuid();
            }
            else
            {
                artist = (Artist)bindingContext.Model;
            }


            artist.Name = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Name");
            artist.Profile = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Profile");

       
            //Grab the style
            Guid? styleId = ModelBinderHelpers.GetValueAndUpdateModelState<Guid?>(bindingContext, "SelectedStyle");
            ListenTo.Shared.DO.Style style = null;
            if (styleId.HasValue && styleId.Value != Guid.Empty)
            {
                style = StyleManager.GetByID(styleId.Value);
                artist.Style = style;
            }

            //Grab the town
            Guid? townId = ModelBinderHelpers.GetValueAndUpdateModelState<Guid?>(bindingContext, "SelectedTown");
            Town town = null;
            if (townId.HasValue && townId.Value!=Guid.Empty)
            {
                town = TownManager.GetByID(townId.Value);
                artist.Town = town;
            }

            int month = ModelBinderHelpers.GetValueAndUpdateModelState<int>(bindingContext, "month");
            int year = ModelBinderHelpers.GetValueAndUpdateModelState<int>(bindingContext, "year");
            DateTime formedDateTime = new DateTime(year, month, 1);

            artist.Created = DateTime.Now;
            artist.Formed = formedDateTime;

            artist.OfficalWebsiteURL = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "OfficalWebsiteURL");
            artist.Email = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Email");
            artist.ProfileAddress = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "ProfileAddress");
           
            OwnershipHelpers.SetOwner((IOwnableDO)artist, controllerContext.HttpContext.User);

            return artist;
        }

        #endregion
    }
}