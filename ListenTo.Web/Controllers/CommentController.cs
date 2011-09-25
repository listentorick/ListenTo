using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using ListenTo.Shared.Interfaces.Managers;
using System.Web.Mvc;
using ListenTo.Shared.DO;
using ListenTo.Web.ModelBinders;
using ListenTo.Web.Security;
using ListenTo.Shared.Validation;
using ListenTo.Web.Helpers;

namespace ListenTo.Web.Controllers
{
    public class CommentController : ListenToController
    {
        public ICommentManager CommentManager { get; set; }
        public IValidationHelper CommentValidationHelper { get; set; }

        [Authorize]
        [AcceptVerbs("POST")]
        [ValidateInput(false)]  
        public ActionResult Add([CommentBinderAttribute]Comment comment)
        {
            IListenToUser user = (IListenToUser)this.HttpContext.User;

            //Perform the validation
            ValidationStateDictionary vsd = CommentValidationHelper.Validate(comment, user.UserCredentials);
           // vsd.AddToModelState(ViewData.ModelState);

            if (ViewData.ModelState.IsValid)
            {
                CommentManager.Save(comment, user.UserCredentials);
                return ReturnToUrl();
            }

            return View();
        }

    }
}
