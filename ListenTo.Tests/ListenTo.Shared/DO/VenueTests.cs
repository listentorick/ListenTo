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
    public class VenueTests
    {
        [Test]
        public void CanAddVenue()
        {
            Guid id = new Guid();
            string name = "NightnDay";
            string url = "http://www.nightnday.org/";
            string description = "The heart and soul of Manchesters music scene.";
            string telephone = "0161 236 4597";

            Town town = new Town();

            Venue venue = new Venue();
            venue.ID = id;
            venue.Name = name;
            venue.Description = description;
            venue.URL = url;
            venue.Telephone = telephone;
            venue.Town = town;

            Assert.That(venue.ID,
               Is.EqualTo(id));
            Assert.That(venue.Name,
                Is.EqualTo(name));
            Assert.That(venue.Description,
                Is.EqualTo(description));
            Assert.That(venue.Town,
                Is.EqualTo(town));
            Assert.That(venue.URL,
                Is.EqualTo(url));
            Assert.That(venue.Town,
                Is.EqualTo(town));
        }


    }
}
