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
using System.Web.Mvc;

namespace ListenTo.Web.Helpers.HtmlHelperExtensions
{
    public static class GeneralHelper
    {
        public static int NumberOfItemsRequiredToPopulateAllRows(this HtmlHelper helper, int count, int itemsPerRow)
        {

            int adjustment = 0;
            if (count < itemsPerRow)
            {
                adjustment = itemsPerRow - count;
            }
            else if (count > itemsPerRow)
            {
                adjustment = (count / itemsPerRow);
                adjustment = itemsPerRow - (count - (adjustment * itemsPerRow));

            }

            return adjustment;
        }
    }
}
