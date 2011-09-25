using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Interfaces.Managers;

namespace ListenTo.Shared.Validation
{

    public class ArtistValidationHelper:IValidationHelper
    {
        #region IArtistManager 
        
        public IArtistManager ArtistManager {get;set;}
        
        #endregion

        #region IValidationHelper Members

        public ValidationStateDictionary Validate(ListenTo.Shared.DO.BaseDO domainObject, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ValidationStateDictionary validationStateDictionary = new ValidationStateDictionary();

            Artist artist = (Artist)domainObject;

            if (artist.Town == null)
            {
                validationStateDictionary.AddValidationError("Town", ValidationStateKeys.ARTIST_NEEDS_A_TOWN);
            }

            if (artist.Style == null)
            {
                validationStateDictionary.AddValidationError("Style", ValidationStateKeys.ARTIST_NEEDS_A_STYLE);
            }

            if (artist.ProfileAddress == string.Empty)
            {
                validationStateDictionary.AddValidationError("ProfileAddress", ValidationStateKeys.ARTIST_NEEDS_A_PROFILE_ADDRESS);
            }
            else
            {
                if (!FormatHelpers.IsAlphaNumeric(artist.ProfileAddress))
                {
                    validationStateDictionary.AddValidationError("ProfileAddress", ValidationStateKeys.ARTIST_PROFILE_ADDRESS_MUST_BE_ALPHA_NUMERIC);
                }

                Artist artistWithProfileAddress = ArtistManager.GetByProfileAddress(artist.ProfileAddress);
                if (artistWithProfileAddress != null && artistWithProfileAddress.ID != artist.ID)
                {
                    validationStateDictionary.AddValidationError("ProfileAddress", ValidationStateKeys.ARTIST_PROFILE_ADDRESS_MUST_BE_UNIQUE);
                }
            }

            if (artist.Name == string.Empty)
            {
                validationStateDictionary.AddValidationError("Name", ValidationStateKeys.ARTIST_NEEDS_A_NAME);
            }

            if (artist.Email != string.Empty && !FormatHelpers.IsEmail(artist.Email))
            {
                validationStateDictionary.AddValidationError("Email", ValidationStateKeys.ARTIST_EMAIL_ADDRESS_INVALID);
            }

            return validationStateDictionary;
        }

        #endregion


    }
}
