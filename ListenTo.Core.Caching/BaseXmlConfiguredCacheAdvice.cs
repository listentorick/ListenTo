using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AopAlliance.Intercept;
using Spring.Caching;
using Spring.Aspects.Cache;
using Spring.Context;
using System.Collections;
using System.Reflection;

namespace ListenTo.Core.Caching
{
    public class BaseXmlConfiguredCacheAdvice : IApplicationContextAware
    {
        public CacheDefinition CacheDefinition { get; set; }

        private IApplicationContext applicationContext;

        /// <summary>
        /// Sets the <see cref="Spring.Context.IApplicationContext"/> that this
        /// object runs in.
        /// </summary>
        public IApplicationContext ApplicationContext
        {
            set { applicationContext = value; }
        }

        /// <summary>
        /// Returns an <see cref="ICache"/> instance based on the cache name.
        /// </summary>
        /// <param name="name">The name of the cache.</param>
        /// <returns>
        /// Cache instance for the specified <paramref name="name"/> if one
        /// is registered in the application context, or <c>null</c> if it isn't.
        /// </returns>
        public ICache GetCache(string name)
        {
            return applicationContext.GetObject(name) as ICache;
        }

        public object GetObject(string name)
        {
            return applicationContext.GetObject(name);
        }

        /// <summary>
        /// Prepares variables for expression evaluation by packaging all 
        /// method arguments into a dictionary, keyed by argument name.
        /// </summary>
        /// <param name="method">
        /// Method to get parameters info from.
        /// </param>
        /// <param name="arguments">
        /// Argument values to package.
        /// </param>
        /// <returns>
        /// A dictionary containing all method arguments, keyed by method name.
        /// </returns>
        protected static IDictionary PrepareVariables(MethodInfo method, object[] arguments)
        {
            IDictionary vars = new Hashtable();

            vars[method.Name] = method;

            ParameterInfo[] parameters = method.GetParameters();
            for (int i = 0; i < parameters.Length; i++)
            {
                ParameterInfo p = parameters[i];
                vars[p.Name] = arguments[i];
            }
            return vars;
        }
    }
}
