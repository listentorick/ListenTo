<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GigListItem.ascx.cs" Inherits="ListenTo.Web.Views.Gig.GigListItem" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

	<h3><a href="<%=Html.ViewGigUrl(ViewData.Model)%>"><%=ViewData.Model.Name%></a></h3>
    <%if (Html.IsOwner(ViewData.Model))
      { %>
     
        <p class="edit">
            <a href="<%=Html.EditGigUrl(ViewData.Model)%>">
                <img src="/content/images/buttons/edit.gif" alt="Edit: <%=ViewData.Model.Name%>" />
            </a>
        </p>
    
    <%} %>
	<p><%=Html.RenderDate(ViewData.Model.StartDate)%></p>
	<p><a href="<%=Html.ViewVenueUrl( ViewData.Model.Venue ) %>"><%=Html.Escape(ViewData.Model.Venue.Name)%></a></p>
	
	Acts playing:
	 <ul>
	    <% foreach (ListenTo.Shared.DO.Act act in ViewData.Model.Acts)
        {
            if (act.Artist != null){%>
	        <li><a href="<%=Html.ViewArtistUrl(act.Artist)%>"><%=Html.Escape(act.Artist.Name)%></a></li>
            <%} else {%>
              <li><%= Html.Escape(act.Name)%></li>
            <%}    
        }%>
    </ul>
    
