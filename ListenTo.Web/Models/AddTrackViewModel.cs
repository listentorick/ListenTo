using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ListenTo.Shared.DO;
using System.Web.Mvc;

namespace ListenTo.Web.Models
{
    public class AddTrackViewModel
    {
        public Track Track { get; set; }
        public UploadFilePartialViewModel File { get; set; }
        public bool UserHasArtists { get; set; }
        public SelectList OwnedArtists { get; set; }
        public bool HasPersistedTrackData { get; set; }
        public bool HasValidTemporaryFile { get; set; }
    }
}
