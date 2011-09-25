using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class UserFilters
    {

        public static IQueryable<User> WithID(this IQueryable<User> qry, Guid Id)
        {
            return from user in qry
                   where user.ID == Id
                   select user;
        }


        public static IQueryable<User> WithUsername(this IQueryable<User> qry, string username)
        {
            return from user in qry
                   where String.Equals(user.Username, username, StringComparison.OrdinalIgnoreCase)
                   select user;
        }


        public static IQueryable<User> WithPassword(this IQueryable<User> qry, string password)
        {
            return from user in qry
                   where String.Equals(user.Password, password, StringComparison.OrdinalIgnoreCase)
                   select user;
        }


        public static IQueryable<User> IsValidated(this IQueryable<User> qry)
        {
            return from user in qry
                   where user.IsValidated == true
                   select user;
        }

        public static IQueryable<User> WithEmailAddress(this IQueryable<User> qry, string emailAddress)
        {
            emailAddress = emailAddress.ToLower().Trim();
            //Note we assume that email addresses are stored in lower case and trimmed. This is performed in the UserManager....
            return from user in qry
                   where user.EmailAddress == emailAddress
                   select user;
        }

        
    }
}
