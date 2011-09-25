using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;


namespace ListenTo.Data.LinqToSQL.Adapters
{
    public class UserAdapters : IAdapter<ListenTo.Shared.DO.User,ListenTo.Data.LinqToSQL.User>
    {
        public ListenTo.Shared.DO.User Adapt(User user)
        {
            ListenTo.Shared.DO.User domainUser = new ListenTo.Shared.DO.User();
            domainUser.ID = user.ID;
            domainUser.Username = user.Username;
            domainUser.Password = user.Password;
            domainUser.EmailAddress = user.EmailAddress;
            domainUser.IsValidated = user.IsUserValidated.GetValueOrDefault(false);
            return domainUser;
        }

        public IQueryable<ListenTo.Shared.DO.User> Adapt( IQueryable<ListenTo.Data.LinqToSQL.User> users)
        {
            IList<ListenTo.Shared.DO.User> domainUsers = new List<ListenTo.Shared.DO.User>();
            List < ListenTo.Data.LinqToSQL.User> linqToSQlUsers = users.ToList<ListenTo.Data.LinqToSQL.User>();

            foreach (ListenTo.Data.LinqToSQL.User user in linqToSQlUsers)
            {
                domainUsers.Add(Adapt(user));
            }
            return domainUsers.AsQueryable();
        }


    }
}
