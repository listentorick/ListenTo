using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Validation
{
    public interface IValidationHelper
    {
        ValidationStateDictionary Validate (BaseDO domainObject, UserCredentials userCredentials); 
    }
}
