

using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Exceptions
{
    /// <summary>
    /// Represents an error that occurred with in the Data Access Layer of ListenTo
    /// </summary>
    [Serializable]
    public class OptimisticLockingFailureException : ListenToException
    {
        /// <summary>
        /// Default Optimistic Locking Failure Exception
        /// </summary>
        public OptimisticLockingFailureException()
            : base()
        {
        }

        /// <summary>
        /// Optimistic Locking Failure Exception with a descriptive message
        /// </summary>
        /// <param name="message">Descriptive message explaining this exception</param>
        public OptimisticLockingFailureException(string message)
            : this(message, null)
        { }

        /// <summary>
        /// Optimistic Locking Failure Exception with a descriptive message and an inner exception.
        /// </summary>
        /// <param name="message">Descriptive message explaining this exception</param>
        /// <param name="innerException">Inner Exception that caused this exception</param>
        public OptimisticLockingFailureException(string message, Exception innerException)
            : base(message, innerException)
        { }

        /// <summary>
        /// Optimistic Locking Failure Exception with an inner exception.
        /// </summary>
        /// <param name="innerException"></param>
        public OptimisticLockingFailureException(Exception innerException)
            : base("Data Access Exception", innerException)
        { }

        /// <summary>
        /// Optimistic Locking Failure Exception with a descriptive message and an inner exception.
        /// </summary>
        /// <param name="message">Descriptive message explaining this exception</param>
        /// <param name="innerException">Inner Exception that caused this exception</param>
        public OptimisticLockingFailureException(int version, int actualVersion)
            : base("Versions out of phase")
        { }


    }
}
