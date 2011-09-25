using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Spring.Testing.NUnit;

namespace Tests
{
    /// <summary>
    /// Implements <see cref="AbstractDependencyInjectionSpringContextTests" /> in order to have
    /// the Spring.NET context loaded only once and to have dependencies injected "byType."  In 
    /// addition to convenience and fewer string references to maintain, this greatly reduces the 
    /// time necessary to run a large number of tests in a fixture.
    /// </summary>
    public class AbstractIocSupportedTests : AbstractDependencyInjectionSpringContextTests
    {
        protected override string[] ConfigLocations
        {
            get
            {
                return SpringConfigLocationFactory.GetConfigLocations();
            }
        }
    }
}