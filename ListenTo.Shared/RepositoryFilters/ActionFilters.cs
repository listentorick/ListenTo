using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class ActionFilters
    {

        public static IQueryable<ListenTo.Shared.DO.Action> WithOwnerId(this IQueryable<ListenTo.Shared.DO.Action> qry, Guid Id)
        {
            return from action in qry
                   where action.OwnerID == Id
                   select action;
        }

        public static IQueryable<ListenTo.Shared.DO.Action> WithID(this IQueryable<ListenTo.Shared.DO.Action> qry, IQueryable<Guid> Ids)
        {
            return from action in qry
                   where Ids.Contains(action.ID)
                   select action;
        }

        public static IQueryable<ListenTo.Shared.DO.Action> WithSiteId(this IQueryable<ListenTo.Shared.DO.Action> qry, Guid Id)
        {
            return from action in qry
                   where action.TargetSites.Contains(Id)
                   select action;
        }
        


    }
}
