<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.Actions.ADDED_A_GIG" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<% 
    ListenTo.Shared.ActionData.GigAddedActionData gigAddedActionData = ((ListenTo.Shared.ActionData.GigAddedActionData)ViewData.Model.ActionData);
    bool gigIsDeleted = gigAddedActionData.Gig.IsDeleted;
    %>
    
<%if (gigIsDeleted)
  {%>
<p title="Sorry, this gig has been deleted!">
<del>
<%}
  else
  {%>
<p>
<%}%>

<span class="owner"><%=Html.ActionOwnerLink(ViewData.Model, "You")%></span> 
<span class="action">added</span> a gig -  
<span class="actionLink">
<%if (!gigIsDeleted)
  { %>
<a href="<%=Html.ViewGigUrl(gigAddedActionData.Gig)%>">
<%} %>

"<%=Html.Escape(gigAddedActionData.Gig.Name)%>"
<%if (!gigIsDeleted)
  { %>
</a>
<%} %>
</span> at <%=Html.Escape(gigAddedActionData.Gig.Venue.Name)%>

featuring 
<%
    
    foreach (ListenTo.Shared.DO.Act act in gigAddedActionData.Gig.Acts) {
   
            if (act.Artist != null){%>
	        <a href="<%=Html.ViewArtistUrl(act.Artist)%>"><%=Html.Escape(act.Artist.Name)%></a> &nbsp;
            <%} else {%>
              <%=Html.Escape(act.Name)%> &nbsp;
            <%}    
    }
   
%>






<br /> <span class="date"><%=Html.RenderPrettyDate(ViewData.Model.Created)%></span>
<%if (gigIsDeleted == true)
  { %>
  </del>
<%} %>
</p>
