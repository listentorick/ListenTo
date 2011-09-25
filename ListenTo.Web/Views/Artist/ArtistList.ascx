<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArtistList.ascx.cs" Inherits="ListenTo.Web.Views.Artist.ArtistList" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>




<ul class="itemsList">
<% foreach (ListenTo.Shared.DTO.ArtistSummary artist in ViewData.Model){%>
    
        <%if (ViewData.Model.IndexOf(artist) == 0)
          {%>
        <li class="firstItem">
        <% }
          else if (ViewData.Model.IndexOf(artist) == 1) 
          {%>
            <li class="secondItem">
          <%}else{%>
          <li>
        <% }%>

         <%=Html.RenderArtistProfileImageThumbnail(artist)%>
         
    <%if (Html.IsOwner(artist))
      { %>
        <p class="edit">
            <a href="<%=Html.EditArtistUrl(artist.ID)%>">
                <img src="/content/images/buttons/edit.gif" alt="Edit: <%=artist.Name%>" />
            </a>
        </p>
    
    <%} %>

    <strong><a href="<%=Html.ViewArtistUrl(artist.ProfileAddress)%>"><%=artist.Name%></a></strong>
    <br /> <a href="<%= Html.ArtistListingsUrl(artist.StyleName) %>"><%=artist.StyleName%></a>
</li>
<%} %>
</ul>
