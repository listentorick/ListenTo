using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Spring.Testing.NUnit;

namespace Tests
{
    /// <summary>
    /// Implements <see cref="AbstractTransactionalDbProviderSpringContextTests" /> in order to have
    /// the Spring.NET context loaded only once, to have dependencies injected "byType," and, most 
    /// importantly, to wrap each test in a transaction to provide a persistent <see cref="ISession" /> 
    /// and to roll-back the transaction when the test has completed.
    /// </summary>
    public class AbstractDaoTests : AbstractTransactionalDbProviderSpringContextTests
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
