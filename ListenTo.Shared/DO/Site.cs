using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DO
{
    public class Site : BaseDO, IDeleteableDO
    {
        #region Properties

        private string _url;
        private string _name;
        private string _description;
        private IList<Town> _townsRepresented = new List<Town>();
        private bool _deleted;
        
        #endregion

        #region Accessors

        public string URL
        {
            get { return this._url; }
            set { this._url = value; }
        }

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

        public IList<Town> TownsRepresented
        {
            get { return this._townsRepresented; }
            set { this._townsRepresented = value; }
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
