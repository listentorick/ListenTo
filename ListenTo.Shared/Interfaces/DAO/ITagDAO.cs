using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.DAO
{

    /// <summary>
    /// Defines the basic functionality of a Tag Data Access Object
    /// </summary>
    public interface ITagDao : IGenericDAO<Tag, Guid?>
    {

        /// <summary>
        /// Retrieves all the tags associated with a piece of content
        /// </summary>
        /// <param name="contentId">Content Id</param>
        /// <returns>A list of Tag objects</returns>
        IList<Tag> GetByContentId(Guid contentId);

    }
}
