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
using ListenTo.Shared.Interfaces.DO;
using System.Security.Principal;
using ListenTo.Web.Security;

namespace ListenTo.Web.Helpers
{
    public static class OwnershipHelpers
    {
        public static IOwnableDO SetOwner(IOwnableDO ownableDO, IPrincipal user)
        {
            if (user.Identity.IsAuthenticated)
            {
                ownableDO.OwnerID = ((ListenToUser)user).UserId;
            }
            else
            {
                throw new Exception("Cannot set owner, user is not authenticated");
            }

            return ownableDO;
        }
    }
}
