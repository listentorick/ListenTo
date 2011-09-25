using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Actions;

namespace ListenTo.Core.Actions
{
    public class NewsAddedActionUrlHelper : IActionUrlHelper
    {
        #region IActionUrlHelper Members

        public string GetUrl(ListenTo.Shared.DO.Action action)
        {
            return "http://www.listentomanchester.co.uk/news/" + action.ContentID.ToString();
        }

        #endregion
    }
}
