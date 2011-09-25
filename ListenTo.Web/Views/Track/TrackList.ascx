<%@ Control Language="C#"  CodeBehind="TrackList.ascx.cs" Inherits="ListenTo.Web.Views.Track.TrackList"%>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<ul class="itemsList">
    <% foreach (ListenTo.Shared.DTO.TrackSummary trackSummary in ViewData.Model)
       {%>
        
        <%if (ViewData.Model.IndexOf(trackSummary) == 0)
          {%>
        <li class="firstItem">
        <% }
          else if (ViewData.Model.IndexOf(trackSummary) == 1) 
          {%>
            <li class="secondItem">
          <%}else{%>
          <li>
        <% }%>

        <a id="<%=trackSummary.ID%>" href="<%=Html.ViewTrackUrl(trackSummary)%>"><strong><%=trackSummary.Name%></strong></a>
         (<a href="<%=Html.TrackListingsUrl(trackSummary.StyleName)%>"><%=trackSummary.StyleName%></a>)
        <br /> 
        by <a href="<%=Html.ViewArtistUrl(trackSummary.ArtistProfileAddress)%>"><%=trackSummary.ArtistName%></a>
        <%if (Html.IsOwner(trackSummary))
          { %>
            <br /><a href="<%=Html.EditTrackUrl(trackSummary)%>">Edit</a>
        <%} %>
    
    </li>
    <%} %>
</ul>