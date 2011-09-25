using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.DO;

namespace ListenTo.Shared.DO
{
    public class BaseContentDO: BaseDO, IContentDO
    {
        #region Properties

        private string _title;
        private string _description;
        private bool _isDeleted;
        private bool _isSuspended;
        private bool _isPublished;
        private Guid _ownerID;
        private IList<Tag> _tags;

        #endregion

        #region IOwnableDO Members

        public Guid OwnerID
        {
            get
            {
                return this._ownerID;
            }
            set
            {
                this._ownerID = value;
            }
        }

        #endregion

        #region IPublishableDO Members

        public bool IsPublished
        {
            get
            {
                return this._isPublished;
            }
            set
            {
                this._isPublished = value;
            }
        }

        #endregion

        #region ISuspendableDO Members

        public bool IsSuspended
        {
            get
            {
                return this._isSuspended;
            }
            set
            {
                this._isSuspended = value;
            }
        }

        #endregion

        #region IDeleteableDO Members

        public bool IsDeleted
        {
            get
            {
                return this._isDeleted;
            }
            set
            {
                this._isDeleted = value;
            }
        }

        #endregion

        #region IContentDO Members

        public string Title
        {
            get
            {
                return this._title;
            }
            set
            {
                this._title = value;
            }
        }

        public string Description
        {
            get
            {
               return this._description;
            }
            set
            {
                this._description = value;
            }
        }

        #endregion

        #region ITaggableDO Members

        public IList<Tag> Tags
        {
            get
            {
                return this._tags;
            }
            set
            {
                this._tags = value;
            }
        }

        #endregion

        #region Constructors

        public BaseContentDO()
        {
            this.Tags = new List<Tag>();
        }

        #endregion
    }
}
