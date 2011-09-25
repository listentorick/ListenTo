using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DTO;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Shared.Utility;

namespace ListenTo.Core.Managers
{
    public class WhatsNewManager : BaseManager, IWhatsNewManager
    {
        public INewsItemManager NewsItemManager { get; set; }
        public IGigManager GigManager { get; set; }
        public ITrackManager TrackManager { get; set; }
        public IArtistManager ArtistManager { get; set; }

        #region IWhatsNewManager Members

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.Interfaces.DTO.IDTO> GetWhatsNewSummaries(int pageSize, int currentPageIndex, Guid siteId)
        {
            //Returns the ids of all the latest content
            IList<Guid> ids = this.Repository.GetWhatsNewSummariesForSite(pageSize, currentPageIndex, siteId);
            return ConstructWhatsNewsFromIds(ids, currentPageIndex, pageSize);

        }

        public ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.Interfaces.DTO.IDTO> GetWhatsNewSummariesOwnedByUser(int pageSize, int currentPageIndex, Guid siteId, Guid UserId)
        {
            //Returns the ids of all the latest content
            IList<Guid> ids = this.Repository.GetWhatsNewSummariesOwnedByUser(pageSize, currentPageIndex, siteId, UserId);
            return ConstructWhatsNewsFromIds(ids, currentPageIndex, pageSize);
        }

        private ListenTo.Shared.Utility.IPageOfList<ListenTo.Shared.Interfaces.DTO.IDTO> ConstructWhatsNewsFromIds(IList<Guid> ids, int currentPageIndex, int pageSize)
        {
            IList<IDTO> content = new List<IDTO>();

            //Grab any news which are represented by these ids
            IList<NewsItemSummary> newsItems = NewsItemManager.GetSummariesByIds(ids);

            foreach (NewsItemSummary newsItemSummary in newsItems)
            {
                content.Add(newsItemSummary);
            }

            return content.AsQueryable<IDTO>().ToPageOfList(currentPageIndex, pageSize);
        }

        #endregion


    }
}
