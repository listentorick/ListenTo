using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Web.ModelBinders;
using System.Globalization;
using ListenTo.Web.Security;
using ListenTo.Web.Models;
using ListenTo.Web.Helpers;
using ListenTo.Shared.Validation;
using ListenTo.Web.Helpers.HtmlHelperExtensions;

namespace ListenTo.Web.Controllers
{
    public class GigController : ListenToController
    {

        public ActionResult Index(Guid gigId)
        {
            Gig gig = GigManager.GetByID(gigId);


            if (gig.IsDeleted == true)
            {
                throw new Exception("Cannot view deleted gig");
            }

            return View(gig);
        }

        public ActionResult List(int? year, int? month, int? day, int? page)
        {
            if (page == null)
            {
                page = 0;
            }

            DateTime expectedDate;
            List<Gig> gigs = new List<Gig>();

            // If date info is not passed, assume that we are listing
            // gigs from this day forth
            if( year == null && month == null && day == null){
                expectedDate = DateTime.Now.Date;
            } else {
                if ( year != null && month == null && day == null) {
                    month = 1; //If just a year is provided 
                    day = 1;
                } else if ( year != null && month != null && day == null) {
                    day = 1; // If a year and a month is provided 
                }
                expectedDate = new DateTime((int)year, (int)month, (int)day);
            }

            return View(GigManager.GetGigsBySiteAfterDate(10, page.Value, this.GetSite().ID, expectedDate));
        }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Add()
        {
            PrepareViewDataForAddAction();
            return View();
        }


        [Authorize]
        [ValidateInput(false)]
        [AcceptVerbs("POST")]
        public ActionResult Add([GigBinderAttribute]Gig gig, FormCollection formCollection)
        {
            IListenToUser user = (IListenToUser)this.HttpContext.User;

            try
            {
                GigManager.Save(gig, user.UserCredentials);
            }
            catch (ValidationException e)
            {
                e.AddToModelState(ViewData.ModelState);

                PrepareViewDataForEditAction(gig);
                PrepareBandViewDataForAddAndEditActions(gig);
                return View(gig);
            }

            return RedirectToGig(gig);
        }


        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Edit(Guid id)
        {
            Gig gig = GigManager.GetByID(id);
            PrepareViewDataForEditAction(gig);
            return View(gig);

        }

        [Authorize]
        [ValidateInput(false)]
        [AcceptVerbs("POST")]
        public ActionResult Edit(Guid id, FormCollection formCollection)
        {
            IListenToUser user = (IListenToUser)this.HttpContext.User;
            Gig gig = GigManager.GetByID(id);

            try
            {
                UpdateModel<Gig>(gig);
                GigManager.Save(gig, user.UserCredentials);
            }
            catch (ValidationException e)
            {
                e.AddToModelState(ViewData.ModelState);
                PrepareViewDataForEditAction(gig);
                return View(gig);    
            }

            return RedirectToGig(gig);
        }


        private void PrepareBandViewDataForAddAndEditActions(Gig gig)
        {
            string bandNames = "";
            string bandIds = "";
            foreach (Act act in gig.Acts)
            {
                bandNames += act.Name.Trim() + ", ";
                if (act.Artist != null)
                {
                    bandIds += act.Artist.ID + ";";
                }
            }

            ViewData["ActNames"] = bandNames;
            ViewData["ArtistIds"] = bandIds;
        }

        private void PrepareViewDataForAddAction()
        {
            //Creates the data for the drop downs
            ViewData["days"] = SelectListHelper.CreateDays(1, 31, 1, DateTime.Now.Day);
            ViewData["months"] = SelectListHelper.CreateMonths(1, 12, 1, DateTime.Now.Month);
            ViewData["years"] = SelectListHelper.CreateYears(DateTime.Now.Year, DateTime.Now.Year + 10, 1, DateTime.Now.Year);
            ViewData["hours"] = SelectListHelper.CreateHours(1,12,1, 7);
            ViewData["minutes"] = SelectListHelper.CreateMinutes(0, 55, 5, 0);
            ViewData["amPm"] = SelectListHelper.CreateAmPm(true);
            PrepareVenues(null);

        }

        private void PrepareViewDataForEditAction(Gig gig)
        {
            SelectList days = SelectListHelper.CreateDays(1, 31, 1, gig.StartDate.Day);
            ViewData["days"] = days;

            SelectList months = SelectListHelper.CreateMonths(1, 12, 1, gig.StartDate.Month);
            ViewData["months"] = months;

            int minYear = DateTime.Now.Year - 50;
            if (gig.StartDate.Year < minYear) { minYear = gig.StartDate.Year; }

            SelectList years = SelectListHelper.CreateYears(minYear, DateTime.Now.Year + 10, 1, gig.StartDate.Year);
            ViewData["years"] = years;

            int hour = gig.StartDate.Hour;
            bool isPm = false;
            if (hour > 12)
            {
                hour = 12;
                isPm = true;
            }

            SelectList hours = SelectListHelper.CreateHours(1, 12, 1, hour);
            ViewData["hours"] = hours;

            int minute = (int)Math.Round(gig.StartDate.Minute / 5.0) * 5;

            SelectList minutes = SelectListHelper.CreateHours(0, 55, 5, minute);
            ViewData["minutes"] = minutes;

            SelectList amPm = SelectListHelper.CreateAmPm(isPm);
            ViewData["amPm"] = amPm;

            PrepareBandViewDataForAddAndEditActions(gig);
            
            Guid? venueId = null;
            if (gig.Venue != null)
            {
                venueId = gig.Venue.ID;
            }

            PrepareVenues(venueId);

        }

    }
}
