using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ListenTo.Shared.Interfaces.Repository;
using System.Web;
using System.Runtime.Remoting.Messaging;

namespace ListenTo.Data.LinqToSQL
{
    public class RequestScopedLinqToSQLRepositoryFactory:IRepositoryFactory
    {

        protected const string RepositoryCacheKey = "RepositoryCacheKey";

        public IRepository GetRepository()
        {
            LinqToSQLRepository repository = null;

            if(HttpContext.Current!=null) {
            
                repository = (LinqToSQLRepository)HttpContext.Current.Items[RepositoryCacheKey];

            } else {

                repository = (LinqToSQLRepository)CallContext.GetData(RepositoryCacheKey);
            }         

            if (repository == null)
            {
                repository = new LinqToSQLRepository();
                repository.DBContext = new ListenToDataContext();
                
                 if(HttpContext.Current!=null) {
                    HttpContext.Current.Items[RepositoryCacheKey] = repository;
                 } else {
                    CallContext.SetData(RepositoryCacheKey,repository);
                 }
                
            }

            return repository;

        }

    }
}
