using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Shared.DTO
{

    /// <summary>
    /// Represents a gig summary object
    /// </summary>
    public class GigSummary : IDTO
    {

        #region Properties

        private Guid _id;
		private string _name;
        private IKeyValuePair _venue;
		private DateTime _date;
        private IList<ActSummary> _actSummaries;

        #endregion

        #region Accessors 

		public Guid ID
		{
			get
			{
				return _id;
			}
			set
			{
				_id = value;
			}
		}

		public string Name
		{
			get
			{
				return _name;
			}
			set
			{
				_name = value;
			}
		}

        public IKeyValuePair Venue
		{
			get
			{
				return _venue;
			}
			set
			{
				_venue = value;
			}
		}

		
		public DateTime Date
		{
			get
			{
				return _date;
			}
			set
			{
				_date = value;
			}
		}

        public IList<ActSummary> ActSummaries
        {
            get
            {
                return _actSummaries;
            }
            set
            {
                _actSummaries = value;
            }
        }



        #endregion

        #region Constructor

        public GigSummary()
        {
            this.ActSummaries = new List<ActSummary>();
            this.Venue = new KeyValuePair();
        }

        #endregion
    }
}
