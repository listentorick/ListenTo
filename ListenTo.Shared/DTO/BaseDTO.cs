using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DTO;

namespace ListenTo.Shared.DTO
{
    public class BaseDTO: IDTO
    {
        public Guid ID { get; set; }
    }
}
