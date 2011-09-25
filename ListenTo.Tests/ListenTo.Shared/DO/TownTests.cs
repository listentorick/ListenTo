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
    public class TownTests
    {
        [Test]
        public void CanAddTown()
        {
            Guid id = new Guid();
            string name = "Manchester";
            Site site = new Site();

            Town town = new Town();
            town.ID = id;
            town.Name = name;
            town.RepresentativeSites.Add(site);

            Assert.That(town.ID,
               Is.EqualTo(id));
            Assert.That(town.Name,
                Is.EqualTo(name));
            Assert.That(town.RepresentativeSites.Count,
                Is.EqualTo(1));

        }

    }
}
