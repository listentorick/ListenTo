using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;
using ListenTo.Shared.Helpers;
using ListenTo.Shared.Interfaces.Managers;

namespace ListenTo.Shared.Validation
{

    public class  NewsItemValidationHelper : IValidationHelper
    {

        #region IValidationHelper Members

        public ValidationStateDictionary Validate(ListenTo.Shared.DO.BaseDO domainObject, ListenTo.Shared.DO.UserCredentials userCredentials)
        {
            ValidationStateDictionary validationStateDictionary = new ValidationStateDictionary();

            NewsItem newsItem = (NewsItem)domainObject;

            if (newsItem.Name.Trim() == string.Empty)
            {
                validationStateDictionary.AddValidationError("Name", ValidationStateKeys.NEWSITEM_NEEDS_A_NAME);
            }
            else if(newsItem.Name.Length> 50)
            {
                validationStateDictionary.AddValidationError("Name", ValidationStateKeys.NEWSITEM_NAME_IS_TOO_LONG);
            }

            if (newsItem.Description.Trim() == string.Empty)
            {
                validationStateDictionary.AddValidationError("Description", ValidationStateKeys.NEWSITEM_NEEDS_A_DESCRIPTION);
            }
            else if (newsItem.Description.Length > 200)
            {
                validationStateDictionary.AddValidationError("Description", ValidationStateKeys.NEWSITEM_DESCRIPTION_IS_TOO_LONG);
            }

            if (newsItem.Body.Trim() == string.Empty)
            {
                validationStateDictionary.AddValidationError("Body", ValidationStateKeys.NEWSITEM_NEEDS_A_BODY);
            }
            //else if (newsItem.Body.Length > 6000)
            //{
            //    validationStateDictionary.AddValidationError("Body", ValidationStateKeys.NEWSITEM_BODY_IS_TOO_LONG);
            //}

            if (newsItem.TargetSites == null || newsItem.TargetSites.Count == 0) {
                validationStateDictionary.AddValidationError("TargetSites", ValidationStateKeys.NEWSITEM_SHOULD_BE_PUBLISHED_TO_AT_LEAST_ONE_SITE);
            } 

            return validationStateDictionary;
        }

        #endregion


    }
}
