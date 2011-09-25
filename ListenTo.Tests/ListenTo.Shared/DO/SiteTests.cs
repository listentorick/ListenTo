using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using NUnit.Framework.SyntaxHelpers;
using ListenTo.Shared.DO;

namespace Tests.ListenTo.Shared.DO
{
    [TestFixture]
    public class SiteTests
    {
        [Test]
        public void CanAddSite()
        {
            Guid id = new Guid();
            string name = "ListenToManchester";
            string url = "http://www.listentomanchester.co.uk";
            string description = "The ListenTo site for Manchester";
            
            Town town = new Town();
 
            Site site = new Site();
            site.ID = id;
            site.Name = name;
            site.Description = description;
            site.URL = url;
            site.TownsRepresented.Add(town);

            Assert.That(site.ID,
               Is.EqualTo(id));
            Assert.That(site.Name,
                Is.EqualTo(name));
            Assert.That(site.Description,
                Is.EqualTo(description));
            Assert.That(site.URL,
                Is.EqualTo(url));
            Assert.That(site.TownsRepresented.Count,
                Is.EqualTo(1));
        }



    }
}
