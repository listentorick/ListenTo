<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GigList.ascx.cs" Inherits="ListenTo.Web.Views.Gig.GigList" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>

<ul class="itemsList">

<% foreach (ListenTo.Shared.DO.Gig gig in ViewData.Model){%>

<%if (ViewData.Model.IndexOf(gig) == 0)
  {%>
<li class="firstItem">
<% }
  else{%>
  <li>
<% }%>
    
    <%Html.RenderPartial("~/Views/Gig/GigListItem.ascx", gig);%>
 
</li>

<%} %>
</ul>


