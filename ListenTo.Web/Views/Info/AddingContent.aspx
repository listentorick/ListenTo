<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" Inherits="ListenTo.Web.Views.Info.AddingContent" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>


<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Add your content | Listen To Manchester - we love new manchester music" )%>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
			<div class="content ">
				<h1>Add Content</h1>
				<p>ListenTo is about Manchester music, and it's written by the people that love Manchester music - you.</p>
				<p>Anyone can add content to the site, so if you've got stuff to say, or things to tell the rest of us about - then do it! What are you waiting for?</p>
				<div class="landingBlocks clear">
					
					<ul class="itemsList">
						<li>
							<h2>Add a band</h2>
							<img width="40" height="40" alt="add a band" src="/content/images/thumbnails/thumb-artist.gif"/>
							<p>Are you in a band, or do you manage a band? <br/>
							<strong><a href="<%=Html.AddArtistUrl()%>">Add a band...</a></strong></p>
						</li>
											
						<li>
	
							<h2>Add a gig</h2>
							<img width="40" height="40" alt="add a gig" src="/content/images/thumbnails/thumb-gig.gif"/>
							<p>In a band with a gig to promote? Or know about a gig that we don't?<br/>
							<strong><a href="<%=Html.AddGigUrl() %>">Add a gig...</a></strong></p>
						</li>

						<li>
							<h2>Upoad music</h2>
							<img width="40" height="40" alt="add a track" src="/content/images/thumbnails/thumb-recording.gif"/>
							<p>If you've added a band, upload their music.<br/>
							<strong><a href="<%=Html.AddTrackUrl() %>">Add a track...</a></strong></p>
						</li>
						
						
						<li>
							<h2>Add your news</h2>
							<img width="40" height="40" alt="add an article" src="/content/images/thumbnails/thumb-article.gif"/>
							<p>Got stuff to say? Course you have. Share it!<br/>
							<strong><a href="<%=Html.AddNewsItemUrl() %>">Add news...</a></strong></p>
						</li>
						

					</ul>
				
				</div>
			</div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">


			<div class="content">
				<h2>Listen To needs you!</h2>
				<p>Everything on Listen To is added by you. Yes, you!</p>
				<p>And we need people to write reviews and articles. You don't get paid, but you do get fame, and our undying love. We can forget the love, though, if it freaks you out.</p>
			</div>
			<div class="content callToAction">
				<h2>Not registered yet?</h2>
				<p>Before you do any of the cool stuff on Listen To, you'll have to <a href="register.php">Register</a>.</p>

				<p>Yeah, it's a pain, but, you know, stop whingeing and get on with it, then you can play with Listen To to your heart's content!</p>
				
				<p class="ctaButton"><a href="/account/register"><img src="/content/images/buttons/register.gif" alt="Register"></a></p>
			</div>
		


</asp:Content>
