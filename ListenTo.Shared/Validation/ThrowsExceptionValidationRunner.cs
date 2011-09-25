using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Validation
{
    public class ThrowsExceptionValidationRunner: IValidationRunner
    {

        public IDictionary<Type, IValidationHelper> ValidationHelpers { get; set; }

        public bool HasValidationHelper(BaseDO domainObject, out IValidationHelper validationHelper)
        {
            //Check Direct Types
            Type type = domainObject.GetType();
            validationHelper = null;
            if (this.ValidationHelpers.ContainsKey(type))
            {
                validationHelper = this.ValidationHelpers[type];
            }
            return validationHelper != null;
        }


        public bool Validate(BaseDO domainObject, UserCredentials userCredentials)
        {
            IValidationHelper validationHelper;

            bool hasValidationHelper = HasValidationHelper(domainObject, out validationHelper);

            if (hasValidationHelper == false)
            {
                throw new Exception("The domain object doesnt have validtion helper");
            }

            ValidationStateDictionary validationStateDictionary = validationHelper.Validate(domainObject, userCredentials);
            if (validationStateDictionary.Count > 0)
            {
               throw new ValidationException(validationStateDictionary);
            }

           return true;
        }
    }
}
