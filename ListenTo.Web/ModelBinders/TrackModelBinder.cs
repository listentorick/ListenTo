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
using ListenTo.Shared.Interfaces.Helpers;

namespace ListenTo.Web.ModelBinders
{

    public class TrackBinderAttribute : CustomModelBinderAttribute
    {
        public override IModelBinder GetBinder()
        {
            return ListenTo.Web.Helpers.IOCHelper.GetTrackModelBinder();
        }
    }

    public class TrackModelBinder : IModelBinder
    {
        public IArtistManager ArtistManager { get; set; }
        public IStyleManager StyleManager { get; set; }
        public ITrackManager TrackManager { get; set; }
        public ITemporaryFileStrategy TemporaryFileStrategy { get; set; }
        public IModelBinderHelpers ModelBinderHelpers { get; set; }

        #region IModelBinder Members

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            HttpRequestBase request = controllerContext.HttpContext.Request;

            string prefix = ModelBinderHelpers.GetPrefixForCustomModelBinder(bindingContext);

            Track track = null;
            if (bindingContext.Model == null)
            {
                track = new Track();

                string trackId = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "ID");
                if (FormatHelpers.IsGuid(trackId))
                {
                    track.ID = new Guid(trackId);
                }
                else
                {
                    track.ID = Guid.NewGuid();
                }
            }
            else
            {
                track = (Track)bindingContext.Model;
            }


            track.Name = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Name");
            track.Description = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "Description"); 

            //Grab the style
            Guid? styleId = ModelBinderHelpers.GetValueAndUpdateModelState<Guid?>(bindingContext, "SelectedStyle");
            ListenTo.Shared.DO.Style style = null;
            if (styleId.HasValue && styleId.Value != Guid.Empty)
            {
                style = StyleManager.GetByID(styleId.Value);
                track.Style = style;
            }

            //Grab the artist
            string artistId = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, prefix + "OwnedArtist");

            ListenTo.Shared.DO.Artist artist = null;
            if (FormatHelpers.IsGuid(artistId))
            {
                artist = ArtistManager.GetByID(new Guid(artistId));
                track.Artist = artist;
            }

            //The following block of code can be moved into an injectable strategy once we need to use it again....
            //HttpPostedFileBase file = ListenTo.Web.Helpers.FileHelpers.GetFileFromRequest(controllerContext.HttpContext.Request);
            //if (file != null && file.ContentLength>0)
            //{
            //    byte[] content = ListenTo.Web.Helpers.FileHelpers.GetContentFromHttpPostedFile(file);

            //    track.Data = content;
            //    //Create a temporary file
            //    TemporaryFileStrategy.Create(track);
            //}
            //else
            //{
            //    //Do we have a temp file, if so repopulate......
            //    track = (Track)TemporaryFileStrategy.Fetch(track);
            //}

            track.Created = DateTime.Now;

            OwnershipHelpers.SetOwner((IOwnableDO)track, controllerContext.HttpContext.User);

            return track;
        }

        #endregion
    }
}