<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddAGig.ascx.cs" Inherits="ListenTo.Web.Views.Shared.AddAGig" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<div class="content callToAction">
	<h2>List your gig!</h2>
	<p>If nobody knows about your gigs the only people who'll turn up will be a couple of your mates and that weird bloke who turns up to every gig. You know the one, wears a tracksuit and does an odd dance waving around a Lidl bag stuffed with, let's face it, god knows what. You've seen him at your gigs. And smelled him. And possibly snogged him. God, I was drunk <em>that</em> night.</p>
    <p>Anyway! If you don't want that man to be your only fan, don't be shy - get the message out and get your gigs listed on Listen To!</p>
	<p class="ctaButton">
	<a href="<%=Html.AddGigUrl() %>"><img src="/content/images/buttons/addagig.gif" alt="Add a gig" /></a></p>
</div>
