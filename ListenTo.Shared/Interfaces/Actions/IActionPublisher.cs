using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Actions
{
    public interface IActionPublisher
    {
        void Publish(ListenTo.Shared.DO.Action action);
    }
}
