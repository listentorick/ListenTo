using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Exceptions
{
    /// <summary>
    /// Represents an error that occurred with in the Data Access Layer of ListenTo
    /// </summary>
    [Serializable]
    public class DataAccessException : ListenToException
    {
        /// <summary>
        /// Default Data Access Exception
        /// </summary>
        public DataAccessException()
            : base()
        {
        }

        /// <summary>
        /// Data Access Exception with a descriptive message
        /// </summary>
        /// <param name="message">Descriptive message explaining this exception</param>
        public DataAccessException(string message)
            : this(message, null)
        { }

        /// <summary>
        /// Data Access Exception with a descriptive message and an inner exception.
        /// </summary>
        /// <param name="message">Descriptive message explaining this exception</param>
        /// <param name="innerException">Inner Exception that caused this exception</param>
        public DataAccessException(string message, Exception innerException)
            : base(message, innerException)
        { }

        /// <summary>
        /// Data Access Exception with an inner exception.
        /// </summary>
        /// <param name="innerException"></param>
        public DataAccessException(Exception innerException)
            : base("Data Access Exception", innerException)
        { }
    }
}
