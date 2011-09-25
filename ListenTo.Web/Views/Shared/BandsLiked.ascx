<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.BandsLiked" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<div>
<ul class="userList">

        <%
        foreach (ListenTo.Shared.DTO.ArtistFanRelationshipSummary summary in ViewData.Model.ArtistFanRelationshipSummaries)
        { 
        %>
           <li>
               
                <a href="<%=Html.ViewArtistUrl(summary.ArtistProfileAddress)%>">
                    <%=Html.RenderArtistProfileImageThumbnail(summary.ArtistThumbnail, "thumb", summary.ArtistName, new { @class = "userThumb" })%>
                    <%=summary.ArtistName%>
                </a>
           </li>
       
        <%}%>
        
 
    </ul>
</div>