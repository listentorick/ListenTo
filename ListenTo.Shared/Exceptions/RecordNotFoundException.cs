using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Exceptions
{
    /// <summary>
    /// Represents an error that occurred with in the Data Access Layer of ListenTo
    /// </summary>
    [Serializable]
    public class RecordNotFoundException : ListenToException
    {
        /// <summary>
        /// Default Record Not Found Exception
        /// </summary>
        public RecordNotFoundException()
            : base()
        {
        }

        /// <summary>
        /// Record Not Found Exception with a descriptive message
        /// </summary>
        /// <param name="message">Descriptive message explaining this exception</param>
        public RecordNotFoundException(string message)
            : this(message, null)
        { }

        /// <summary>
        /// Record Not Found Exception with a descriptive message and an inner exception.
        /// </summary>
        /// <param name="message">Descriptive message explaining this exception</param>
        /// <param name="innerException">Inner Exception that caused this exception</param>
        public RecordNotFoundException(string message, Exception innerException)
            : base(message, innerException)
        { }

        /// <summary>
        /// Record Not Found Exception with an inner exception.
        /// </summary>
        /// <param name="innerException"></param>
        public RecordNotFoundException(Exception innerException)
            : base("Data Access Exception", innerException)
        { }
    }
}
