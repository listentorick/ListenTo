using System;
using System.Collections.Generic;

namespace ListenTo.Shared.Interfaces.DAO
{
    /// <summary>
    /// Defines the basic functionality of a Data Access Object
    /// </summary>
    /// <typeparam name="T">The type of Domain object that will be used</typeparam>
    /// <typeparam name="ID">The type of the id / primary key for the domain object</typeparam>
    public interface IGenericDAO<T, ID>
    {
        /// <summary>
        /// Overload of GetById that compares the version with that of the same row on the database
        /// </summary>
        /// <param name="id">The identifier to use in the lookup</param>
        /// <param name="version">The version to do the comparison against</param>
        /// <returns>A record of type T, or an OptimisticLockingFailureException</returns>
        T GetById(ID id, int version);

        /// <summary>
        /// Overload of GetById that never forces a lock on a record.
        /// </summary>
        /// <param name="id">The identifier to use in the lookup</param>
        /// <returns>A record of type T</returns>
        T GetById(ID id);

        /// <summary>
        /// Retrieve an object by its identifier
        /// </summary>
        /// <param name="id">The identifier to use in the lookup</param>
        /// <param name="shouldLock">Used to force a lock on the record</param>
        /// <returns>A record of type T</returns>
        T GetById(ID id, bool shouldLock);

        /// <summary>
        /// Retrieves a list of all entities.
        /// </summary>
        /// <returns>A list of objects</returns>
        IList<T> GetAll();

        /// <summary>
        /// Retreive a list of objects based upon the values of properties in the object passed to this method
        /// </summary>
        /// <param name="exampleInstance">An instance of an object with some properties populated
        /// These populated properties will be used to find other objects with similar values
        /// </param>
        /// <param name="propertiesToExclude">A list of the objects properties that will be excluded from the query by example</param>
        /// <returns>A collection of objects of type T</returns>
        IList<T> GetByExample(T exampleInstance, params string[] propertiesToExclude);

        /// <summary>
        /// Rereives one object based upon the values of properties in the object passed to this method
        /// </summary>
        /// <param name="exampleInstance">An instance of an object with some properties populated
        /// These populated properties will be used to find another object with similar values</param>
        /// <param name="propertiesToExclude">A list of the objects properties that will be excluded from the query by example</param>
        /// <returns>An object of type T</returns>
        T GetUniqueByExample(T exampleInstance, params string[] propertiesToExclude);

        /// <summary>
        /// Saves an entity to the datastore
        /// </summary>
        /// <param name="entity">An object of type T that is to be persisted</param>
        /// <returns>The persisted version of the object</returns>
        T Save(T entity);

        /// <summary>
        /// Deletes an entity from the datastore
        /// </summary>
        /// <param name="entity">An object of type T that is to be deleted</param>
        void Delete(T entity);
    }
}
