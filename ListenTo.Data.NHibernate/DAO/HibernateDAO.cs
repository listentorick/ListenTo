
using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using Hibernate = NHibernate;
using NHibernate.Expression;
using NHibernate.Metadata;
using ListenTo.Shared.Exceptions;

namespace ListenTo.Shared.Interfaces.DAO
{
    /// <summary>
    ///  A basic DAO implementation that has all the functionality of a Generic-Typed
    ///  DAO - Magic.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <typeparam name="ID"></typeparam>
    public abstract class HibernateDAO<T, ID> :
        Spring.Data.NHibernate.Generic.Support.HibernateDaoSupport,
        ListenTo.Shared.Interfaces.DAO.IGenericDAO<T, ID>
    {
        // Make a note of the type of this Generic class, this'll definately come in handy!
        private Type persistentType = typeof(T);

        /// <summary>
        /// A Generic approach to using arbritary criteria for querying the Hibernate objects.
        /// </summary>
        /// <param name="listObjects"></param>
        /// <returns>A Strongly Typed list of Objects returned by the criteria specified</returns>
        public virtual IList<T> GetByCriteria(params ICriterion[] criterion)
        {
            return this.HibernateTemplate.ExecuteFind<T>(new ExecuteCriterionIFindHibernateCallback<T>(persistentType, criterion), false);
        }

        public virtual IList<Object[]> ExecuteDetachedCriteria(DetachedCriteria detachedCriteria)
        {
            return (List<Object[]>)this.HibernateTemplate.ExecuteFind<Object[]>(new ExecuteDetachedCriterionCallback(detachedCriteria), true);
        }

        /// <summary>
        /// Method to Retrieve a set of entities based on a
        /// pre-defined Named query.
        /// </summary>
        /// <param name="queryName">The Named query to execute.</param>
        /// <returns>A Generic Typed List of results, empty if none found.</returns>
        protected virtual IList<T> GetAllByNamedQuery(string queryName)
        {
            try
            {
                //TODO: Check that named query exists?
                return this.HibernateTemplate.FindByNamedQuery<T>(queryName);
            }
            catch (Exception ex)
            {
                throw new DataAccessException(ex);
            }
        }

        /// <summary>
        /// Method to Retrieve a set of entities based on a
        /// pre-defined Named query.
        /// </summary>
        /// <param name="queryName">The Named query to execute.</param>
        /// <returns>A Generic Typed List of results, empty if none found.</returns>
        protected virtual IList<T> GetAllByNamedQueryAndNamedParam(string queryName, string paramName, object value)
        {
            //TODO: Check that named query exists?
            return GetAllByNamedQueryAndNamedParam(queryName, new string[] { paramName }, new object[] { value });
        }

        /// <summary>
        /// Method to Retrieve a set of entities based on a
        /// pre-defined Named query.
        /// </summary>
        /// <param name="queryName">The Named query to execute.</param>
        /// <returns>A Generic Typed List of results, empty if none found.</returns>
        protected virtual IList<T> GetAllByNamedQueryAndNamedParam(string queryName, string[] paramNames, object[] values)
        {
            //TODO: Check that named query exists?
            return this.HibernateTemplate.FindByNamedQueryAndNamedParam<T>(queryName, paramNames, values);
        }

        /// <summary>
        /// Method to Retrives a matching entity base on a pre-defined Named query
        /// </summary>
        /// <param name="queryName"The Named query to execute.></param>
        /// <param name="paramName">Parameter Name</param>
        /// <param name="value">Value or the Parameter</param>
        /// <returns></returns>
        /// <exception cref="RecordNotFoundException">Throw if no matching record is found</exception>
        protected virtual T GetUniqueByNamedQueryAndNamedParam(string queryName, string paramName, object value)
        {
            //TODO: Check that named query exists?
            return this.GetUniqueByNamedQueryAndNamedParam(queryName, new string[] { paramName }, new object[] { value });
        }

        /// <summary>
        /// Method to Retrives a matching entity base on a pre-defined Named query
        /// </summary>
        /// <param name="queryName">The Named query to execute.</param>
        /// <param name="paramNames">Parameter Names</param>
        /// <param name="values">Values of the Parameters</param>
        /// <returns></returns>
        protected virtual T GetUniqueByNamedQueryAndNamedParam(string queryName, string[] paramNames, object[] values)
        {
            IList<T> entities = this.GetAllByNamedQueryAndNamedParam(queryName, paramNames, values);
            T entity = default(T);

            if (entities.Count == 1)
            {
                entity = entities[0];
            }
            else if (entities.Count == 0)
            {
                throw new RecordNotFoundException();
            }
            else
            {
                throw new DataAccessException(
                    "Single-record result set expected - multiple records found."
                );
            }

            return entity;
        }

        #region IGenericDAO<T,ID> Members

        /// <summary>
        /// See <see cref="Numero.SmartAgent.Shared.DAO.IGenericDAO.Delete(T)"/>
        /// </summary>
        public virtual void Delete(T entity)
        {
            try
            {
                HibernateTemplate.Delete(entity);
            }
            catch (Exception ex)
            {
                throw new DataAccessException(ex);
            }
        }

        /// <summary>
        /// See <see cref="Numero.SmartAgent.Shared.DAO.IGenericDAO.GetAll()"/>
        /// </summary>
        public virtual IList<T> GetAll()
        {
            try
            {
                // Use a named query defined as TypeName.GetAll to retrieve all instances of this object.
                return GetAllByNamedQuery(persistentType.Name + ".GetAll");
            }
            catch (Exception ex)
            {
                throw new DataAccessException(ex);
            }
        }

        /// <summary>
        /// See <see cref="Numero.SmartAgent.Shared.DAO.IGenericDAO.GetByExample(T, string[])"/>
        /// </summary>
        public virtual IList<T> GetByExample(T exampleInstance, params string[] propertiesToExclude)
        {
            try
            {
                // Construct a basic QBE Hibernate Expression, setting it up to work
                // reasonably well in the default case and allowing LIKE comparisons in 
                // the string properties.
                Example example = Hibernate.Expression.Example.Create(exampleInstance)
                                                                 .IgnoreCase()
                                                                 .ExcludeNulls()
                                                                 .ExcludeZeroes()
                                                                 .EnableLike();
                if (propertiesToExclude != null)
                {
                    // Exclude any passed properties for exclusion.
                    foreach (String property in propertiesToExclude)
                    {
                        example.ExcludeProperty(property);
                    }
                }

                return GetByCriteria(example);
            }
            catch (Exception ex)
            {
                throw new DataAccessException(ex);
            }
        }

        /// <summary>
        /// See <see cref="Numero.SmartAgent.Shared.DAO.IGenericDAO.GetUniqueByExample(T, string[])"/>
        /// </summary>
        public virtual T GetUniqueByExample(T exampleInstance, params string[] propertiesToExclude)
        {
            try
            {
                IList<T> results = GetByExample(exampleInstance, propertiesToExclude);

                if (results != null && results.Count > 0)
                {
                    return results[0];
                }
                else
                {
                    return default(T);
                }
            }
            catch (Exception ex)
            {
                throw new DataAccessException(ex);
            }
        }

        /// <summary>
        /// See <see cref="Numero.SmartAgent.Shared.DAO.IGenericDAO.GetById(ID,int)"/>
        /// </summary>
        public virtual T GetById(ID id, int version)
        {
            IClassMetadata classMetadata = this.HibernateTemplate.SessionFactory.GetClassMetadata(typeof(T));
            T entity;
            try
            {
                if (classMetadata.IsVersioned)
                {
                    entity = this.GetById(id);
                    Object actualVersion = classMetadata.GetVersion(entity);
                    if ((int)actualVersion != version)
                    {
                        throw new OptimisticLockingFailureException(version, (int)actualVersion);
                    }
                }
                else
                {
                    throw new DataAccessException("Attempted version check on unversioned object.");
                }
                return entity;
            }
            catch (OptimisticLockingFailureException)
            {
                throw;
            }
            catch (RecordNotFoundException)
            {
                throw;
            }
            catch (DataAccessException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new DataAccessException(ex);
            }

        }

        /// <summary>
        /// See <see cref="Numero.SmartAgent.Shared.DAO.IGenericDAO.GetById(ID)"/>
        /// </summary>
        public virtual T GetById(ID id)
        {
            return GetById(id, false);
        }

        /// <summary>
        /// See <see cref="Numero.SmartAgent.Shared.DAO.IGenericDAO.GetById(ID,bool)"/>
        /// </summary>
        public virtual T GetById(ID id, bool shouldLock)
        {
            try
            {
                T entity;

                if (shouldLock)
                {
                    entity = HibernateTemplate.Get<T>(id, Hibernate.LockMode.Upgrade);
                }
                else
                {
                    entity = HibernateTemplate.Get<T>(id);
                }

                if (entity == null)
                {
                    throw new RecordNotFoundException(string.Format("{0} [{1}]", typeof(T).Name, id == null ? "<null>" : id.ToString()));
                }
                return entity;
            }
            catch (Hibernate.ObjectNotFoundException hex)
            {
                throw new RecordNotFoundException(hex);
            }
            catch (RecordNotFoundException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new DataAccessException(ex);
            }
        }

        /// <summary>
        /// See <see cref="Numero.SmartAgent.Shared.DAO.IGenericDAO.Save(T)"/>
        /// </summary>
        public virtual T Save(T entity)
        {
            try
            {
                HibernateTemplate.SaveOrUpdate(entity);
                HibernateTemplate.Flush();
                return entity;
            }
            catch (Exception ex)
            {
                throw new UnableToSaveException(ex);
            }
        }

        /// <summary>
        /// Does not perform a SaveOrUpdate, only a save.
        /// </summary>
        /// <param name="entity">The entity to *only* save, i.e. not update</param>
        /// <returns>The saved entity</returns>
        public virtual T JustSave(T entity)
        {
            try
            {
                HibernateTemplate.Save(entity);
                return entity;
            }
            catch (Exception ex)
            {
                throw new UnableToSaveException(ex);
            }
        }

        #endregion
    }
    #region IHibernateCallBack Implementations
    internal class ExecuteCriterionIFindHibernateCallback<T> : Spring.Data.NHibernate.Generic.IFindHibernateCallback<T>
    {
        private ICriterion[] criterion;
        private Type persistentType;
        public ExecuteCriterionIFindHibernateCallback(Type persistentType, params ICriterion[] criterion)
        {
            this.persistentType = persistentType;
            this.criterion = criterion;
        }

