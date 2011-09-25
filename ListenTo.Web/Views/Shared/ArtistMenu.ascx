<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.ArtistMenu" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<dl class="tabs clear">
	<dt><%=ViewData.Model.Artist.Name%><span class="hidden"> Menu</span>:</dt>
	<dd>
	    <a href="<%=Html.ViewArtistUrl(ViewData.Model.Artist) %>"
            class="<%if (Html.GetRouteName()==  ListenTo.Web.Constants.Routes.ARTIST) { %> on <%}%>">
	        <span>Home</span>
	    </a>
	</dd>
	
	<dd>
	    <a href="<%=Html.ArtistMusicUrl(ViewData.Model.Artist) %>"
	         class="<%if (Html.GetRouteName()==  ListenTo.Web.Constants.Routes.ARTIST_MUSIC) { %> on <%}%>">
	        <span>Music</span>
	    </a>
	</dd>
	
	<dd>
	    <a href="<%=Html.ArtistGigsUrl(ViewData.Model.Artist) %>"
	         class="<%if (Html.GetRouteName()==  ListenTo.Web.Constants.Routes.ARTIST_GIGS) { %> on <%}%>">
	        <span>Gigs</span>
	    </a>
	</dd>
	
	<%if(ViewData.Model.IsUserFanOfArtist==false){ %>
	<dd class="becomeFan">
        <a href="#" class="<%=ListenTo.Web.Constants.ViewClasses.BECOME_A_FAN_LAUNCH_POINT_CLASS%> <%=ListenTo.Web.Constants.ViewClasses.REQUIRES_LOGIN_LAUNCH_POINT_CLASS%>">
            <img alt="Become a fan" src="/content/images/buttons/becomeafan.gif"/>
        </a>			
	</dd>
	<%}%>
</dl>