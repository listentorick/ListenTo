using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Interfaces.Managers;

namespace ListenTo.Shared.Validation
{

    public class TrackValidationHelper : IValidationHelper
    {

        #region IValidationHelper Members

        public ValidationStateDictionary Validate(ListenTo.Shared.DO.BaseDO domainObject, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ValidationStateDictionary validationStateDictionary = new ValidationStateDictionary();

            Track track = (Track)domainObject;

            if (track.Style == null)
            {
                validationStateDictionary.AddValidationError("Style", ValidationStateKeys.TRACK_NEEDS_A_STYLE);
            }

            if (track.Artist == null)
            {
                validationStateDictionary.AddValidationError("Artist", ValidationStateKeys.TRACK_NEEDS_AN_ARTIST);
            }

            if (track.Name.Trim() == string.Empty)
            {
                validationStateDictionary.AddValidationError("Name", ValidationStateKeys.TRACK_NEEDS_A_NAME);
            }

            if (track.Data == null)
            {
                validationStateDictionary.AddValidationError("Data", ValidationStateKeys.TRACK_NEEDS_AN_MP3);
            }
            else if( !ListenTo.Shared.Helpers.TrackHelpers.TrackContainsMP3Data(track))
            {
                validationStateDictionary.AddValidationError("Data", ValidationStateKeys.TRACK_NEEDS_A_VALID_MP3);
            }
            
            return validationStateDictionary;
        }

        #endregion


    }
}
