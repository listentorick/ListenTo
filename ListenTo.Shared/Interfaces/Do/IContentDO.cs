using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Interfaces.DO
{
    public interface IContentDO : IDO, IOwnableDO, IPublishableDO, ISuspendableDO, IDeleteableDO, ITaggableDO
    {
        string Title
        {
            get;
            set;
        }

        string Description
        {
            get;
            set;
        }
  
    }
}
