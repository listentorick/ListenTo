using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using ListenTo.Shared.Interfaces.Managers;
using ListenTo.Web.Models;
using ListenTo.Shared.Utility;
using ListenTo.Shared.DTO;
using ListenTo.Shared.DO;
using ListenTo.Web.ModelBinders;
using ListenTo.Web.Security;
using ListenTo.Shared.Validation;
using ListenTo.Web.Helpers;
using ListenTo.Shared.Interfaces.DTO;
using ListenTo.Core.Managers;

namespace ListenTo.Web.Controllers
{
    public class WhoIsController : ListenToController
    {

        public ICommentManager CommentManager { get; set; }
        public IUserProfileManager UserProfileManager { get; set; }
        public IWhatsNewManager WhatsNewManager { get; set; }
        public IActionsManager ActionsManager { get; set; }

        public IRelationshipManager RelationshipManager {get;set;}

        public ActionResult Index(string username)
        {
            WhoIsIndexViewModel whoIsIndexViewModel = new WhoIsIndexViewModel();

            //Get the Users Profile
            UserProfile userProfile = UserProfileManager.GetByUsername(username);
            whoIsIndexViewModel.UserProfile = userProfile;

            //Get the comments
            IList<CommentSummary> comments = CommentManager.GetCommentSummaries(10, 0, userProfile.ID);
            whoIsIndexViewModel.Comments = comments;

            whoIsIndexViewModel.UsersActions = ActionsManager.GetUsersLatestActions(10, 0, userProfile.ID);


            whoIsIndexViewModel.BandsLikedPartialViewModel = new BandsLikedPartialViewModel();
            whoIsIndexViewModel.BandsLikedPartialViewModel.ArtistFanRelationshipSummaries = RelationshipManager.GetArtistFanRelationshipSummaryForUser(this.GetUserCredentials(), 10, 0, userProfile.ID);
            whoIsIndexViewModel.BandsLikedPartialViewModel.NumberPerRow = 1;
            whoIsIndexViewModel.AddCommentViewModel = new AddCommentViewModel();
            whoIsIndexViewModel.AddCommentViewModel.ContentType = ListenTo.Shared.Enums.ContentType.USERPROFILE;
            whoIsIndexViewModel.AddCommentViewModel.ContentTargetId = userProfile.ID;

            return View(whoIsIndexViewModel);
        }
    }
}
