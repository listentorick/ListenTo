using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ListenTo.Shared.Interfaces.Actions
{
    public interface IActionForCommentBuilderFactory
    {
        IActionForCommentBuilder GetBuilder(ListenTo.Shared.DO.Comment comment);
    }
}
