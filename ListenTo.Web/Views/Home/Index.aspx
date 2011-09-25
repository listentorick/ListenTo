<%@ Page Language="C#"
 AutoEventWireup="true" 
 CodeBehind="Index.aspx.cs" 
 Inherits="ListenTo.Web.Views.Home.Index" 
 %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta http-equiv="Content-Language" content="en-uk" />

	<meta name="robots" content="index, follow" />
	<meta name="revisit-after" content="14 days" />

	<meta name="keywords" content="Listen To Manchester, Manchester, bands, new bands, artists, new music, music, gigs, music player, local, North West, news, writing, articles, blogs" />
	<meta name="description" content="Listen To Manchester is a place for new Manchester bands and music, gig listings news and articles, mp3 music player of local artists" />

    <title>Listen To Manchester - we love new manchester music</title>
    
    <style type="text/css">@import "/content/css/global.css";</style>
	<style type="text/css">@import "/content/css/manchester.css";</style>
	<style type="text/css">@import "/content/css/home.css";</style>
	<!--[if lte IE 6]><style type="text/css">@import "/content/css/ie6.css";</style><![endif]-->
	<!--[if IE 7]><style type="text/css">@import "/content/css/ie7.css";</style><![endif]-->

	<script type="text/javascript" src="/content/js/jquery.js"></script>
	<script type="text/javascript" src="/content/js/global.js"></script>
	<script type="text/javascript" src="/content/js/home.js"></script>	
	<script type="text/javascript" src="/content/js/thickbox.js"></script>
	<script type="text/javascript" src="/content/js/date.js"></script>
    
</head>
<body class="home">

<a href="#innerWrapper" id="skipLink">Skip to main content</a>

<div id="header"><div id="headerInner">
	<h1>Listen To Manchester - new and unsigned bands and music in Manchester<span></span></h1>
    <span id="betaBadge"><a class="thickbox img" href="#TB_inline?height=260&amp;width=500&amp;inlineId=betaInfo"><img src="/content/images/beta-badge.png" alt="Version 2 Beta! - find out more or report a problem" /></a></span>
</div></div>

<%Html.RenderPartial("~/Views/Shared/MainMenu.ascx");%>

