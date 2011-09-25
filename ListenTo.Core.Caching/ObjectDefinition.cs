using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Core.Caching
{
    public class ObjectDefinition
    {
        public string Target { get; set; }
        public IList<MethodDefinition> MethodDefinitions { get; set; }
    }
}
