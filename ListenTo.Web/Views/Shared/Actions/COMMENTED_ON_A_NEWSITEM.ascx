<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.Actions.COMMENTED_ON_A_NEWSITEM" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<% 
    ListenTo.Shared.ActionData.CommentOnNewsItemActionData commentOnNewsItemActionData = ((ListenTo.Shared.ActionData.CommentOnNewsItemActionData)ViewData.Model.ActionData);
    bool newsIsDeleted = commentOnNewsItemActionData.NewsItem.IsDeleted;
    %>

<%if (newsIsDeleted)
  {%>
<p title="Sorry, this news item has been deleted!">
<del>
<%}
  else
  {%>
<p>
<%}%>

<span class="owner"><%=Html.ActionOwnerLink(ViewData.Model, "You")%></span> 

<span class="action">added</span> a comment to the newsitem -  <span class="actionLink">
<%if (!newsIsDeleted)
{%>
<a href="<%=Html.ViewNewsItemUrl(commentOnNewsItemActionData.NewsItem.ID)%>">
<%} %>
"<%=Html.Escape(commentOnNewsItemActionData.NewsItem.Name)%>"

<%if (!newsIsDeleted)
{%>
</a>
<%} %>
</span> <br /> <span class="date"><%=Html.RenderPrettyDate(ViewData.Model.Created)%></span>


<%if (newsIsDeleted == true)
  { %>
  </del>
<%} %>
</p>