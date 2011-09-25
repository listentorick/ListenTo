using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DO
{
    public class Venue : BaseDO, INamedDO, IDeleteableDO
    {
        #region Properties

        private string _name;
        private string _description;
        private string _url;
        private string _telephone;
        private string _address;
        private Town _town;
        private bool _deleted;

        #endregion

        #region Accessors

        public string Name
        {
            get { return this._name; }
            set { this._name = value; }
        }
        
        public string Description
        {
            get { return this._description; }
            set { this._description = value; }
        }

        public string URL
        {
            get { return this._url; }
            set { this._url = value; }
        }

        public string Telephone
        {
            get { return this._telephone; }
            set { this._telephone = value; }
        }

        public string Address
        {
            get { return this._address; }
            set { this._address = value; }
        }

        public Town Town
        {
            get { return this._town; }
            set { this._town = value; }
        }

        #endregion

        #region IDeleteableDO Members

        public bool IsDeleted
        {
            get
            {
                return this._deleted;
            }
            set
            {
                this._deleted = value;
            }
        }

        #endregion
    }
}
