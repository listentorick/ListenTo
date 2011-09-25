using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Repository
{
    public interface IRepositoryFactory
    {
        IRepository GetRepository();
    }
}
