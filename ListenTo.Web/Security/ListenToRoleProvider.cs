//using System;
//using System.Web.Security;
//using System.Collections.Generic;
//using System.Collections.Specialized;
//using System.Configuration.Provider;
//using System.Web.Hosting;
//using System.Xml;
//using System.Security.Permissions;
//using System.Web;
//using ListenTo.Shared.Interfaces.Managers;

//namespace ListenTo.Web.Security
//{

//    public class ListenToRoleProvider : RoleProvider
//    {
//        public static string ADMIN = "ADMIN";
//        public static string USER = "USER";

//        public IUserManager UserManager { get; set; }

//        // RoleProvider properties
//        public override string ApplicationName
//        {
//            get { throw new NotSupportedException(); }
//            set { throw new NotSupportedException(); }
//        }

//        // RoleProvider methods
//        public override void Initialize(string name,
//            NameValueCollection config)
//        {
//            // Verify that config isn't null
//            if (config == null)
//                throw new ArgumentNullException("config");

//            // Assign the provider a default name if it doesn't have one
//            if (String.IsNullOrEmpty(name))
//                name = "ListenToRoleProvider";

//            // Add a default "description" attribute to config if the
//            // attribute doesn't exist or is empty
//            if (string.IsNullOrEmpty(config["description"]))
//            {
//                config.Remove("description");
//                config.Add("description", "ListenToRoleProvider role provider");
//            }

//            // Call the base class's Initialize method
//            base.Initialize(name, config);
//        }

//        public override bool IsUserInRole(string username, string roleName)
//        {
//            bool isUserInRole = true;
//            // Validate input parameters
//            if (username == null || roleName == null)
//                throw new ArgumentNullException();
//            if (username == String.Empty || roleName == string.Empty)
//                throw new ArgumentException();

//            if (roleName == ListenToRoleProvider.ADMIN)
//            {
//                isUserInRole = UserManager.IsUserAdmin(username);
//            }

//            return isUserInRole;
//        }

//        public override string[] GetRolesForUser(string username)
//        {
//            throw new NotSupportedException();
//        }

//        public override string[] GetUsersInRole(string roleName)
//        {
//            throw new NotSupportedException();
//        }

//        public override string[] GetAllRoles()
//        {
//            throw new NotSupportedException();
//        }

//        public override bool RoleExists(string roleName)
//        {
//            // Validate input parameters
//            if (roleName == null)
//                throw new ArgumentNullException();
//            if (roleName == string.Empty)
//                throw new ArgumentException();

//            // Determine whether the role exists
//            return roleName==ADMIN || rolename==USER;
//        }

//        public override void CreateRole(string roleName)
//        {
//            throw new NotSupportedException();
//        }

//        public override bool DeleteRole(string roleName,
//            bool throwOnPopulatedRole)
//        {
//            throw new NotSupportedException();
//        }

//        public override void AddUsersToRoles(string[] usernames,
//            string[] roleNames)
//        {
//            throw new NotSupportedException();
//        }

//        public override string[] FindUsersInRole(string roleName,
//            string usernameToMatch)
//        {
//            throw new NotSupportedException();
//        }

//        public override void RemoveUsersFromRoles(string[] usernames,
//            string[] roleNames)
//        {
//            throw new NotSupportedException();
//        }

   
//    }
//}
