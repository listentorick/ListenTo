using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.Web.UI;
using ListenTo.Web.Security;
using ListenTo.Web.ModelBinders;
using ListenTo.Shared.DO;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Web.Helpers;
using ListenTo.Shared.Validation;
using ListenTo.Web.Models;
using ListenTo.Shared.Interfaces.Do;

namespace ListenTo.Web.Controllers
{

    [HandleError]
    [OutputCache(Location = OutputCacheLocation.None)]
    public class AccountController : ListenToController
    {
        public INewsItemManager NewsItemManager { get; set; }

        #region Properties

        public IFormsAuthentication FormsAuth
        {
            get;
            set;
        }

        public MembershipProvider Provider
        {
            get;
            set;
        }

        public IValidationHelper UserValidationHelper 
        { 
            get; 
            set; 
        }

        public IUserManager UserManager
        {
            get;
            set;
        }

        public IActionsManager ActionsManager
        {
            get;
            set;
        }

        public ITrackManager TrackManager
        {
            get;
            set;
        }

        public ICommentManager CommentManager
        {
            get;
            set;
        }


        public IRelationshipManager RelationshipManager
        {
            get;
            set;
        }

        #endregion


        [AcceptVerbs("GET")]
        public ActionResult RetrieveDetails()
        {
            return View();
        }


        [AcceptVerbs("POST")]
        public ActionResult DetailsRetrieved(string emailAddress)
        {
            //Note that we need to define a standard system user. 
            //The credentials belonging to this user will be passed around for non authenticated actions
            this.UserManager.RetrieveDetailsFromEmailAddress(emailAddress, new UserCredentials());
            return View();
        }

        private bool Login(string username, string password)
        {
            bool loginSuccessful = false;

            if (username.Trim() != string.Empty && 
                password.Trim() != string.Empty &&
                Provider.ValidateUser(username, password))
            {

                loginSuccessful = true;

                    MembershipUser user = Provider.GetUser(username, false);
                    string userId = ((Guid)user.ProviderUserKey).ToString();

                    FormsAuthenticationTicket authTicket = new FormsAuthenticationTicket(
                       1, username,
                       DateTime.Now,
                       DateTime.Now.AddMinutes(60),
                       false,
                       userId
                    );

                    string encTicket = FormsAuthentication.Encrypt(authTicket);
                    HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encTicket);
                    this.Response.Cookies.Add(authCookie);

                    //Set the user for the remains of the request...
                    IListenToUser userPrincipal = new ListenToUser(user, UserManager);
                    //this.User = user;
                    this.HttpContext.User = userPrincipal;
                }

                return loginSuccessful;
        }

        public JsonResult AjaxLogin(string username, string password)
        {
            return Json(Login(username, password));
        }

        [AcceptVerbs("GET")]
        public ActionResult Login()
        {
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs("GET")]
        public ActionResult UserContent(string username)
        {
            UserProfile userProfile = UserProfileManager.GetByUsername(username);
            RedirectUserIfAccessDenied(userProfile);

            UserContentViewModel userContentViewModel = new UserContentViewModel();
            userContentViewModel.UserProfile = userProfile;
            userContentViewModel.ArtistSummaries = ArtistManager.GetArtistSummariesByOwner(10, 0, userProfile.ID);
            userContentViewModel.NewsItemSummaries = NewsItemManager.GetNewsItemSummariesByOwner(10,0,userProfile.ID);
            return View(userContentViewModel);
        }

