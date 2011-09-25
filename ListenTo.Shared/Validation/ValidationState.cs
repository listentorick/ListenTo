using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Validation
{
    public class ValidationState
    {
        private IList<String> _errors = new List<String>();
        public IList<String> Errors { get { return this._errors; } }
    }
}

