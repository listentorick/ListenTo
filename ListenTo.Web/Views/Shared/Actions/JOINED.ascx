<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.Actions.JOINED" %>

<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<p>
<span class="action">Joined</span> ListenTo <br /> <span class="date"><%=Html.RenderPrettyDate(ViewData.Model.Created)%></span>
</p>
