using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using ListenTo.Shared.DO;
using System.Collections.Generic;
using ListenTo.Shared.DTO;
using System.Web.Mvc;

namespace ListenTo.Web.Models
{
    public class HomePageViewModel : BaseListenToViewModel
    {
        public IList<Gig> Gigs {get;set;}
        public IList<ArtistSummary> Artists {get;set;}
        public int NumberOfArtists {get;set;}
        public IList<NewsItemSummary> NewsItemSummary { get; set; }
        public IList<StyleSummary> StyleSummaries { get; set; }
        public SelectList StylesSelectList { get; set; }
    }
}
