using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Exceptions
{
    /// <summary>
    /// Represents an error that occurred with in the Data Access Layer of ListenTo
    /// </summary>
    [Serializable]
    public class UnableToSaveException : ListenToException
    {
        /// <summary>
        /// Default Unable To Save Exception
        /// </summary>
        public UnableToSaveException()
            : base()
        {
        }

        /// <summary>
        /// Unable To Save Exception with a descriptive message
        /// </summary>
        /// <param name="message">Descriptive message explaining this exception</param>
        public UnableToSaveException(string message)
            : this(message, null)
        { }

        /// <summary>
        /// Unable To Save Exception with a descriptive message and an inner exception.
        /// </summary>
        /// <param name="message">Descriptive message explaining this exception</param>
        /// <param name="innerException">Inner Exception that caused this exception</param>
        public UnableToSaveException(string message, Exception innerException)
            : base(message, innerException)
        { }

        /// <summary>
        /// Unable To Save Exception with an inner exception.
        /// </summary>
        /// <param name="innerException"></param>
        public UnableToSaveException(Exception innerException)
            : base("Data Access Exception", innerException)
        { }
    }
}
