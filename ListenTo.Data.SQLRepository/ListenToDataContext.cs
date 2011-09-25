using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace ListenTo.Data.LinqToSQL
{

    public partial class ListenToDataContext : System.Data.Linq.DataContext
    {
        public ListenToDataContext()
            : base(System.Configuration.ConfigurationManager.ConnectionStrings["ListenToConnectionString"].ConnectionString)
        {
        }


        [Function(Name = "NEWID", IsComposable = true)]
        public Guid Random()
        { // to prove not used by our C# code... 
            throw new NotImplementedException();
        }
     

    }
}
