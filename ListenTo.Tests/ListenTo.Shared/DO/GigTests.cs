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
    public class GigTests
    {
        [Test]
        public void CanAddGig()
        {
            Guid gigId = new Guid();
            string gigName = "Seizures first gig";
            string gigDescription = "Seizures play their first gig in Manchester!";
            DateTime startDate = new DateTime();
            DateTime endDate = new DateTime();
            string gigTicketPrice = "£6";
           
            Guid actId = new Guid();
            string actName = "Seizures";
            
            Act act = new Act();
            act.ID = actId;
            act.Name = actName;

            Gig gig             = new Gig();
            gig.ID              = gigId;
            gig.Name            = gigName;
            gig.Description     = gigDescription;
            gig.StartDate       = startDate;
            gig.EndDate         = endDate;
            gig.TicketPrice     = gigTicketPrice;
            gig.Acts.Add(act);

            Assert.That(gig.ID,
               Is.EqualTo(gigId));
            Assert.That(gig.Name,
                Is.EqualTo(gigName));
            Assert.That(gig.Description,
                Is.EqualTo(gigDescription));
            Assert.That(gig.StartDate,
                Is.EqualTo(startDate));
            Assert.That(gig.EndDate,
                Is.EqualTo(endDate));
            Assert.That(gig.TicketPrice,
                Is.EqualTo(gigTicketPrice));
            Assert.That(gig.Acts.Count,
                Is.EqualTo(1));
        }

    }
}
