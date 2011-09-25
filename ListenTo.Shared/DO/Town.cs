using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DO
{
    public class Town : BaseDO, INamedDO, IDeleteableDO
    {
        public string Name
        {
            get;
            set;
        }

        public IList<Site> Sites
        {
            get;
            set;
        }


        #region IDeleteableDO Members

        public bool IsDeleted
        {
            get;
            set;
        }

        #endregion
    }
}
