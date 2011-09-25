using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Enums
{

    public enum ActionType { 
        
        /// When a newsitem is added
        /// </summary>
        ADDED_A_NEWS_ITEM = 0,

        /// <summary>
        /// When a new artist is added
        /// </summary>
        ADDED_AN_ARTIST  = 1,

        /// <summary>
        /// When a new track is added
        /// </summary>
        ADDED_A_TRACK = 2,

         /// <summary>
        /// When a new track is added to a playlist
        /// </summary>
        ADDED_A_TRACK_TO_A_PLAYLIST = 3,

        /// <summary>
        /// When a new Gig 
        /// </summary>
        ADDED_A_GIG = 4,

        /// <summary>
        /// When an act is added to a gig....
        /// </summary>
        ADDED_AN_ACT_TO_GIG = 5,

        /// <summary>
        /// Became the fan of an artist
        /// </summary>
        BECAME_FAN_OF_AN_ARTIST  = 6,

        /// <summary>
        /// Posted a comment
        /// </summary>
        COMMENTED_ON  = 7,

        /// <summary>
        /// Edited their public profile...
        /// </summary>
        EDITED_THEIR_PUBLIC_PROFILE = 8,

        JOINED = 9,

        /// <summary>
        /// A user has commented on a news item
        /// </summary>
        COMMENTED_ON_A_NEWSITEM = 10,

        /// <summary>
        /// A user has commented on a user profile
        /// </summary>
        COMMENTED_ON_A_USERPROFILE = 11
       
    }
}
