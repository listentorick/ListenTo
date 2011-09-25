<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.Actions.ADDED_AN_ARTIST" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<% 
ListenTo.Shared.ActionData.ArtistAddedActionData artistAddedActionData = ((ListenTo.Shared.ActionData.ArtistAddedActionData)ViewData.Model.ActionData);
%>

<% if (artistAddedActionData.Artist.ProfileImage != null && artistAddedActionData.Artist.ProfileImage.Thumbnail != null)
{%>
<%=Html.RenderImage(artistAddedActionData.Artist.ProfileImage.Thumbnail, "thumb!", artistAddedActionData.Artist.Name, new { })%>
<%}%>

<p>
<span class="owner"><%=Html.ActionOwnerLink(ViewData.Model, "You")%></span> <span class="action">added</span> a new band -  <span class="actionLink"><a href="<%=Html.ViewArtistUrl(artistAddedActionData.Artist)%>">"<%=Html.Escape(artistAddedActionData.Artist.Name)%>"</a></span> (<%=Html.Escape(artistAddedActionData.Artist.Style.Name)%>) <br /> <span class="date"><%=Html.RenderPrettyDate(ViewData.Model.Created)%></span>
</p>
