<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.ActionList" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<ul class="itemsList actions">
<% foreach (ListenTo.Shared.DO.Action action in ViewData.Model)
   {%>
   <li>
   <%Html.RenderPartial(Html.GetListenToActionViewPath(action), action);%>
   </li>
   <%
   } %>
</ul>