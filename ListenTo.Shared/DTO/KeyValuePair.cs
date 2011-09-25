using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces;

namespace ListenTo.Shared.DTO
{
    public class KeyValuePair : IKeyValuePair
    {
        #region Properties

        private Guid _id;
        private string _value;

        #endregion

        #region Accessors

        #region IDTO Members

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

        #endregion

        #region IKeyValuePair Members

        public string Value
        {
            get
            {
                return this._value;
            }
            set
            {
                this._value = value;
            }
        }

        #endregion

        #endregion

    }
}
