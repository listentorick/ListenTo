using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;

namespace ListenTo.Shared.Interfaces.Managers
{
    public interface IStyleManager : IManager<Style>
    {
        IList<Style> GetStyles();
        IList<StyleSummary> GetStyleSummaries(Guid siteId);
        Style GetStyleWithName(string name);
    }
}
