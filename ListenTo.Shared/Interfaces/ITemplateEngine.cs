using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace ListenTo.Shared.Interfaces
{
    public interface ITemplateEngine
    {
        string Process(string template, Hashtable values);
    }
}
