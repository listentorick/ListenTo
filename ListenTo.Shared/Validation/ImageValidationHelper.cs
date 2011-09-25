using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Interfaces.Managers;

namespace ListenTo.Shared.Validation
{

    public class ImageValidationHelper : IValidationHelper
    {

        #region IValidationHelper Members

        public ValidationStateDictionary Validate(ListenTo.Shared.DO.BaseDO domainObject, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ValidationStateDictionary validationStateDictionary = new ValidationStateDictionary();

            Image image = (Image)domainObject;

            if (image.Data == null || image.Data.Length==0)
            {
                validationStateDictionary.AddValidationError("Data", ValidationStateKeys.FILE_NEEDS_DATA);
            } 
            else if(!ListenTo.Shared.Helpers.ImageHelpers.IsFileImage(image.Data)) 
            {
                validationStateDictionary.AddValidationError("Data", ValidationStateKeys.FILE_IS_NOT_AN_IMAGE);
            }
            return validationStateDictionary;
        }

        #endregion


    }
}
