using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Validation
{


    public class CommentValidationHelper: IValidationHelper
    {

        public ICommentManager CommentManager
        {
            get;
            set;
        }

        #region IValidationHelper Members

        public ValidationStateDictionary Validate(ListenTo.Shared.DO.BaseDO domainObject, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ValidationStateDictionary validationStateDictionary = new ValidationStateDictionary();

            Comment commentDO = (Comment)domainObject;

            if (commentDO.Body == string.Empty)
            {
                validationStateDictionary.AddValidationError(ValidationStateKeys.COMMENT_BODY_INVALID);
            }

            return validationStateDictionary;
        }

        #endregion
    }
}
