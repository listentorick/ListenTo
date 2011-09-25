<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddAnArtist.ascx.cs" Inherits="ListenTo.Web.Views.Shared.AddAnArtist" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<div class="content callToAction">
	<h2>Is your band here?</h2>
	<p>No? Well why the flipping heck not?</p>
    <p>Add your band/artist to Listen To, and you connect with local Manchester music fans, and get your songs, news and gig plans out to them. It really couldn't be easier to add your band, promise!</p>
	<a href="<%=Html.AddArtistUrl() %>"><img src="/content/images/buttons/addyourband.gif" alt="Add your band" /></a></p>
</div>	