using System;
using System.Text.RegularExpressions;
using System.Xml;
using Spring.Objects.Factory.Support;
using Spring.Objects.Factory.Xml;
using Spring.Util;
using System.Collections.Generic;
using Spring.Objects.Factory.Config;
using Spring.Aop.Framework.AutoProxy;


namespace ListenTo.Core.Caching
{
    public class CacheDefinitionParser : AbstractObjectDefinitionParser
    {
        protected override AbstractObjectDefinition ParseInternal(XmlElement element, ParserContext parserContext)
        {
            //Build our representation of the cacheDefinition
            CacheDefinition cacheDefinition = new CacheDefinition();
            cacheDefinition.Objects = new List<Object>();

            XmlNodeList objects = element.ChildNodes;
            XmlAttribute resetsCache;
            XmlAttribute storesInCache;
            ObjectDefinition obj;
            MethodDefinition methodDef;
            foreach (XmlNode xmlNodeObj in objects)
            {
                obj = new ObjectDefinition();
                obj.Target = xmlNodeObj.Attributes["target"].Value;
                obj.MethodDefinitions = new List<MethodDefinition>();

                foreach (XmlNode xmlNodeMethod in xmlNodeObj.ChildNodes)
                {
                    methodDef = new MethodDefinition();
                    methodDef.Name = xmlNodeMethod.Attributes["name"].Value;
                    methodDef.Key = xmlNodeMethod.Attributes["key"].Value;
                   
                    storesInCache = xmlNodeMethod.Attributes["storeInCaches"];
                    if (storesInCache != null && storesInCache.Value!=string.Empty)
                    {
                        methodDef.StoresInCache = storesInCache.Value;
                    }

                    resetsCache = xmlNodeMethod.Attributes["resetsCache"];
                    if (resetsCache!=null && resetsCache.Value != string.Empty)
                    {
                        methodDef.ResetsCache = resetsCache.Value.Split(new char[',']);
                    }

                    obj.MethodDefinitions.Add(methodDef);
                }
                cacheDefinition.Objects.Add(obj);
            }


            ObjectDefinitionBuilder interceptorBuilder =
                   ObjectDefinitionBuilder.RootObjectDefinition(parserContext.ReaderContext.ObjectDefinitionFactory,
                                                                typeof(XmlConfiguredCacheResultAdvice));

            interceptorBuilder.AddPropertyValue("CacheDefinition", cacheDefinition);

   
            parserContext.Registry.RegisterObjectDefinition("CacheInterceptor", interceptorBuilder.ObjectDefinition);

            ObjectDefinitionBuilder proxyBuilder =
                    ObjectDefinitionBuilder.RootObjectDefinition(parserContext.ReaderContext.ObjectDefinitionFactory,
                                                                 typeof(ObjectNameAutoProxyCreator));
       
            List<string> objectNames = new List<string>();
            List<string> interceptorNames = new List<string>();

            interceptorNames.Add("CacheInterceptor");

            proxyBuilder.AddPropertyValue("InterceptorNames", interceptorNames);

            foreach(ObjectDefinition objectDefinition in cacheDefinition.Objects){
                objectNames.Add(objectDefinition.Target);
            }

            proxyBuilder.AddPropertyValue("ObjectNames", objectNames);

            return proxyBuilder.ObjectDefinition;
        }

        protected override bool ShouldGenerateIdAsFallback
        {
            get { return true; }
        }
    }
}
