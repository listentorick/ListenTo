using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Interfaces.Actions;
using ListenTo.Shared.ActionData;

namespace ListenTo.Core.Actions
{
    public class ArtistAddedActionDataHelper: IActionDataHelper
    {
        public IArtistManager ArtistManager { get; set; }

        #region IActionDataHelper Members

        public object GetActionData(ListenTo.Shared.DO.Action action)
        {
            ArtistAddedActionData artistAddedActionData = new ArtistAddedActionData();
            artistAddedActionData.Artist = ArtistManager.GetByID(action.ContentID);
            return artistAddedActionData;
        }

        #endregion
    }
}
