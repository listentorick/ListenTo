using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface ITownManager : IManager <Town>
    {
        /// <summary>
        /// NOTE, this will alse return deleted towns
        /// </summary>
        /// <returns></returns>
        IList<Town> GetTowns();
    }
}
