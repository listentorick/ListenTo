<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Footer.ascx.cs" Inherits="ListenTo.Web.Views.Shared.Footer" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%

    ListenTo.Web.Models.Footer footer = null;
    if (ViewData["footer"] != null)
    {
        footer = (ListenTo.Web.Models.Footer)ViewData["footer"];
    } else {
        footer = ViewData.Model;
    }

 %>
<div id="footer">
	<div id="footerInner">
		<div class="footerCol" id="music">
			<h2>Five Manchester bands</h2>
			<ul>
			  <% foreach (ListenTo.Shared.DTO.ArtistSummary artist in footer.Artists)
        {%>
                         <li>
                            <a href="<%=Html.ViewArtistUrl(artist.ProfileAddress)%>"><%=artist.Name%></a>
                        </li>
              <%} %>
			</ul>
			<p class="moreLink"><a href="<%=Html.ArtistListingsUrl()%>">More bands</a></p>
		</div>
		<div class="footerCol" id="music">
			<h2>Five Manchester gigs</h2>
			<ul>
			  <% foreach (ListenTo.Shared.DO.Gig gig in footer.Gigs)
        {%>
                         <li>
                            <a href="<%=Html.ViewGigUrl(gig)%>"><%=gig.Name%></a>
                        </li>
              <%} %>
			</ul>
				<p class="moreLink"><a href="<%=Html.GigListingsUrl()%>">More gigs</a></p>
		</div>
		
		
		<div class="footerCol" id="links">
			<h2 class="hidden">Footer Menu</h2>
			<p>&copy; Copyright ListenTo 2003-2009. All rights reserved.</p>
			<ol>
				<li><a href="<%=Html.About() %>">About ListenTo</a></li>
				<li><a href="<%=Html.TermsAndConditions() %>">Terms and Conditions</a></li>
				<li><a href="<%=Html.PrivacyPolicy() %>">Privacy Policy</a></li>
				<li><a href="<%=Html.RSS() %>" class="rss">RSS Feeds</a></li>
                <li><a href="http://www.twitter.com/listentomanc" class="twitter">Follow us on Twitter</a></li>
                
			</ol>
		</div>
	</div>
</div>

<div id="betaInfo" class="inPagePopup ">
	<h2>Nearly there!</h2>
    <p>In what can only be described as "incredible periods of inactivity" the two naughty boys behind Listen To have finally got their fingers out and created the <strong>all new Listen To Manchester</strong>. Over the next few months we'll be adding loads of new features, but we'd love your help with the site as it stands right now.</p>
    <p>So if you spot any problems, or have anything to say at all about the new site (comments, criticisms, great ideas that we can steal and become millionaires with) then <a href="mailto:info@listentomanchester.co.uk">get in touch</a>!</p>
    <p class="ctaButton"><a href="mailto:info@listentomanchester.co.uk"><img src="/content/images/buttons/reportaproblem.gif" alt="Report a problem" /></a></p>
</div>

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-1031753-1");
pageTracker._trackPageview();
} catch(err) {}</script>