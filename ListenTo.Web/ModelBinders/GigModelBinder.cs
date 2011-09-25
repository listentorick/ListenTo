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
using ListenTo.Web.Helpers;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Web.ModelBinders
{

    public class GigBinderAttribute : CustomModelBinderAttribute
    {
        public override IModelBinder GetBinder()
        {
            return ListenTo.Web.Helpers.IOCHelper.GetGigModelBinder();
        }
    }

    public class GigModelBinder : IModelBinder
    {
        public IVenueManager VenueManager { get; set; }
        public IArtistManager ArtistManager { get; set; }
        public IModelBinderHelpers ModelBinderHelpers { get; set; }
        public ITownManager TownManager { get; set; }
        #region IModelBinder Members

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            HttpRequestBase request = controllerContext.HttpContext.Request;

            Gig gig = null;
            if (bindingContext.Model == null)
            {
                gig = new Gig();
                gig.ID = Guid.NewGuid();
            }
            else
            {
                gig = (Gig)bindingContext.Model;
            }


            gig.Name = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "Name");
            gig.Description = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "Description");

            int day = ModelBinderHelpers.GetValueAndUpdateModelState<int>(bindingContext, "day");
            int month = ModelBinderHelpers.GetValueAndUpdateModelState<int>(bindingContext, "month");
            int year = ModelBinderHelpers.GetValueAndUpdateModelState<int>(bindingContext, "year");
            int hour = ModelBinderHelpers.GetValueAndUpdateModelState<int>(bindingContext, "hour"); ;
            int minute = ModelBinderHelpers.GetValueAndUpdateModelState<int>(bindingContext, "minute");

            if (ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "amPm") == "pm")
            {
                hour = hour + 12;
            }

            DateTime startDateTime = new DateTime(year, month, day,hour,minute,0);
            gig.Created = DateTime.Now;
            gig.StartDate = startDateTime;

            Guid? venueId = ModelBinderHelpers.GetValueAndUpdateModelState<Guid?>(bindingContext, "SelectedVenue");
            
            Venue venue = null;
            string venueName = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "VenueName");

            if (venueId.HasValue && venueId.Value != Guid.Empty && venueName != string.Empty)
            {
                //The use has filled in both the venueName and selected a venue DOH!
                //Show an error message
                bindingContext.ModelState.AddModelBinderValidationError("SelectedVenue", ModelBinderValidationStateKeys.CANNOT_SPECIFY_VENUE_ID_AND_VENUE_NAME);
        
            }
            else if (venueId.HasValue && venueId.Value!=Guid.Empty)
            {
                venue = VenueManager.GetByID(venueId.Value);
                gig.Venue = venue;
            }
            else if (venueName!=string.Empty)
            {
                venue = new Venue();
                venue.ID = Guid.NewGuid();
                venue.Name = venueName;
                //Set to Manchester by default.
                //This will have to change before we open up to different cities
                venue.Town = TownManager.GetByID(new Guid("0D5A3A81-53C1-48B0-B176-A419ACBB2EE8"));
                gig.Venue = venue;
                
            }

            //Artist Ids
            string[] bandNames = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "ActNames").Split(new char[] { ',' });
            string[] bandIds = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "ArtistIds").Split(new char[] { ';' });

            gig.Acts = new List<Act>();
            Guid currentID;
            Artist currentArtist;
            bool exists = false;

            //Add the Artists that were explicitly selected to the acts collection
            foreach(string id in bandIds){

                if (ListenTo.Shared.Utility.Is.GUID(id))
                {
                    currentID = new Guid(id);

                    exists = ((List < Act > )gig.Acts).Exists(delegate(Act a)
                    {
                        return a.Artist.ID == currentID;
                    });
                    
                    if(!exists) {
                        currentArtist = ArtistManager.GetByID(currentID);
                        
                        //Ensure that the bandNames and bandIds are synchronised....
                        if (bandNames.Contains<string>(currentArtist.Name))
                        {
                            AddActToGig(gig, currentArtist,null);
                        }
                    }
                }
            }

            //Add the unknown bands to the acts collection
            foreach (string bandName in bandNames)
            {

                if (bandName!= null && bandName != string.Empty && bandName.Trim().Length!=0)
                {
                    exists = ((List<Act>)gig.Acts).Exists(delegate(Act a)
                    {
                        return a.Name == bandName;
                    });

                    if (!exists)
                    {
                        AddActToGig(gig, null, bandName);
                    }
                }
            }

            string ticketPrice = ModelBinderHelpers.GetValueAndUpdateModelState<string>(bindingContext, "ticketPrice");
            gig.TicketPrice = ticketPrice;

            OwnershipHelpers.SetOwner((IOwnableDO)gig, controllerContext.HttpContext.User);

            return gig;
        }

        private void AddActToGig(Gig gig, Artist artist, string name)
        {
            Act currentAct = new Act();
            currentAct.ID = Guid.NewGuid();
            currentAct.GigId = gig.ID;
            if (artist!=null)
            {
                currentAct.Name = artist.Name;
                currentAct.Artist = artist;
            }
            else
            {
                currentAct.Name = name;
            }
           
            gig.Acts.Add(currentAct);
        }

        public DateTime GetISO8601Date(string date)
        {
            return DateTime.ParseExact(date, "yyyy-MM-ddTHH:mm:ssZ", System.Threading.Thread.CurrentThread.CurrentCulture);
         
        }

        public DateTime ConstructStartDateTime(string dateValue, string timeValue)
        {
            //These strings should be in ISO8601 format
            DateTime date = GetISO8601Date(dateValue);
            DateTime time = GetISO8601Date(timeValue);

            int year = date.Year;
            int month = date.Month;
            int day = date.Day;
            int hour = time.Hour;
            int minute = time.Minute;

            return new DateTime(year, month, day, hour, minute, 0);
        }
        #endregion

 
    }
}