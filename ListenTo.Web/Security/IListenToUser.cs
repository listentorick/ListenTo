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
using System.Security.Principal;
using ListenTo.Shared.Interfaces.Do;
using ListenTo.Shared.DO;

namespace ListenTo.Web.Security
{
    public interface IListenToUser: IPrincipal
    {
        MembershipUser MembershipUser { get; }
        UserCredentials UserCredentials { get; }
        Guid UserId { get; }
    }
}
