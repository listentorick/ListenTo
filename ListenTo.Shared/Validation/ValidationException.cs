using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Validation
{

    public class ValidationException : Exception
    {
        private ValidationStateDictionary _validationStateDictionary;

        public ValidationStateDictionary ValidationStateDictionary
        {
            get { return this._validationStateDictionary; }
        }

        public ValidationException(ValidationStateDictionary validationStateDictionary)
        {
            this._validationStateDictionary = validationStateDictionary;
        }
    }
}
