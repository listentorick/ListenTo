using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace ListenTo.Web.Helpers
{
    public class LocaleHelpers
    {

        public static string GetBestRFC3066Locale(string[] userLocales)
        {
            string bestLocale = String.Empty;

            if (userLocales != null && userLocales.Length > 0)
            {
                bestLocale = userLocales[0];
            }

            return bestLocale;
        }
    }
}
