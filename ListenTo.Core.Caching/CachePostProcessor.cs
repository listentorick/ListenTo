using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Spring.Objects.Factory.Config;

namespace ListenTo.Core.Caching
{
    public class CachePostProcessor : IObjectFactoryPostProcessor  
    {
        private CacheDefinition _cacheDefiniton;
        public CacheDefinition CacheDefinition { get; set; }

        #region IObjectFactoryPostProcessor Members

        public void PostProcessObjectFactory(IConfigurableListableObjectFactory factory)
        {
            throw new NotImplementedException();
        }

        #endregion
    }
}
