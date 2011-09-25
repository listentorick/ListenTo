<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddComment.ascx.cs" Inherits="ListenTo.Web.Views.Shared.AddComment" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>		
<%@ Import Namespace="ListenTo.Web.Helpers" %>
	
<div class="content" id="haveYourSay">
	<form method="post" enctype="multipart/form-data" action="/comment/add">
	    <h2>Have your say!</h2>
	    <fieldset>
               
                <p><label for="Body">Comment</label>
                    <%=Html.TextArea("CommentBody", null, new { @class = "expanding, " + ListenTo.Web.Constants.ViewClasses.REQUIRES_LOGIN_LAUNCH_POINT_CLASS, @rows = "10", @cols = "20" })%>
                    <%=Html.ValidationMessage(ValidationStateKeys.COMMENT_BODY_INVALID)%>
		        </p>

                 <%=Html.Hidden("TargetID", ViewData.Model.ContentTargetId)%>
                 <%=Html.Hidden("ContentType", ViewData.Model.ContentType)%>
                 <%=Html.Hidden("ReturnUrl", this.GetReturnUrl())%>

	    </fieldset>
    	
        <div class="formButtons">
	        <input type="image" class="<%=ListenTo.Web.Constants.ViewClasses.REQUIRES_LOGIN_LAUNCH_POINT_CLASS%>" id="addComment" src="/content/images/buttons/addacomment.gif" alt="Post Comment" />
	    </div>
	</form>
		
</div>
