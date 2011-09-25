using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Web.Helpers;
using ListenTo.Web.ModelBinders;
using ListenTo.Web.Security;
using ListenTo.Shared.DTO;
using ListenTo.Shared.Validation;
using System.IO;
using ListenTo.Web.Models;
using ListenTo.Web.Constants;
using ListenTo.Web.Helpers.HtmlHelperExtensions;
using ListenTo.Shared.Helpers;

namespace ListenTo.Web.Controllers
{
    public class TrackController : ListenToController
    {
        public ITrackManager TrackManager { get; set; }
        public ICommentManager CommentManager { get; set; }

        public ActionResult List(string style, int? page)
        {
            if (page == null)
            {
                page = 0;
            }

            ListenTo.Shared.DO.Site site = this.GetSite(); 

            TrackListViewModel trackListViewModel = new TrackListViewModel();

            IList<StyleSummary> styleSummaries = StyleManager.GetStyleSummaries(this.GetSite().ID);
            TagCloudViewModel tagCloudViewModel = new TagCloudViewModel();
            tagCloudViewModel.Tags = new List<TagViewModel>();
            
            foreach (StyleSummary styleSummary in styleSummaries)
            {
                TagViewModel tagViewModel = new TagViewModel();
                tagViewModel.Count = styleSummary.NumberOfTracks;
                tagViewModel.Tag = styleSummary.Name;
                tagViewModel.URL = RouteHelpers.TrackListingsUrl(styleSummary.Name);
                tagCloudViewModel.Tags.Add(tagViewModel);
            }
            tagCloudViewModel.Max = tagCloudViewModel.Tags.Max(t => t.Count);
            trackListViewModel.StyleTagCloudViewModel = tagCloudViewModel;
         
            if (style != null & style != string.Empty)
            {
                Style styleObj = StyleManager.GetStyleWithName(style);
                trackListViewModel.StyleFilter = styleObj;
                if (styleObj != null)
                {
                    trackListViewModel.Tracks = TrackManager.GetTrackSummariesBySiteAndStyle(20, page.Value, this.GetSite().ID, styleObj.ID);
                }
                else
                {
                    throw new Exception("Style does not exist");
                }
            }
            else
            {
                trackListViewModel.Tracks = TrackManager.GetTrackSummaries(20, page.Value, site.ID);

            }
            return View(trackListViewModel);
        }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Add()
        {
            AddTrackViewModel addTrackViewModel = new AddTrackViewModel();
            addTrackViewModel.File = new UploadFilePartialViewModel();
            PrepareViewDataForAddAction(addTrackViewModel);
            return View(addTrackViewModel);
        }

        [Authorize]
        [ValidateInput(false)]
        [AcceptVerbs("POST")]
        public ActionResult Add([Bind(Prefix = "Track")]Track track, UploadFilePartialViewModel file)
        {
            AddTrackViewModel addTrackViewModel = new AddTrackViewModel();
            addTrackViewModel.File = file;
            addTrackViewModel.Track = track;
            //We know that since this track is being added, it CANT have any persisted data!
            addTrackViewModel.HasPersistedTrackData = false;
            return ManageTrack(addTrackViewModel);
        }


        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Edit(Guid id)
        {
            AddTrackViewModel addTrackViewModel = new AddTrackViewModel();
            addTrackViewModel.Track = TrackManager.GetByID(id);
            addTrackViewModel.File = new UploadFilePartialViewModel();
            //We know that since, in order to edit a track, it must be persisted we can say..
            addTrackViewModel.HasPersistedTrackData = true;
            PrepareViewDataForEditAction(addTrackViewModel);
            return View(addTrackViewModel);
        }

        [Authorize]
        [ValidateInput(false)]
        [AcceptVerbs("POST")]
        public ActionResult Edit(Guid id, FormCollection formCollection)
        {
            AddTrackViewModel addTrackViewModel = new AddTrackViewModel();
            
            Track track = TrackManager.GetByID(id);
            UpdateModel<Track>(track,"Track");
            
            addTrackViewModel.Track = track;

            //This object represents a file the user has uploaded...
            UploadFilePartialViewModel file = new UploadFilePartialViewModel();
            UpdateModel<UploadFilePartialViewModel>(file);

            addTrackViewModel.File = file;

            return ManageTrack(addTrackViewModel);
        }

