using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Shared.DO
{
    public class Tag : IDTO, IDeleteableDO, ISuspendableDO
    {

        #region Properties

        private Guid _id;
        private string _name;
        private Guid _ownerID;
        private DateTime _created = DateTime.Now;
        private bool _isDeleted;
        private bool _isSuspended;

        #endregion

        #region Accessors

        public Guid ID
        {
            get { return _id; }
            set { _id = value; }
        }

        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }

        public Guid OwnerID
        {
            get { return _ownerID; }
            set { _ownerID = value; }
        }

        public DateTime Created
        {
            get { return _created; }
            set { _created = value; }
        }

        #endregion

        #region IDeleteableDO Members

        public bool IsDeleted
        {
            get
            {
                return this._isDeleted;
            }
            set
            {
                this._isDeleted = value;
            }
        }

        #endregion

        #region ISuspendableDO Members

        public bool IsSuspended
        {
            get
            {
                return this._isSuspended;
            }
            set
            {
                this._isSuspended = value;
            }
        }

        #endregion
    }
}
