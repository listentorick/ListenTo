using System;
using System.Data;
using System.Configuration;
using Spring.Objects.Factory.Xml;

namespace ListenTo.Core.Caching
{
    public class CacheNamespaceParser : NamespaceParserSupport
    {
        public override void Init()
        {
            RegisterObjectDefinitionParser("cache", new CacheDefinitionParser());
        }

        public override Spring.Objects.Factory.Config.IObjectDefinition ParseElement(System.Xml.XmlElement element, ParserContext parserContext)
        {
            return base.ParseElement(element, parserContext);
        }
    }
}


