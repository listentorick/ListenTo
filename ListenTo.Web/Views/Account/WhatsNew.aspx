<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Account.Master" Inherits="ListenTo.Web.Views.Account.WhatsNew" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title("Whats New | Listen To Manchester - we love new manchester music")%>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">


    <div class="content">        <h1>What's been going on lately?</h1>        <%Html.RenderPartial("~/Views/Shared/ActionList.ascx", ViewData.Model.LatestActions); %>	</div>
	
	 <%if (ViewData.Model.UserProfileComments != null) { Html.RenderPartial("~/Views/Shared/CommentList.ascx", ViewData.Model.UserProfileComments); }%>
 <%Html.RenderPartial("~/Views/Shared/AddComment.ascx", ViewData.Model.AddCommentViewModel); %>
	
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">



<div id="subContent1">
    <div id="tracks">
        <div class="content">

        <h2><a href="<%=Html.GigListingsUrl()%>">New Music</a></h2>
		
        <%Html.RenderPartial("~/Views/Track/TrackList.ascx", ViewData.Model.LatestTracks);%>
		
        <p class="moreLink"><a href="<%=Html.TrackListingsUrl() %>">More music</a></p>
	    
        </div>
    </div>
    
    <div id="gigs">
        <div class="content">

        <h2><a href="<%=Html.GigListingsUrl()%>">Upcoming Gigs</a></h2>
		
        <%Html.RenderPartial("~/Views/Gig/GigList.ascx", ViewData.Model.UpcomingGigs);%>
		
        <p class="moreLink"><a href="<%=Html.GigListingsUrl() %>">More gigs</a></p>
        </div>
    </div>
    
</div>

<div id="subContent2">

    <div class="content" >
     <h2>Bands you like</h2>
     <%Html.RenderPartial("~/Views/Shared/BandsLiked.ascx", ViewData.Model.BandsLikedPartialViewModel); %>
    </div>
    

</div>
</asp:Content>
