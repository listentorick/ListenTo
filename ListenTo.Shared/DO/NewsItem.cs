using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DO
{
    public class NewsItem : BaseDO, INamedDO, IPublishableDO, ISuspendableDO, IDeleteableDO
    {
        public string Name {get; set; }
        public string Description {get; set;}
        public string Body { get; set; }
        public bool IsPublished { get; set; }
        public IList<Site> TargetSites { get; set; }
        public bool IsSuspended { get; set; }
        public ImageMetaData Image { get; set; }
        public string ResourceURL { get; set; }

        #region IDeleteableDO Members

        public bool IsDeleted  { get; set; }


        #endregion
    }
}