        [ValidateInput(false)]
        [AcceptVerbs("POST")]
        public ActionResult Login(string username, string password, bool? rememberMe)
        {

            // Basic parameter validation
            List<string> errors = new List<string>();

            if (String.IsNullOrEmpty(username))
            {
                this.ModelState.AddModelError("username", "You must specify a username.");  
            }

            if (String.IsNullOrEmpty(password))
            {
                this.ModelState.AddModelError("password", "You must specify a password.");
            }


            if (errors.Count == 0)
            {

                // Attempt to login
                bool loginSuccessful = Provider.ValidateUser(username, password);

                if (loginSuccessful)
                {
                    MembershipUser user = Provider.GetUser(username, false);
                    string userId = ((Guid)user.ProviderUserKey).ToString();

                    FormsAuthenticationTicket authTicket = new FormsAuthenticationTicket(
                       1, username,
                       DateTime.Now, 
                       DateTime.Now.AddMinutes(60),
                       false,
                       userId
                    );

                    string encTicket = FormsAuthentication.Encrypt(authTicket);
                    HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encTicket);
                    this.Response.Cookies.Add(authCookie);

                    //Set the user for the remains of the request...
                    IListenToUser userPrincipal = new ListenToUser(user,UserManager);
                    //this.User = user;
                    this.HttpContext.User = userPrincipal;

                    return ReturnToUrl();

                }
                else
                {
                    this.ModelState.AddModelError("username", "The username or password provided is incorrect.");
                }
            }
             
