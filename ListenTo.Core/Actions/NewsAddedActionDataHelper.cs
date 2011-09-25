using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.ActionData;

namespace ListenTo.Core.Actions
{
    public class NewsAddedActionDataHelper: IActionDataHelper
    {
        public INewsItemManager NewsItemManager { get; set; }

        #region IActionDataHelper Members

        public object GetActionData(ListenTo.Shared.DO.Action action)
        {
            NewsAddedActionData newsAddedActionData = new NewsAddedActionData();
            newsAddedActionData.NewsItem = NewsItemManager.GetByID(action.ContentID);
            return newsAddedActionData;
        }

        #endregion
    }
}
