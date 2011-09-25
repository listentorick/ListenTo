<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<div class="content callToAction">
	<h2>Want your music here?</h2>
	<p>Any Manchester band or artist can add music to Listen To - it's dead easy, promise.</p>
	<a href="<%=Html.AddTrackUrl() %>"><img src="/content/images/buttons/addasong.gif" alt="Add a song" /></a></p>
</div>	