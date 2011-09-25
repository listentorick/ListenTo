using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.DO;


namespace ListenTo.Shared.Interfaces.Managers
{
    public interface IManager<T>
    {
        T GetByID(Guid id);
        T Save(IDO dO, UserCredentials userCredentials);
        void Delete(Guid id, UserCredentials userCredentials);
    }
}
