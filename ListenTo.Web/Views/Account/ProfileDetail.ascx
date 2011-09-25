<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Account.ProfileDetail" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

	    <dl class="columnList">
		    <%if (ViewData.Model.Town != null){ %><dt>From</dt><dd><%=ViewData.Model.Town.Name%></dd><%}%> 
		    <dt>Joined</dt><dd><%=Html.RenderPrettyDate(ViewData.Model.Created)%></dd>
		 
		 <%if( ViewData.Model.Styles.Count>0){%>
		 
		    <dt>Likes</dt><dd>
		    
		    <%
		  
                foreach (ListenTo.Shared.DO.Style style in ViewData.Model.Styles)
                {
                    %> 
                     <a href="<%=Html.TrackListingsUrl(style.Name)%>"><%=style.Name%></a>&nbsp;
                    <%
                }
           }%>

	    </dl>
						