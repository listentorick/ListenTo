using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using ListenTo.Web.Models;
using ListenTo.Shared.DTO;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Utility;

namespace ListenTo.Web.Controllers
{
    public class RadioController : ListenToController
    {
        public ITrackManager TrackManager { get; set; }

        public ActionResult Index(List<Guid> styles)
        {
            RadioViewModel radioViewModel = new RadioViewModel();

            IList<StyleSummary> selectableStyles = StyleManager.GetStyleSummaries(this.GetSite().ID);
            radioViewModel.Styles = selectableStyles;
            radioViewModel.StylesToSelect = new List<StyleSummary>();
            
            if (styles != null && styles.Count > 0)
            {
                //get the style summaries that have an id contained in styles 
                foreach (Guid styleId in styles)
                {
                    foreach (StyleSummary styleSummary in selectableStyles)
                    {
                        if (styleSummary.ID == styleId)
                        {
                            radioViewModel.StylesToSelect.Add(styleSummary);
                        }
                    }
                }
            }
            
            //If we still dont have any selected styles, select the style with the most tracks
            if(radioViewModel.StylesToSelect.Count==0) 
            {
                StyleSummary styleWithMostTracks = selectableStyles.OrderByDescending(s => s.NumberOfTracks).First();
                radioViewModel.StylesToSelect.Add(styleWithMostTracks);
            }

            return View(radioViewModel);
        }

        public JsonResult Playlist( List<Guid> styles, List<Guid> artists)
        {
            IList<TrackSummary> data = TrackManager.GetNRandomlyOrderedTrackSummariesBySiteAndStylesAndArtists(10, this.GetSite().ID, styles, artists);
            return Json(data);
        }

    }
}
