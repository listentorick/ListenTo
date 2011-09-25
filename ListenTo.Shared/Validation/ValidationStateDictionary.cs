using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Validation
{
    public class ValidationStateDictionary: Dictionary<string, ValidationState>
    {
        public void AddValidationError(string key)
        {
            this.AddValidationError(key, string.Empty);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="key">The property on the model which the error applies too</param>
        /// <param name="errorMessage">The particular error message</param>
        public void AddValidationError(string key, string errorMessage)
        {
            ValidationState validationState = null;

            if (this.ContainsKey(key))
            {
                validationState = this[key];
            }
            else
            {
                validationState = new ValidationState();
                this[key] = validationState;
            }

            validationState.Errors.Add(errorMessage);
        }

        public bool IsValid()
        {
            return this.Count == 0;
        }
    }
}
