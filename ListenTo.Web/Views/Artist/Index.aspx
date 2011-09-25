<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Artist.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ListenTo.Web.Views.Artist.Index" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
     <%=Html.Title(Html.Escape(ViewData.Model.Artist.Name) + " | Listen To Manchester - we love new manchester music")%>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">

<div class="content">
	<div id="aboutText">
		<h1><%=Html.Escape(ViewData.Model.Artist.Name)%></h1>
		<dl class="columnList">
			<dt>Style</dt><dd><%=Html.Escape(ViewData.Model.Artist.Style.Name)%></dd>
			<dt>Added by</dt><dd><a href="<%=Html.ViewWhoIsUrl(ViewData.Model.AuthorsUserProfile.Username) %>"><%=ViewData.Model.AuthorsUserProfile.Username %></a></dd>
			<%if (ViewData.Model.Artist.OfficalWebsiteURL != null && ViewData.Model.Artist.OfficalWebsiteURL != string.Empty)
            {%>
			    <dt>Website</dt><dd><a href="<%=ViewData.Model.Artist.OfficalWebsiteURL%>"><%=ViewData.Model.Artist.OfficalWebsiteURL%></a></dd>
            <%} %>
		</dl>
		
		<%=Html.TextToHtml(ViewData.Model.Artist.Profile)%>
	</div>
	<div id="image">
		<h2 class="hidden">Photos</h2>
        <% if (ViewData.Model.Artist.ProfileImage != null)
        {
          
        %>
               <%=Html.RenderImage(ViewData.Model.Artist.ProfileImage, "profileImage", ViewData.Model.Artist.Name, new { width = "172" })%>
        <%}%>
	
<%--		<ul class="photoList photoThumbs">
			<li><a href="images/temp/gigphoto-large1.jpg" title="Text about the photo: further text" rel="lightbox-latestGig"><img src="images/temp/gigphoto-thumb1.jpg" width="40" alt="lorem ipsum" /></a></li>
			<li><a href="images/temp/gigphoto-large2.jpg" title="Text about the photo: further text" rel="lightbox-latestGig"><img src="images/temp/gigphoto-thumb2.jpg" width="40" alt="lorem ipsum" /></a></li>

			<li><a href="images/temp/gigphoto-large3.jpg" title="Text about the photo: further text" rel="lightbox-latestGig"><img src="images/temp/gigphoto-thumb3.jpg" width="40" alt="lorem ipsum" /></a></li>
			<li><a href="images/temp/gigphoto-large4.jpg" title="Text about the photo: further text" rel="lightbox-latestGig"><img src="images/temp/gigphoto-thumb4.jpg" width="40" alt="lorem ipsum" /></a></li>
			<li><a href="images/temp/gigphoto-large5.jpg" title="Text about the photo: further text" rel="lightbox-latestGig"><img src="images/temp/gigphoto-thumb5.jpg" width="40" alt="lorem ipsum" /></a></li>
			<li><a href="images/temp/gigphoto-large6.jpg" title="Text about the photo: further text" rel="lightbox-latestGig"><img src="images/temp/gigphoto-thumb6.jpg" width="40" alt="lorem ipsum" /></a></li>
			<li><a href="images/temp/gigphoto-large7.jpg" title="Text about the photo: further text" rel="lightbox-latestGig"><img src="images/temp/gigphoto-thumb7.jpg" width="40" alt="lorem ipsum" /></a></li>
			<li><a href="images/temp/gigphoto-large1.jpg" title="Text about the photo: further text" rel="lightbox-latestGig"><img src="images/temp/gigphoto-thumb1.jpg" width="40" alt="lorem ipsum" /></a></li>
		</ul>
		<p><a href="#" class="moreLink">More photos</a></p>--%>

	</div>
</div>


    <%if (ViewData.Model.Comments != null) { Html.RenderPartial("~/Views/Shared/CommentList.ascx", ViewData.Model.Comments); }%>
    <%Html.RenderPartial("~/Views/Shared/AddComment.ascx", ViewData.Model.AddCommentViewModel); %>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">

    <div id="subContent1">
    	<div class="content">
		    <h2>Next gig</h2>
            <%if (ViewData.Model.NextGig != null)
              {%>
			    <ul class="itemsList">
				    <li>
	                    <%Html.RenderPartial("~/Views/Gig/GigListItem.ascx", ViewData.Model.NextGig);%>
				    </li>
			    </ul>	
    						
             <% }else{%>
                  
	             <p>No upcoming gigs. Boo.</p>
    			
             <% }%>
	    </div>
    </div>
    <div id="subContent2">
        <div class="content" >
        <h2>Fans</h2>
         <%Html.RenderPartial("~/Views/Shared/Fans.ascx", ViewData.Model.FansPartialViewModel); %>
        </div>
        <%Html.RenderPartial("~/Views/Shared/BecomeAFan.ascx");%>
    </div>
</asp:Content>
