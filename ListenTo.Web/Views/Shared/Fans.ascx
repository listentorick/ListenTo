<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.Fans" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<div>


<%if (ViewData.Model.ArtistFanRelationshipSummaries.Count > 0)
  { %>
    <ul class="userList">

        <%
    foreach (ListenTo.Shared.DTO.ArtistFanRelationshipSummary summary in ViewData.Model.ArtistFanRelationshipSummaries)
    { 
        %>
           <li>
                <a href="<%=Html.ViewWhoIsUrl(summary.Username)%>"><%=Html.RenderImage(summary.UserThumbnail, "thumb", summary.Username, new { @class="userThumb" })%>
                <%=summary.Username%></a>
           </li>
        
        <%}%>
        
    </ul>
    
<%}
  else
  {%>

<p>This band doesn't have any fans! That can't be right - we've heard they're amazing! At least, we think it was them.</p>


<%} %>
</div>