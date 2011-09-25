using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Spring.Expressions;

namespace ListenTo.Core.Caching
{
    public class MethodDefinition
    {
        public string Name { get; set; }
        public string StoresInCache { get; set; }
        public string[] ResetsCache { get; set; }

        private string key;
        private IExpression keyExpression;

        /// <summary>
        /// Gets or sets a SpEL expression that should be evaluated in order 
        /// to determine the cache key for the item.
        /// </summary>
        /// <value>
        /// An expression string that should be evaluated in order to determine
        /// the cache key for the item.
        /// </value>
        public string Key
        {
            get { return key; }
            set
            {
                key = value;
                keyExpression = Expression.Parse(value);
            }
        }

        /// <summary>
        /// Gets an expression instance that should be evaluated in order 
        /// to determine the cache key for the item.
        /// </summary>
        /// <value>
        /// An expression instance that should be evaluated in order to determine
        /// the cache key for the item.
        /// </value>
        public IExpression KeyExpression
        {
            get { return keyExpression; }
        }

    }
}
