<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.Actions.ADDED_A_NEWS_ITEM" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<% 
ListenTo.Shared.ActionData.NewsAddedActionData  newsAddedActionData = ((ListenTo.Shared.ActionData.NewsAddedActionData)ViewData.Model.ActionData);
bool newsIsDeleted = newsAddedActionData.NewsItem.IsDeleted;
%>


<% if (newsAddedActionData.NewsItem.Image != null && newsAddedActionData.NewsItem.Image.Thumbnail != null)
{%>
<%=Html.RenderImage(newsAddedActionData.NewsItem.Image.Thumbnail, "thumb!", newsAddedActionData.NewsItem.Name, new { })%>
<%}%>


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
<span class="action">added</span> News -  <span class="actionLink">
<%if (!newsIsDeleted)
{%>
<a href="<%=Html.ViewNewsItemUrl(ViewData.Model.ContentID)%>">
<%}%>

"<%=Html.Escape(newsAddedActionData.NewsItem.Name)%>"

<%if (!newsIsDeleted)
{%>
</a>
<%}%>

</span> <br /> <span class="date"><%=Html.RenderPrettyDate(ViewData.Model.Created)%></span>

<%if (newsIsDeleted == true)
  { %>
  </del>
<%} %>
</p>
