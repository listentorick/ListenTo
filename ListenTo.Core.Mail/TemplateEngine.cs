using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Ader.TemplateEngine;
using System.IO;

namespace ListenTo.Core.Mail
{
    public class TemplateEngine: ITemplateEngine
    {
        #region ITemplateEngine Members

        public string Process(string template, System.Collections.Hashtable values)
        {
            TemplateManager templateManager = TemplateManager.FromString(template);

            foreach (System.Collections.DictionaryEntry entry in values)
            {
                templateManager.SetValue(entry.Key.ToString(), entry.Value);
            }

            StringWriter processedMessage = new StringWriter();

            templateManager.Process(processedMessage);

            return processedMessage.ToString();
        }

        #endregion
    }
}
