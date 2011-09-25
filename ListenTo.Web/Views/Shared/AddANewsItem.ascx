<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<div class="content callToAction">
	<h2>Got something to shout about?</h2>
	<p>Then don't go all coy and quiet on us. Shout about it!</p>
    <p>Anyone can add their news and views straight on to Listen To, so if you've got something to say that about is a) Manchester, or b) music, then why not put it on the site?</p>
	<p class="ctaButton">
	<a href="<%=Html.AddNewsItemUrl() %>"><img src="/content/images/buttons/addyournews.gif" alt="Add your news" /></a></p>
</div>


