using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DTO;

namespace ListenTo.Shared.RepositoryFilters
{
    public static class WhatsNewFilters
    {
        public static IQueryable<WhatsNew> WithOwnerID(this IQueryable<WhatsNew> qry, Guid OwnerId)
        {
            return from whatsNew in qry
                   where whatsNew.ContentOwnerID == OwnerId
                   select whatsNew;
        }

    }

}
