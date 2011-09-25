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
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Do;

namespace ListenTo.Web.Security
{
    public class ListenToUser : IListenToUser
    {
        private MembershipUser _membershipUser;
        private IUserManager _userManager;
        private User _user;
        private System.Security.Principal.IIdentity _identity;
        private UserCredentials _userCredentials;

        #region ~ Properties ~

        public MembershipUser MembershipUser
        {
            get { return _membershipUser; }
        }

        #endregion

        #region ~ Constructors ~

        private ListenToUser()
        {
        }

        public ListenToUser(MembershipUser membershipUser, IUserManager userManager)
        {
            this._membershipUser = membershipUser;
            Guid id = (Guid)this._membershipUser.ProviderUserKey;
            _user = userManager.GetByID(id);
            _identity = new System.Security.Principal.GenericIdentity(this._membershipUser.UserName);
            _userCredentials = new UserCredentials();
            _userCredentials.Username = _user.Username;
            _userCredentials.Password = _user.Password;
        }

        #endregion

        public string Username
        {
            get { return _membershipUser.UserName; }
        }

        public UserCredentials UserCredentials
        {
            get { return _userCredentials; }
        }

        #region IPrincipal Members

        public System.Security.Principal.IIdentity Identity
        {
            get { return this._identity; }
        }

        public bool IsInRole(string role)
        {
            return true;
        }

        #endregion

        #region IListenToUser Members


        public Guid UserId
        {
            get { return this._user.ID; }
        }

        #endregion
    }
}
