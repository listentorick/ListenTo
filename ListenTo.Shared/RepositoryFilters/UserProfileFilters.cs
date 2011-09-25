using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class UserProfileFilters
    {

        public static IQueryable<UserProfile> WithID(this IQueryable<UserProfile> qry, Guid Id)
        {
            return from userProfile in qry
                   where userProfile.ID == Id
                   select userProfile;
        }

        public static IQueryable<UserProfile> WithUsername(this IQueryable<UserProfile> qry, string username)
        {
            return from userProfile in qry
                   where userProfile.Username == username
                   select userProfile;
        }
    }
}
