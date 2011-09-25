using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.IO;

namespace ListenTo.Core.Mail
{
    public interface ITemplateEngine
    {
        string Process(string template, Hashtable values);
    }
}
