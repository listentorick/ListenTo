using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Shared.DTO
{
    public class ActSummary : IDTO
    {

        #region Class Level Private Variables

        private Guid _id; //Since we cant guarantee that the artist will exist in the system, artistID cannot be a primary Key
        private Guid? _artistID;
        private string _name; 
        private string _artistProfileAddress;

        #endregion

        public Guid ID
        {
            get { return this._id; }
            set { this._id = value; }
        }
        public Guid? ArtistID
        {
            get { return this._artistID; }
            set { this._artistID = value; }
        }

        public string ArtistProfileAddress 
        {
            get { return this._artistProfileAddress; }
            set { this._artistProfileAddress = value; }
        }

        public string Name
        {
            get { return this._name; }
            set { this._name = value; }
        }

    }
}
