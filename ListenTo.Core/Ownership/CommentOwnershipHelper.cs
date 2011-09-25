using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.Interfaces.Ownership;

namespace ListenTo.Core.Ownership
{
    public class CommentOwnershipHelper : BaseOwnershipHelper, IOwnershipHelper
    {
        public ICommentManager CommentManager { get; set; }

        #region IOwnershipHelper Members

        public bool IsOwner(BaseDO domainObject, UserCredentials userCredentials)
        {
            return this.IsOwner<ICommentManager, Comment>((Comment)domainObject, userCredentials, CommentManager);
        }

        #endregion
    }
}
