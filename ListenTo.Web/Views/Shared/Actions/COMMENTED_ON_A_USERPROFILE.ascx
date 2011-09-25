<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.Actions.COMMENTED_ON_A_USERPROFILE" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<% 
    ListenTo.Shared.ActionData.CommentOnUserProfileActionData commentOnUserProfileActionData = ((ListenTo.Shared.ActionData.CommentOnUserProfileActionData)ViewData.Model.ActionData);
%>

<p>
<span class="owner"><%=Html.ActionOwnerLink(ViewData.Model, "You")%></span> <span class="action">added</span> a comment to  <%=commentOnUserProfileActionData.UserProfile.Username%>'s-  <span class="actionLink"><a href="<%=Html.ViewWhoIsUrl(commentOnUserProfileActionData.UserProfile.Username) %>">profile</a></span> <br /> <span class="date"><%=Html.RenderPrettyDate(ViewData.Model.Created)%></span>
</p>