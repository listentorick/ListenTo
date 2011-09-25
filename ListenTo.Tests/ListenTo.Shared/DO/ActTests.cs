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
    public class ActTests
    {
        [Test]
        public void CanAddAct()
        {
            Guid id = new Guid();
            string name = "Seizures";
            Guid artistId = new Guid();

            Act act         = new Act();
            act.ID          = id;
            act.Name        = name;
            act.ArtistID    = artistId;
           
            Assert.That(act.ID,
               Is.EqualTo(id));
            Assert.That(act.Name,
                Is.EqualTo(name));
            Assert.That(act.ArtistID,
                Is.EqualTo(artistId));

        }

    }
}
