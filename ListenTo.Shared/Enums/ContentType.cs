using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Enums
{

    public enum  ContentType
    {
        EMPTY = -1,

        /// <summary>
        /// NewsItem
        /// </summary>
        NEWSITEM = 0,

        /// <summary>
        /// An Artist
        /// </summary>
        ARTIST = 1,

        /// <summary>
        /// A gig
        /// </summary>
        GIG = 2,

        /// <summary>
        /// A Track
        /// </summary>
        TRACK = 3,

        /// <summary>
        /// A Comment
        /// </summary>
        COMMENT = 4,

        /// <summary>
        /// USER
        /// </summary>
        USER = 5,

        /// <summary>
        /// USERPROFILE
        /// </summary>
        USERPROFILE = 6

    }
}