<div id="wrapper">
	<div id="innerWrapper">		
	    <div id="bands">
			<div id="bandsCTA">	
				<h2><%=ViewData.Model.NumberOfArtists.ToString() %> bands on Listen To<span class="hidden"> Manchester</span></h2>

			    <a href="<%=Html.ArtistListingsUrl()%>">Find one you like<span class="hidden"> (bands)</span></a>
				<a href="<%=Html.AddArtistUrl()%>">Add yours<span class="hidden"> (band)</span></a>
			</div>

			<div id="bandsList">

			    <ul>
                    <% foreach (ListenTo.Shared.DTO.ArtistSummary artist in ViewData.Model.Artists){%>
                         <li>
                            <h3><a href="<%=Html.ViewArtistUrl(artist.ProfileAddress)%>"><%=artist.Name%></a></h3>
                            <p> <%=Html.WordBreak(artist.StyleName)%></p>
                         
                              <%=Html.RenderArtistProfileImageThumbnail(artist)%>

                        </li>
                    <%} %>
                </ul>
			</div>

		</div>

		
		<div id="homeOther">
 <%if (!this.Context.User.Identity.IsAuthenticated)
   {%>
			<div id="login">
			
                <form method="post" action="/Account/Login">

                    <fieldset class="content">
                        <h2>Login</h2>
                        <p>
                        <label for="username">Username</label>
                            <%= Html.TextBox("Username", null, new { @class = "text" })%>
                        </p>

                        <p>
                            <label for="username">Password</label>
                            <%= Html.Password("Password", null, new { @class = "text" })%>
                        </p>

                        <div class="formButtons">
                            <input type="image" id="Image1" src="/content/images/buttons/login-top.gif" alt="Register" />
                            <p><a href="<%=Html.RetrieveDetails() %>" title="Forgotten your password? Click here">Forgotten your username or password?</a></p>
                        </div>
                    </fieldset>
                </form>
				
				<div class="content">

					<h2><a href="<%=Html.RegisterAccountUrl()%>">Register</a></h2>
					<p>You don't have to <a href="<%=Html.RegisterAccountUrl()%>">register with ListenTo</a> - everyone can find out about <a href="<%=Html.ArtistListingsUrl() %>">new and unsigned Manchester bands</a> and <a href="<%=Html.GigListingsUrl() %>">Manchester gigs</a>, hear great local music in the <a href="/radio">Manchester music radio player</a> and read <a href="<%=Html.NewsItemListingsUrl() %>">Manchester's music news</a>.</p>
					<p>But if you register, you can also do this:</p>
                    <ul>
                        <li><a href="<%=Html.AddArtistUrl()%>">Add your band</a></li>
                        <li>Once you've added your band, <a href="<%=Html.AddTrackUrl() %>">add your music</a></li>
                        <li>Know about a gig that's coming up? <a href="<%=Html.AddGigUrl() %>">Add a gig</a></li>
                        <li>Something exciting going on? <a href="<%=Html.AddNewsItemUrl() %>">Add some news</a></li>
                    </ul>
                	<p class="ctaButton"><a href="<%=Html.RegisterAccountUrl()%>"><img src="/content/images/buttons/register-top.gif" alt="Register" /></a></p>


				</div>
			</div>
			<%} else {%>
			<div id="loggedIn"><div class="content">
				<h2>Hello you!</h2>
                <p>Hello <a href="<%=Html.WhatsNewUrl(this.Context.User.Identity.Name)%>"><strong><%=this.Context.User.Identity.Name%></strong></a>. Welcome back to Listen To - the place for for new and unsigned Manchester bands and gigs, music and great writing.</p>
                <p class="ctaButton"><a href="<%=Html.WhatsNewUrl(this.Context.User.Identity.Name)%>"><img src="/content/images/buttons/yourhomepage-top.gif" alt="Your homepage" /></a></p>
                <p>There's loads of stuff to do:</p>
				<ul>
					<li><a href="<%=Html.ArtistListingsUrl() %>">Go and find some bands to love</a>. Be their fan, and they'll give you updates and love!</li>
					<li><a href="<%=Html.GigListingsUrl() %>">Find a gig to go to</a>, and tell the world you're going</li>
					<li>Hear great local music in the <a href="/radio">Manchester music radio player</a></li>
					<li><a href="<%=Html.NewsItemListingsUrl() %>">Read Manchester's music news</a></li>
                </ul>
                <p>Listen To Needs You! Add stuff to the site:</p>
				<ul>
                	<li><a href="<%=Html.AddArtistUrl() %>">Add your band</a></li>
                    <li>Once you've added your band, <a href="<%=Html.AddTrackUrl() %>">add your music</a></li>
                    <li>Know about a gig that's coming up? <a href="<%=Html.AddGigUrl()%>">Add a gig</a></li>
                    <li>Something exciting going on? <a href="<%=Html.NewsItemListingsUrl() %>">Add some news</a></li>
				</ul>
                <p><a class="moreLink" href="<%=Html.WhatsNewUrl(this.Context.User.Identity.Name)%>">Go to your homepage - see whats new, or update your profile</a></p>
            </div></div>
			<%}%>

			
			<div id="musicPlayer"><div class="content">
				<h2>Manchester music player</h2>
				<form action="/radio/" method="get" >
				    <fieldset>
					    <p>Full of songs you'll love!</p>

					    <p>
					    <label for="styles">Choose genre</label>
	                     <%=Html.DropDownList("styles", ViewData.Model.StylesSelectList, new { @class = "text small" })%>
	                    </p>
    	  
    	
					    <div class="formButtons">
						    <input type="image" alt="Play music" src="/content/images/buttons/playmusic.gif" id="x"/>
					    </div>
				    </fieldset>
				</form>
			</div></div>
	
	
			<div id="news"><div class="content">
				<h2><a href="<%=Html.NewsItemListingsUrl()%>">News &amp; stuff</a></h2>
			
			    <%Html.RenderPartial("~/Views/NewsItem/NewsItemList.ascx", ViewData.Model.NewsItemSummary);%>
			
				<p class="moreLink clear"><span><a href="<%=Html.NewsItemListingsUrl() %>">More News</a></span></p>
			</div></div>
	
	
			<div id="gigs"><div class="content">

				<h2><a href="<%=Html.GigListingsUrl()%>">Gigs</a></h2>
				
				<%Html.RenderPartial("~/Views/Gig/GigList.ascx", ViewData.Model.Gigs);%>
				
				<p class="moreLink"><a href="<%=Html.GigListingsUrl() %>">More gigs</a></p>
			</div></div>

		</div>



	</div>
	<div id="skyline"></div>
</div>



<%Html.RenderPartial("~/Views/Shared/Footer.ascx", ViewData.Model.Footer);%>





</body>
</html>