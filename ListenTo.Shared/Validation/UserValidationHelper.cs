using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Helpers;

namespace ListenTo.Shared.Validation
{

    public class UserValidationHelper : IValidationHelper
    {
        public IUserManager UserManager
        {
            get;
            set;
        }

        #region IValidationHelper Members

        public ValidationStateDictionary Validate(ListenTo.Shared.DO.BaseDO domainObject, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ValidationStateDictionary  validationStateDictionary =  new ValidationStateDictionary();

            User userDO = (User)domainObject;

            if (userDO.Username == string.Empty || userDO.Username == null)
            {
                validationStateDictionary.AddValidationError("Username", ValidationStateKeys.USER_NEEDS_A_USERNAME);
            }
            else if (userDO.Username.Length < 3 )
            {
                validationStateDictionary.AddValidationError("Username", ValidationStateKeys.USER_USERNAME_TOO_SHORT);

            }
            else if (!FormatHelpers.IsAlphaNumeric(userDO.Username))
            {
                validationStateDictionary.AddValidationError("Username", ValidationStateKeys.USER_USERNAME_MUST_BE_ALPHA_NUMERIC);
            }

            else
            {
                User persistedUser = UserManager.GetUserByUsername(userDO.Username);

                if (persistedUser != null && persistedUser.ID != userDO.ID)
                {
                    validationStateDictionary.AddValidationError("Username", ValidationStateKeys.USER_USERNAME_NOT_AVAILABLE);
                }
            }

            if (userDO.Password == string.Empty || userDO.Password == null)
            {
                validationStateDictionary.AddValidationError("Password", ValidationStateKeys.USER_NEEDS_A_PASSWORD);
            }
            else if(userDO.Password.Length<6)
            {
                validationStateDictionary.AddValidationError("Password", ValidationStateKeys.USER_PASSWORD_TOO_SHORT);
            }

            if (userDO.EmailAddress == string.Empty || userDO.EmailAddress == null)
            {
                validationStateDictionary.AddValidationError("EmailAddress", ValidationStateKeys.USER_NEEDS_A_EMAILADDRESS);
            }
            else 
            {
                if (!Helpers.FormatHelpers.IsEmail(userDO.EmailAddress))
                {
                    validationStateDictionary.AddValidationError("EmailAddress", ValidationStateKeys.USER_NEEDS_A_VALID_EMAILADDRESS);
                }
                else
                {
                    User persistedUser = UserManager.GetUserByEmailAddress(userDO.EmailAddress);

                    if (persistedUser!=null) {
                        validationStateDictionary.AddValidationError("EmailAddress", ValidationStateKeys.USER_NEEDS_A_UNIQUE_EMAILADDRESS);
                    }
                }

              
            }

            return validationStateDictionary;
        }

        #endregion
    }
}
