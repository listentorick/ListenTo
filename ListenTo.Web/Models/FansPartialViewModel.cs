﻿using System;
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
using System.Collections.Generic;

namespace ListenTo.Web.Models
{
    public class FansPartialViewModel
    {
        public int NumberPerRow { get; set; }
        public IList<ListenTo.Shared.DTO.ArtistFanRelationshipSummary> ArtistFanRelationshipSummaries { get; set; }
    }
}