            // If we got this far, something failed, redisplay form
            ViewData["username"] = username;
            return View();
        }

        public ActionResult Logout()
        {
            FormsAuth.SignOut();
            return RedirectToAction("Index", "Home");
        }

        [AcceptVerbs("GET")]
        public ActionResult Register()
        {
            RegisterUserViewModel registerUserViewModel = new RegisterUserViewModel();
            //registerUserViewModel.RecievesNewsletter = true;
            return View(registerUserViewModel);
        }

        [ValidateInput(false)]
        [AcceptVerbs("POST")]
        public ActionResult Register(RegisterUserViewModel registerUserViewModel)
        {

            if (registerUserViewModel.Password != registerUserViewModel.Password)
            {
                ViewData.ModelState.AddModelBinderValidationError("ConfirmPassword", ModelBinderValidationStateKeys.USER_PASSWORDS_DONT_MATCH);
            }

            if (registerUserViewModel.EmailAddress != registerUserViewModel.ConfirmEmailAddress)
            {
                ViewData.ModelState.AddModelBinderValidationError("ConfirmEmailAddress", ModelBinderValidationStateKeys.USER_EMAILS_DONT_MATCH);
            }

            if (registerUserViewModel.Policy == false)
            {
                ViewData.ModelState.AddModelBinderValidationError("Policy", ModelBinderValidationStateKeys.POLICY_NOT_APPROVED);
            }

            try
            {
                MembershipCreateStatus createStatus;
                MembershipUser newUser = Provider.CreateUser(registerUserViewModel.Username, registerUserViewModel.Password, registerUserViewModel.EmailAddress, null, null, false, null, out createStatus);

                //Load the users profile based upon the new username
                UserProfile userProfile = UserProfileManager.GetByUsername(registerUserViewModel.Username);
                userProfile.RecievesNewsletter = registerUserViewModel.RecievesNewsletter;

                //Temporary hack... set the users default town to Manchester...
                //All users need this until they have adjusted their profile...
                userProfile.Town = TownManager.GetByID(new Guid("0D5A3A81-53C1-48B0-B176-A419ACBB2EE8"));
                
                //Woops we dont actually have any usercredentials at this point...
                //clearly we need a system account...
                UserProfileManager.Save(userProfile, new UserCredentials());

                //Not sure what to do with the MembershipCreateStatus at this point. Really dont like microsofts design here...
            }
            catch (ValidationException e)
            {
                e.AddToModelState(ViewData.ModelState);
                return View(registerUserViewModel);
            }
          
            return RedirectToUserRegistered(registerUserViewModel.Username);
        }

        [AcceptVerbs("GET")]
        public ActionResult Approve(string validationId)
        {
            this.UserManager.Approve(validationId);
            return View();
        }

        public ActionResult Registered()
        {
            return View();
        }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult WhatsNew(string username)
        {
            UserProfile userProfile = UserProfileManager.GetByUsername(username);
            RedirectUserIfAccessDenied(userProfile);

            IListenToUser user = (IListenToUser)this.HttpContext.User;
            
            AccountWhatsNewViewModel accountWhatsNewViewModel = new AccountWhatsNewViewModel();
            accountWhatsNewViewModel.UserProfile = userProfile;
            accountWhatsNewViewModel.LatestActions = ActionsManager.GetLatestActionsForSite(10, 0, this.GetSite().ID);
            accountWhatsNewViewModel.UpcomingGigs = GigManager.GetNRandomGigsBySiteAfterDate(3, this.GetSite().ID, DateTime.Now);
            accountWhatsNewViewModel.LatestTracks = TrackManager.GetTrackSummariesForSite(3, 0, this.GetSite().ID);
            accountWhatsNewViewModel.UserProfileComments = CommentManager.GetCommentSummaries(10, 0, userProfile.ID);
            accountWhatsNewViewModel.BandsLikedPartialViewModel = new BandsLikedPartialViewModel();
            accountWhatsNewViewModel.BandsLikedPartialViewModel.ArtistFanRelationshipSummaries = RelationshipManager.GetArtistFanRelationshipSummaryForUser(user.UserCredentials, 10, 0, userProfile.ID);
            accountWhatsNewViewModel.BandsLikedPartialViewModel.NumberPerRow = 5;
            accountWhatsNewViewModel.AddCommentViewModel = new AddCommentViewModel();
            accountWhatsNewViewModel.AddCommentViewModel.ContentTargetId = userProfile.ID;
            accountWhatsNewViewModel.AddCommentViewModel.ContentType = ListenTo.Shared.Enums.ContentType.USERPROFILE;
            return View(accountWhatsNewViewModel);
        }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult EditProfile(Guid id)
        {
            UserProfile userProfile = UserProfileManager.GetByID(id);
            RedirectUserIfAccessDenied(userProfile);

            EditProfileViewModel editProfileViewModel = new EditProfileViewModel();
            editProfileViewModel.UserProfile = userProfile;
            editProfileViewModel.StyleSummaries = StyleManager.GetStyleSummaries(this.GetSite().ID);

            editProfileViewModel.UploadImagePopupViewModel = new UploadImagePopupViewModel();
            editProfileViewModel.UploadImagePopupViewModel.ImageMetaData = userProfile.ProfileImage;

            return View(editProfileViewModel);
        }

        [Authorize]
        [AcceptVerbs("POST")]
        [ValidateInput(false)]
        public ActionResult EditProfile(Guid id, FormCollection form)
        {
            UserProfile userProfile = UserProfileManager.GetByID(id);
            UpdateModel<UserProfile>(userProfile, "UserProfile");

            //This object represents a file the user has uploaded...
            UploadFilePartialViewModel file = new UploadFilePartialViewModel();
            UpdateModel<UploadFilePartialViewModel>(file);

            UploadImagePopupViewModel uploadImagePopupViewModel = new UploadImagePopupViewModel();
            UpdateModel<UploadImagePopupViewModel>(uploadImagePopupViewModel);

            if (uploadImagePopupViewModel.ImageMetaData != null)
            {
                userProfile.ProfileImage = uploadImagePopupViewModel.ImageMetaData;
            }

            //Here we can implement the specifics of handling our file...
            IListenToUser user = (IListenToUser)this.HttpContext.User;

            try
            {
                UserProfileManager.Save(userProfile, user.UserCredentials);
            }
            catch (ValidationException e)
            {
                e.AddToModelState(ViewData.ModelState, "UserProfile");
            }

            //If the model isnt valid
            if (!ViewData.ModelState.IsValid)
            {
                EditProfileViewModel editProfileViewModel = new EditProfileViewModel();
                editProfileViewModel.UserProfile = userProfile;
                editProfileViewModel.StyleSummaries = StyleManager.GetStyleSummaries(this.GetSite().ID);

                return View(editProfileViewModel);
            }

            return RedirectToWhoIs(userProfile);  

        }

        [Authorize]
        [AcceptVerbs("GET")]
        public ActionResult Profile(string username)
        {
            UserProfile userProfile = UserProfileManager.GetByUsername(username); 
            RedirectUserIfAccessDenied(userProfile);

            IListenToUser user = (IListenToUser)this.HttpContext.User;

            AccountProfileViewModel accountProfileViewModel = new AccountProfileViewModel();
            accountProfileViewModel.UserProfile = userProfile;

            return View(accountProfileViewModel);
        }

    }


}
