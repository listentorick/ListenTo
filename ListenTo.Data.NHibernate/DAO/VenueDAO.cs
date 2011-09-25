using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DAO;
using ListenTo.Shared.DO;

namespace ListenTo.Data.NHibernate.DAO
{
    public class VenueDAO : HibernateDAO<Venue, Guid?>, ListenTo.Shared.Interfaces.DAO.IVenueDAO
    {

    }
}
