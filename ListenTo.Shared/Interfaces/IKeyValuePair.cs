using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Shared.Interfaces
{
    /// <summary>
    /// Used for populating simple lists i.e. Lists of Venues
    /// </summary>
    public interface IKeyValuePair: IDTO
    {
        string Value
        {
            get;
            set;
        }
    }
}
