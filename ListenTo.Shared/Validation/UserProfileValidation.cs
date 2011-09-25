using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Managers;

namespace ListenTo.Shared.Validation
{

    public class UserProfileValidationHelper : IValidationHelper
    {

        #region IValidationHelper Members

        public ValidationStateDictionary Validate(ListenTo.Shared.DO.BaseDO domainObject, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ValidationStateDictionary validationStateDictionary = new ValidationStateDictionary();

            UserProfile userProfileDO = (UserProfile)domainObject;

            if (userProfileDO.Forename != null && userProfileDO.Forename.Length > 50)
            {
                validationStateDictionary.AddValidationError("Forename", ValidationStateKeys.USERPROFILE_FORENAME_IS_TOO_LONG);
            }

            if (userProfileDO.Surname!=null && userProfileDO.Surname.Length > 50)
            {
                validationStateDictionary.AddValidationError("Surname", ValidationStateKeys.USERPROFILE_SURNAME_IS_TOO_LONG);
            }

            if (userProfileDO.Profile!=null && userProfileDO.Profile.Length > 1000)
            {
                validationStateDictionary.AddValidationError("Profile", ValidationStateKeys.USERPROFILE_PROFILE_IS_TOO_LONG);
            }

            return validationStateDictionary;
        }

        #endregion
    }
}
