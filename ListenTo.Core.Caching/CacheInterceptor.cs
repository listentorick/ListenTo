using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AopAlliance.Intercept;
using Spring.Caching;
using Spring.Aspects.Cache;

namespace ListenTo.Core.Caching
{
    public class CacheInterceptor : BaseCacheAdvice, IMethodInterceptor
    {
        public CacheDefinition CacheDefinition { get; set; }

        #region IMethodInterceptor Members

        public object Invoke(IMethodInvocation invocation)
        {
            //throw new NotImplementedException();
            return null;
        }

        #endregion
    }
}