        private ActionResult ManageTrack(AddTrackViewModel addTrackViewModel)
        {
            IListenToUser user = (IListenToUser)this.HttpContext.User;
            UploadFilePartialViewModel file = addTrackViewModel.File;
            Track track = addTrackViewModel.Track;

            try
            {
                file = (UploadFilePartialViewModel)HandleTemporaryFile(file, new Mp3ValidationHelper());
                if (file.Data!=null && file.Data.Count() > 0) { addTrackViewModel.HasValidTemporaryFile = true; }
            }
            catch (InvalidFileTypeException e)
            {
                LOG.Info("Attempt to upload invalid file for track");
                addTrackViewModel.HasValidTemporaryFile = false;
            }

            //Pass the data anyway so that we can give the manager the oportunity to validate too.
            track.Data = file.Data;

            try
            {
                TrackManager.Save(track, user.UserCredentials);
            }
            catch (ValidationException e)
            {
                e.AddToModelState(ViewData.ModelState, "Track");
            }

            if (!ViewData.ModelState.IsValid)
            {
                //If a file hasnt been uploaded, we still need a File object...
                //This is required for the FileUploader partialView
                if (addTrackViewModel.File == null || addTrackViewModel.HasValidTemporaryFile==false)
                {
                    addTrackViewModel.File = new UploadFilePartialViewModel();
                }     

                PrepareViewDataForEditAction(addTrackViewModel);
                return View(addTrackViewModel);
            }

            return RedirectToTrack(addTrackViewModel.Track); 
        }

        public JsonResult MetaData(Guid id)
        {
            TrackMetaData trackMetaData = TrackManager.GetTrackMetaData(id);
            return Json(trackMetaData);
        }

        public MP3Result Listen(string id)
        {
            id = id.ToUpper().Replace(".MP3", "");
            
            if (!FormatHelpers.IsGuid(id))
            {
                throw new InvalidTrackException();
            }

            Guid idAsGuid = new Guid(id);
            Track track = TrackManager.GetByID(idAsGuid);

            if (track == null)
            {
                throw new InvalidTrackException();
            }

            return MP3Result(track.Data);
        }

        /// <summary>
        /// Attaches additional data to the model required for rendering the form
        /// </summary>
        /// <param name="addTrackViewModel"></param>
        /// <returns></returns>
        private AddTrackViewModel PrepareViewDataForAddAction(AddTrackViewModel addTrackViewModel)
        {
            addTrackViewModel = PrepareOwnedArtists(addTrackViewModel, ((IListenToUser)this.HttpContext.User).UserId, null);
            PrepareStyles(null);
            return addTrackViewModel;
        }

        /// <summary>
        /// Attaches additional data to the model required for rendering the form
        /// </summary>
        /// <param name="addTrackViewModel"></param>
        /// <returns></returns>
        private AddTrackViewModel PrepareViewDataForEditAction(AddTrackViewModel addTrackViewModel)
        {
            Guid? artistId = null;
            if (addTrackViewModel.Track.Artist!=null)
            {
                artistId = addTrackViewModel.Track.Artist.ID;
            }

            addTrackViewModel = PrepareOwnedArtists(addTrackViewModel, ((IListenToUser)this.HttpContext.User).UserId, artistId);
          
            Guid? styleId = null;
            if (addTrackViewModel.Track.Style != null)
            {
                styleId = addTrackViewModel.Track.Style.ID;
            }
            PrepareStyles(styleId);

            return addTrackViewModel;
        }

        protected AddTrackViewModel PrepareOwnedArtists(AddTrackViewModel addTrackViewModel, Guid ownerId, Guid? selectedArtist)
        {
            IList<Artist> artists = ArtistManager.GetArtistsByOwner(100,0,ownerId);
            bool userHasArtists = artists.Count > 0;
            addTrackViewModel.OwnedArtists =  SelectListHelper.CreateSelectList<ListenTo.Shared.DO.Artist>(artists, selectedArtist);
            addTrackViewModel.UserHasArtists = userHasArtists;
            return addTrackViewModel;
        }



    }
}
