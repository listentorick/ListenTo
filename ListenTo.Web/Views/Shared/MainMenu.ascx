<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MainMenu.ascx.cs" Inherits="ListenTo.Web.Views.Shared.MainMenu" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>


<div id="menu">
<div id="menuInner">
	<h2 class="hidden">Main Menu</h2>
 	<ul class="ddMenu">

		<li class="menuHome <% if(Html.IsSection(ListenTo.Web.Enums.MenuSection.HOME)){%> on<%}%>"><a href="/home">Home</a></li>
		
		<li class="menuBandsAZ <% if(Html.IsSection(ListenTo.Web.Enums.MenuSection.ARTISTS)){%> on<%}%>"><a href="<%=Html.ArtistListingsUrl() %>">Bands</a>
        	<div>
            	<span>Find new and unsigned Manchester bands, and be their fan!</span>
                <ul>
                    <li><a href="<%=Html.ArtistListingsUrl() %>">Show all bands</a></li>
                    <li><a href="<%=Html.AddArtistUrl()%>">Add a band +</a></li>
                </ul>
            </div>
		</li>
		<li class="menuGigs <% if(Html.IsSection(ListenTo.Web.Enums.MenuSection.GIGS)){%> on<%}%>"><a href="<%=Html.GigListingsUrl() %>">Gigs</a>
        	<div>
	        	<span>Find Manchester gigs, and tell people you're going!</span>
                <ul>
                    <li><a href="<%=Html.GigListingsUrl() %>">Show all gigs</a></li>
                    <li><a href="<%=Html.AddGigUrl() %>">Add a gig listing +</a></li>
                </ul>
            </div>
		</li>
		<li class="menuMusic <% if(Html.IsSection(ListenTo.Web.Enums.MenuSection.TRACKS)){%> on<%}%>" ><a href="/radio">Music</a>
        	<div>
        		<span>Listen to great local Manchester music, find music to love!</span>
				<ul>
                    <li><a href="/radio">Music Radio</a></li>
                    <li><a href="<%=Html.TrackListingsUrl() %>">List all music</a></li>
                    <li><a href="<%=Html.AddTrackUrl() %>">Add music +</a></li>
                </ul>
            </div>
		</li>
		<li class="menuReviews <% if(Html.IsSection(ListenTo.Web.Enums.MenuSection.NEWSITEMS)){%> on<%}%>"><a href="<%=Html.NewsItemListingsUrl() %>">News &amp; stuff</a>
        	<div>
                <span>News and views about Manchester's new and unsigned music</span>
                <ul>
                    <li><a href="<%=Html.NewsItemListingsUrl() %>">Show all news</a></li>
                    <li><a href="<%=Html.AddNewsItemUrl() %>">Add news +</a></li>
                </ul>
            </div>
		</li>
		<li class="menuAddContent <% if(Html.IsSection(ListenTo.Web.Enums.MenuSection.CONTENT)){%> on<%}%>"><a href="<%=Html.AddingContent() %>">Add Content +</a>
        	<div>
                <span>Add your band and music, or tell us stuff you know about!</span>
                <ul>
                    <li><a href="<%=Html.AddArtistUrl()%>">Add a band +</a></li>
                    <li><a href="<%=Html.AddTrackUrl() %>">Add music +</a></li>
                    <li><a href="<%=Html.AddGigUrl() %>">Add a gig listing +</a></li>
                    <li><a href="<%=Html.AddNewsItemUrl() %>">Add news +</a></li>
                </ul>
	    	</div>
		</li>
 	</ul>
  </div>
</div>
