using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Shared.Utility;
using ListenTo.Web.Models;

namespace ListenTo.Web.Controllers
{
    public class VenueController : ListenToController
    {
        public JsonResult FetchLike(string q)
        {
            IList<Venue> venues = VenueManager.GetVenuesWithNameLike( 10, 0, q);
            return Json(venues);
        }

        public ActionResult Index(Guid venueId)
        {
            VenueIndexViewModel venueIndexViewModel = new VenueIndexViewModel();
            venueIndexViewModel.Venue = VenueManager.GetByID(venueId);

            if (venueIndexViewModel.Venue.IsDeleted == true)
            {
                throw new Exception("Cannot view deleted venue");
            }

            venueIndexViewModel.UpcomingGigs = GigManager.GetUpcomingGigsAtVenue(10, 0, venueId);
            venueIndexViewModel.RecentGigs = GigManager.GetMostRecentGigsAtVenue(10, 0, venueId);
            

            return View(venueIndexViewModel);
        }
    }
}
