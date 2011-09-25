using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DO
{
    public class BaseDO: IDO, IOwnableDO
    {
        #region Properties

        private Guid _id;
        private DateTime _created = DateTime.Now;

        #endregion

        #region IDO Members

        public Guid ID
        {
            get
            {
                return this._id;
            }
            set
            {
                this._id = value;
            }
        }


        public DateTime Created
        {
            get
            {
                return this._created;
            }
            set
            {
                this._created = value;
            }
        }

        #endregion

        #region IOwnableDO Members

        public Guid OwnerID { get; set; }

        #endregion
    }
}
