using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Enums;

namespace ListenTo.Shared.DO
{
    public class Action: BaseDO
    {

        public ActionType ActionType { get; set; }
        public ContentType ContentType { get; set; }
        public Guid ContentID { get; set; }
        public PropertyType PropertyType { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public IList<Guid> TargetSites { get; set; }
        public IList<Guid> AssociatedArtistIds { get; set; }
        public object ActionData { get; set; }
        public string OwnerUsername { get; set; }
        public Action()
        {
            ID = Guid.NewGuid();
            TargetSites = new List<Guid>();
            AssociatedArtistIds = new List<Guid>();
        }

    }

}