        /// <summary>
        /// Gets called by HibernateTemplate with an active
        /// Hibernate Session. Does not need to care about activating or closing
        /// the Session, or handling transactions.
        /// </summary>
        /// <remarks>
        /// <p>
        /// Allows for returning a result object created within the callback, i.e.
        /// a domain object or a collection of domain objects. Note that there's
        /// special support for single step actions: see HibernateTemplate.find etc.
        /// </p>
        /// </remarks>
        public IList<T> DoInHibernate(Hibernate.ISession session)
        {
            Hibernate.ICriteria criteria = session.CreateCriteria(persistentType);

            foreach (ICriterion criterium in criterion)
            {
                criteria.Add(criterium);
            }

            return criteria.List<T>();
        }
    }

    internal class ExecuteDetachedCriterionCallback : Spring.Data.NHibernate.Generic.IFindHibernateCallback<object[]>
    {
        private DetachedCriteria criterion;
        public ExecuteDetachedCriterionCallback(DetachedCriteria criterion)
        {
            this.criterion = criterion;
        }

        public IList<Object[]> DoInHibernate(Hibernate.ISession session)
        {

            Hibernate.ICriteria criteria = criterion.GetExecutableCriteria(session);
            IList resultList = criteria.List();
            IEnumerator enumerator = resultList.GetEnumerator();

            IList<Object[]> resultCollection = new List<Object[]>();

            while (enumerator.MoveNext())
            {
                Object[] row = null;
                if (enumerator.Current.GetType().IsArray)
                {
                    row = (Object[])enumerator.Current;
                }
                else
                {
                    row = new Object[] { enumerator.Current };
                }

                resultCollection.Add(row);
            }
            return resultCollection;
        }
    }

    #endregion IHibernateCallBack Implementations
}
