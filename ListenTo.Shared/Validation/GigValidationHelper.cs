using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Interfaces.Managers;

namespace ListenTo.Shared.Validation
{

    public class GigValidationHelper : IValidationHelper
    {
        #region IGigManager

        public IGigManager GigManager { get; set; }

        #endregion

        #region IValidationHelper Members

        public ValidationStateDictionary Validate(ListenTo.Shared.DO.BaseDO domainObject, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ValidationStateDictionary validationStateDictionary = new ValidationStateDictionary();

            Gig gig = (Gig)domainObject;

            if (gig.Name == string.Empty)
            {
                validationStateDictionary.AddValidationError("Name", ValidationStateKeys.GIG_NEEDS_A_NAME);
            }
            else if (gig.Name.Length > 100)
            {
                validationStateDictionary.AddValidationError("Name", ValidationStateKeys.GIG_NAME_IS_TOO_LONG);
            }

            if (gig.Description.Length > 6000)
            {
                validationStateDictionary.AddValidationError("Name", ValidationStateKeys.GIG_DESCRIPTION_IS_TOO_LONG);
            }

            if (gig.Venue== null)
            {
                validationStateDictionary.AddValidationError("Venue", ValidationStateKeys.GIG_NEEDS_A_VENUE);
            }

            if (gig.Acts == null || (gig.Acts!=null && gig.Acts.Count==0))
            {
                validationStateDictionary.AddValidationError("Acts", ValidationStateKeys.GIG_NEEDS_AT_LEAST_ONE_ACT);
            }
          
            return validationStateDictionary;
        }

        #endregion


    }
}
