using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Do;

namespace ListenTo.Shared.Interfaces.Actions
{
    public interface IActionDataHelper
    {
        object GetActionData(ListenTo.Shared.DO.Action action);
    }
}
