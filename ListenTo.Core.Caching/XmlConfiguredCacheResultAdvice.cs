using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AopAlliance.Intercept;
using System.Collections;
using Spring.Aop.Framework.DynamicProxy;
using Spring.Caching;
using Spring.Expressions;
using System.IO;

namespace ListenTo.Core.Caching
{
    public class XmlConfiguredCacheResultAdvice: BaseXmlConfiguredCacheAdvice, IMethodInterceptor
    {
        #region IMethodInterceptor Members


        public string GenerateKey(IMethodInvocation invocation){
            return invocation.Method.Name;
        }


        public object Invoke(IMethodInvocation invocation)
        {

            ObjectDefinition objDefinition = GetObjectDefinitonToAdvise(invocation.Target);

            bool requiresInvoke = true;

            object result = null;

            if (objDefinition != null)
            {
                MethodDefinition methodDefinition = GetMethodDefinition(objDefinition, invocation.Method.Name);

                if (methodDefinition != null)
                {

                    IDictionary vars = PrepareVariables(invocation.Method, invocation.Arguments);

                    object key = methodDefinition.KeyExpression.GetValue(null, vars);

                    //do we need to set any caches?
                    ICache cacheToReset = null;
                    if (methodDefinition.ResetsCache != null)
                    {
                        foreach (string cacheName in methodDefinition.ResetsCache)
                        {
                            cacheToReset = this.GetCache(cacheName);
                            cacheToReset.Clear();
                        }
                    }
                    
                    ICache cache = GetResultCacheForMethod(methodDefinition);

                    if (cache != null)
                    {
                        result = cache.Get(key);

                        if (result == null)
                        {
                            result = invocation.Proceed();
                            cache.Insert(key, result);
                        }

                        requiresInvoke = false;
                    }

                }
            }

            if (requiresInvoke)
            {
                result = invocation.Proceed();
            }

            return result;

        }

        private Dictionary<object, string> _objectsToAdvise;

        public ICache GetResultCacheForMethod(MethodDefinition methodDefinition)
        {
            string cacheName = methodDefinition.StoresInCache;
            return this.GetCache(cacheName);
        }

        public MethodDefinition GetMethodDefinition(ObjectDefinition objectDefinition, string method)
        {
            MethodDefinition result = null;
            foreach (MethodDefinition methodDefinition in objectDefinition.MethodDefinitions)
            {
                if (methodDefinition.Name == method)
                {
                    result = methodDefinition;
                    break;
                }
            }

            return result;
        }

        public ObjectDefinition GetObjectDefinitonToAdvise(object target)
        {
            ObjectDefinition result = null;
            object objectFromContext = null;
            if (this._objectsToAdvise == null)
            {
                this._objectsToAdvise = new Dictionary<object, string>();
                
                foreach(ObjectDefinition obj in this.CacheDefinition.Objects){

                    BaseCompositionAopProxy proxy = (BaseCompositionAopProxy)this.GetObject(obj.Target);
                    objectFromContext = proxy.m_targetSourceWrapper.GetTarget();

                    this._objectsToAdvise[proxy.m_targetSourceWrapper.GetTarget()] = obj.Target;
                }
            }

            string objectId = this._objectsToAdvise[target];

            foreach (ObjectDefinition objDefinition in this.CacheDefinition.Objects)
            {
                if (objDefinition.Target == objectId)
                {
                    result = objDefinition;
                    break;
                }
            }

            return result;
        }

        #endregion
    }
}
