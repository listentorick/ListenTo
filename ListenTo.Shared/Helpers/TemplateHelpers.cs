using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Helpers
{
    public class TemplateHelpers
    {

        public static string GetRegistrationEmailSubjectTemplate()
        {
            return TemplateHelpers.GetTemplate(TemplateHelpers.GetRegistrationEmailSubjectTemplatePath());
        }

        public static string GetRegistrationEmailBodyTemplate()
        {
            return TemplateHelpers.GetTemplate(TemplateHelpers.GetRegistrationEmailBodyTemplatePath());
        }

        public static string GetRetrieveDetailsEmailSubjectTemplate()
        {
            return TemplateHelpers.GetTemplate(TemplateHelpers.GetRetrieveDetailsEmailSubjectTemplatePath());
        }

        public static string GetRetrieveDetailsEmailBodyTemplate()
        {
            return TemplateHelpers.GetTemplate(TemplateHelpers.GetRetrieveDetailsEmailBodyTemplatePath());
        }

        public static string GetTemplateFromFilename(string filename)
        {
            string path = ConstructTemplateDirectory() + "/" + filename;
            return GetTemplate(path);
        }

        private static string GetTemplate(string path)
        {
            string template = string.Empty;
            using (System.IO.StreamReader myFile = new System.IO.StreamReader(path))
            {
                template = myFile.ReadToEnd().ToString();
            }
            return template;
        }

        private static string GetRetrieveDetailsEmailSubjectTemplatePath()
        {
            return TemplateHelpers.ConstructTemplateDirectory() + "/" + System.Configuration.ConfigurationSettings.AppSettings["RetrieveDetailsEmailSubjectTemplateFilename"];
        }


        private static string GetRetrieveDetailsEmailBodyTemplatePath()
        {
            return TemplateHelpers.ConstructTemplateDirectory() + "/" + System.Configuration.ConfigurationSettings.AppSettings["RetrieveDetailsEmailBodyTemplateFilename"];
        }


        private static string GetRegistrationEmailBodyTemplatePath()
        {
            return TemplateHelpers.ConstructTemplateDirectory() + "/" + System.Configuration.ConfigurationSettings.AppSettings["RegistrationEmailBodyTemplateFilename"];
        }

        private static string GetRegistrationEmailSubjectTemplatePath()
        {
            return TemplateHelpers.ConstructTemplateDirectory() + "/" + System.Configuration.ConfigurationSettings.AppSettings["RegistrationEmailSubjectTemplateFilename"];
        }

        private static string ConstructTemplateDirectory()
        {
            string absolutePath = System.Configuration.ConfigurationSettings.AppSettings["ApplicationPath"] + System.Configuration.ConfigurationSettings.AppSettings["ApplicationRelativeTemplatesDirectoryPath"];
            return absolutePath;
        }
    }
}
