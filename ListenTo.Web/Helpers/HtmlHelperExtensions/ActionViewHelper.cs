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
using ListenTo.Shared.Enums;
using System.Web.Mvc;

namespace ListenTo.Web.Helpers.HtmlHelperExtensions
{
    public static class ActionViewHelper
    {
        public static string GetListenToActionViewPath(this HtmlHelper helper, ListenTo.Shared.DO.Action action)
        {
            string viewPath = "~/Views/Shared/Actions/" + Enum.GetName(typeof(ActionType), action.ActionType) + ".ascx";
            return viewPath;
        }

    }
}
