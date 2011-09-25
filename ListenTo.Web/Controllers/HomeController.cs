using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Web.Models;
using ListenTo.Web.Helpers;
using ListenTo.Shared.DTO;

namespace ListenTo.Web.Controllers
{
    public class HomeController : ListenToController
    {
        public INewsItemManager NewsItemManager { get; set; }
 
        public ActionResult Index()
        {
            Site site = this.GetSite();

            HomePageViewModel homePageViewModel = new HomePageViewModel();

            homePageViewModel.Gigs = GigManager.GetGigsBySiteAfterDate(5, 0, site.ID, DateTime.Now);
            //TODO: CHANGE TO USE SUMMARYS 
            homePageViewModel.Artists = ArtistManager.GetNRandomArtistSummariesBySite(site.ID, 16);
            homePageViewModel.NumberOfArtists = ArtistManager.GetNumberOfArtistsBySite(site.ID);
            homePageViewModel.NewsItemSummary = NewsItemManager.GetNewsItemSummariesBySite(5, 0, site.ID);

            //Change this to use StyleSummaries instead.... This requires a change to CreateSelectList
            IList<Style> styles = StyleManager.GetStyles();
            SelectList stylesSelectList = SelectListHelper.CreateSelectList<ListenTo.Shared.DO.Style>(styles, null);
            homePageViewModel.StylesSelectList = stylesSelectList;

            return View(homePageViewModel);
        }


    }
}
