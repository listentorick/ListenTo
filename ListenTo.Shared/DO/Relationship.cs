using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Enums;

namespace ListenTo.Shared.DO
{
    
    /// <summary>
    /// This object is use for constructing relationships.
    /// </summary>
    public class Relationship : BaseDO
    {
        public Guid SourceId {get;set;}
        public ContentType SourceContentType {get;set;}
        public Guid TargetId {get;set;}
        public ContentType TargetContentType {get;set;}
        public string Description { get; set; }
    }
}
