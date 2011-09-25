using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ListenTo.Shared.Utility;

namespace ListenTo.Web.Models
{
    public class UserContentViewModel : ListenTo.Web.Models.AccountViewModel
    {
        public IPageOfList<ListenTo.Shared.DTO.NewsItemSummary> NewsItemSummaries { get; set; }
        public IPageOfList<ListenTo.Shared.DTO.ArtistSummary> ArtistSummaries { get; set; }
    }
}
