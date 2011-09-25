using System;
using System.Collections.Generic;
using System.Text;

namespace ListenTo.Shared.Exceptions
{
    /// <summary>
    /// This Exception represents a General Exception. 
    /// </summary>
    [Serializable]
    public class ListenToException : ApplicationException
    {
        /// <summary>
        /// Constructor for a SmartAgent Exception
        /// </summary>
        public ListenToException()
            : base()
        {
        }

        /// <summary>
        /// Constructor for ListenTo Exception
        /// </summary>
        /// <param name="message">Message describing the exception</param>
        /// <param name="innerException">Original Exception that cause this Exception</param>
        public ListenToException(string message,Exception innerException) 
            : base(message , innerException)
        {
        }

        /// <summary>
        /// Constructor for ListenTo Exception
        /// </summary>
        /// <param name="innerException">Original Exception that cause this Exception</param>
        public ListenToException(Exception innerException)
            : base("An Exception occurred in ListenTo",innerException)
        {
        }

        /// <summary>
        /// Constructor for ListenTo Exception
        /// </summary>
        /// <param name="message">Message describing the exception</param>
        public ListenToException(string message)
            : base(message)
        {
        }
    }
}
