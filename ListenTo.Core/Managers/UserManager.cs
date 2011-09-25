using System;
using System.Collections.Generic;
using System.Text;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Shared.Interfaces.DO;
using ListenTo.Shared.Interfaces.Repository;
using ListenTo.Shared.Utility;
using ListenTo.Shared.RepositoryFilters;
using System.Linq;
using ListenTo.Shared.Interfaces.Mail;
using ListenTo.Shared.Validation;
using ListenTo.Shared.Enums;


namespace ListenTo.Core.Managers
{
    public class UserManager: BaseManager, IUserManager
    {

        public IUserApprovalStrategy UserApprovalStrategy { get; set; }
        public IRetrieveDetailsStrategy RetrieveDetailsStrategy {get;set;}
        public IActionsManager ActionsManager { get; set; }

        #region IUserManager Members

        /// <summary>
        /// Is this a Valid user..
        /// </summary>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public bool ValidateUser(string username, string password)
        {
            User user = Repository.GetUsers().WithUsername(username).WithPassword(password).IsValidated().SingleOrDefault();
            return user!=null; 
        }

        /// <summary>
        /// Approves the user for login
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public bool Approve(string key)
        {
            bool approved = false;
            User user = UserApprovalStrategy.Approve(key);
            if (user != null && user.IsValidated == true)
            {
                approved = true;
                this.Repository.SaveUser(user);

                //Add action....
                ListenTo.Shared.DO.Action action = new ListenTo.Shared.DO.Action();
                action.ActionType = ActionType.JOINED;
                action.ContentType = ContentType.USER;
                action.ContentID = user.ID;
                action.OwnerID = user.ID;
                ActionsManager.AddAction(action, null);

            }

            return approved;
        }

        public void RetrieveDetailsFromEmailAddress(string emailAddress, UserCredentials userCredentials) {
        
            //Does this user already exist?
            User preExistinUser = Repository.GetUsers().WithEmailAddress(emailAddress).SingleOrDefault();

            if(preExistinUser!=null){
                RetrieveDetailsStrategy.RetrieveDetails(preExistinUser);
            }
        
        }

        public void NewUserStrategy(IDO dO, UserCredentials userCredentials)
        {

            User userDO = (User)dO;

            //This will throw an exception if the data model is invalid. 
            bool isValid = ValidationRunner.Validate(userDO, userCredentials);
            

            //Does this user already exist?
            User preExistinUser = Repository.GetUsers().WithID(userDO.ID).SingleOrDefault();

            if (preExistinUser == null)
            {
                //This user is new. It cannot be validated, so if the validation flag is set to true, reset it
                userDO.IsValidated = false;
                //Ensure we store the email address as lower case etc...
                userDO.EmailAddress = userDO.EmailAddress.ToLower().Trim();
                //Persist the user
                Repository.SaveUser(userDO);



                //Send the request for validation email
                UserApprovalStrategy.RequestApproval(userDO);
            }
            else
            {
                throw new Exception("This user is NOT new and cannot be handled by HandleNewUserProcess");
            }
        }

        public User GetUserByUsername(string username)
        {
            return this.Repository.GetUsers().WithUsername(username).SingleOrDefault();
        }

        public User GetUserByEmailAddress(string emailAddress)
        {
            return this.Repository.GetUsers().WithEmailAddress(emailAddress).SingleOrDefault();
        }

        #endregion

        #region IManager<User> Members

        public User GetByID(Guid id)
        {
            return this.Repository.GetUsers().WithID(id).SingleOrDefault();
        }

        public User Save(IDO dO, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        public void Delete(Guid id, UserCredentials userCredentials)
        {
            throw new NotImplementedException();
        }

        #endregion

    }
}
