using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Validation
{
    public class VenueValidationHelper : IValidationHelper
    {

        public IVenueManager VenueManager
        {
            get;
            set;
        }

        #region IValidationHelper Members

        public ValidationStateDictionary Validate(ListenTo.Shared.DO.BaseDO domainObject, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ValidationStateDictionary validationStateDictionary = new ValidationStateDictionary();

            Venue venueDO = (Venue)domainObject;

            if (venueDO.Name == string.Empty)
            {
                validationStateDictionary.AddValidationError(ValidationStateKeys.VENUE_NEEDS_NAME);
            }

            if (venueDO.Name.Length > 50)
            {
                validationStateDictionary.AddValidationError(ValidationStateKeys.VENUE_NAME_IS_TOO_LONG);
            }

            return validationStateDictionary;
        }

        #endregion
    }
}
