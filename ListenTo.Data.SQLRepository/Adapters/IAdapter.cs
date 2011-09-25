using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Data.LinqToSQL.Adapters
{
    public interface IAdapter<DOMAIN, DTO>
    {
        DOMAIN Adapt(DTO objectToAdapt);
        IQueryable<DOMAIN> Adapt(IQueryable<DTO> objectsToAdapt);
    }
}
