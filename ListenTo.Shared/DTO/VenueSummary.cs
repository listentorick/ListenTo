using System;
using System.Collections.Generic;
using System.Text;

using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Shared.DTO
{
    public class VenueSummary: IDTO
    {
        #region Properties

        private Guid _id;
        private string _name;
        private Guid _townId;
        private string _townName;

        #endregion

        #region Accessors

        #region IDTO Members

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

        #endregion

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

        public Guid TownId
        {
            get
            {
                return _townId;
            }
            set
            {
                _townId = value;
            }
        }

        public string TownName
        {
            get
            {
                return _townName;
            }
            set
            {
                _townName = value;
            }
        }


        #endregion
    }
}
