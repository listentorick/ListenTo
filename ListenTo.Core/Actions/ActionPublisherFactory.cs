using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.Enums;

namespace ListenTo.Core.Actions
{
    public class ActionPublisherFactory : IActionPublisherFactory
    {

        public IDictionary<ActionType, List<IActionPublisher>> ActionPublishers { get; set; }

        #region IActionPublisherFactory Members

        public IList<IActionPublisher> GetPublishers(ListenTo.Shared.DO.Action action)
        {
            IList<IActionPublisher> publishers = null;
            this.HasPublishers(action.ActionType, out publishers);
            return publishers;
        }

        public bool HasPublishers(ActionType at, out IList<IActionPublisher> publishers)
        {
            publishers = new List<IActionPublisher>();
            if (this.ActionPublishers.ContainsKey(at))
            {
                publishers = this.ActionPublishers[at];
            }
            return publishers.Count !=0;
        }

        #endregion
    }
}
