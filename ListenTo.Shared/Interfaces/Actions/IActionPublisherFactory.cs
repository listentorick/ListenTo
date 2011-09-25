using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Actions
{
    public interface IActionPublisherFactory
    {
        IList<IActionPublisher> GetPublishers(ListenTo.Shared.DO.Action action);
    }
}
