<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CommentList.ascx.cs" Inherits="ListenTo.Web.Views.Shared.CommentList" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<%if(ViewData.Model.Count>0) { %>
<div class="content">
	<h2>Recent comments</h2>

	    <table class="commentsTbl" summary="Table of comments">

	        <thead>
		        <tr>
			        <th class="firstCol">Author</th>
			        <th>Message</th>
		        </tr>
	        </thead>
	    
            <tbody>
            
            <% foreach (ListenTo.Shared.DTO.CommentSummary cs in ViewData.Model){%>
            
	            <tr>

		            <td>
			            <p>
			            
			                
                        <% if (cs.OwnerThumbnail != null)
                        {%>
                           
                          <%=Html.RenderImage(cs.OwnerThumbnail, "profileImage", cs.OwnerUsername, new { @class="userThumb"})%>
                               
                        <%}%>
			            
			            
			            <strong><a href="<%=Html.ViewWhoIsUrl(cs.OwnerUsername) %>"><%=cs.OwnerUsername%></a></strong></p>

			            <p><em><%=Html.RenderPrettyDate(cs.Created)%></em></p>
		            </td>
		            <td>
		            	<%=Html.TextToHtml(cs.Body)%>
		            </td>
	            </tr>
	            <%} %>
	       </tbody>
	    </table>		
</div>
<%} %>