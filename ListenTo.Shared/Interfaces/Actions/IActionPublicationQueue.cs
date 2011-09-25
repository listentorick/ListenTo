using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Actions
{
    public interface IActionPublicationQueue
    {
        void PublishAction(ListenTo.Shared.DO.Action action);
    }
}
