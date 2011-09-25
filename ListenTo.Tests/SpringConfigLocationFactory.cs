using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Tests
{
    public class SpringConfigLocationFactory
    {
        /// <summary>
        /// Returns a string array of Spring XML config files.  This should be maintained to 
        /// reflect what is in App.config/spring/context.
        /// </summary>
        /// <returns></returns>
        public static string[] GetConfigLocations()
        {
            return new String[] { 
                "file://../../../ListenTo.Web/SpringConfig/Spring.xml"
            };
        }
    }
}
