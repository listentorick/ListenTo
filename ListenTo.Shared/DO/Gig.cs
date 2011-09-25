using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DO
{
    public class Gig : BaseDO, IDeleteableDO
    {

        #region Accessors

        public Venue Venue
        {
            get;
            set; 
        }

        public System.Nullable<DateTime> EndDate
        {
            get;
            set;
        }

        public DateTime StartDate
        {
            get;
            set;
        }

        public string Name
        {
            get;
            set;
        }

        public string Description
        {
            get;
            set;
        }

        public string TicketPrice
        {
            get;
            set;
        }

        /// <summary>
        /// The Act object does not exist outside the context of the Gig, therefore,
        /// the full act object is loaded here.
        /// </summary>
        public IList<Act> Acts
        {
            get;
            set;
        }

        #endregion

        #region IDeleteableDO Members

        public bool IsDeleted
        {
            get;
            set;
        }

        #endregion
    }
}
