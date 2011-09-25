<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/AccountInner.Master" CodeBehind="UserContent.cs" Inherits="ListenTo.Web.Views.Account.UserContent" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">

    <div class="content">
				
				<h1>Content you've added</h1>
				<p>Listen To is about Manchester music, and it's written by the people that love Manchester music - you.</p>
				<p>This is the content you've added to the site - thanks!</p>

				<div class="addedContent">
					<div>
						<h2>News you've added</h2>
						
						    <%Html.RenderPartial("~/Views/NewsItem/NewsItemList.ascx", ViewData.Model.NewsItemSummaries);%>
						
						
	<%--					<p class="moreLink"><a href="#" class="extraUsers">Show all News you've added</a></p>--%>
					</div>
	
			</div>
    </div>    

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
    <div class="content">
        <h2>Your bands</h2>
        			
        <%if (ViewData.Model.ArtistSummaries.Count > 0)
        { %>
            <p>You are a member of these bands. To edit band content, go to the band's page.</p>
            <%Html.RenderPartial("~/Views/Artist/ArtistList.ascx", ViewData.Model.ArtistSummaries);%>
         
        <%}
        else
        { %>
            <ul class="itemsList">
	            <li>
		            <img width="40" height="40" alt="add a band" src="/content/images/thumbnails/thumb-artist.gif"/>
		            <p>Are you in a band, or do you manage a band? <br/>
		            <strong><a href="<%=Html.AddArtistUrl()%>">Add a band...</a></strong></p>
	            </li>
            </ul>
        <%}%>
        		
        <%--			<ul class="userList">
				        <li><a href="whois.php"><img width="40" class="userThumb" src="images/userthumb1.jpg" alt="tomadams"/>New Zealand Story</a> <a title="Leave New Zealand Story" href="#" class="delete"><img alt="Leave New Zealand Story" src="images/template/delete.png"/></a></li>
			        </ul>--%>

    </div>

</asp:Content>
