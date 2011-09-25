using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.DO;

namespace ListenTo.Tests.Shared
{
    public static class GigHelpers
    {
        public static Gig ConstructGig(DateTime startDate, DateTime? endDate)
        {
            if (endDate == null) endDate = startDate;
            Guid gigId = Guid.NewGuid();
            Gig gig = new Gig();
            gig.ID = gigId;
            gig.StartDate = (DateTime)startDate;
            gig.EndDate = (DateTime)endDate;

            return gig;
        }

        public static IList<Gig> ConstructGigs(int nGigs, DateTime startDate, DateTime? endDate)
        {
            IList<Gig> gigs = new List<Gig>();

            for (int i = 0; i < nGigs; i++)
            {
                gigs.Add(GigHelpers.ConstructGig(startDate, endDate));
            }

            return gigs;
        }
    }
}

