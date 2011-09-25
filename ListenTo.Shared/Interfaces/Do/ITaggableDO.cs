using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.DO
{
    public interface ITaggableDO
    {
        IList<Tag> Tags
        {
            get;
            set;
        }
    }
}
