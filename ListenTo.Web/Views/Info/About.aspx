<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" Inherits="ListenTo.Web.Views.Info.About" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>


<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "About | Listen To Manchester - we love new manchester music" )%>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
			<div class="content">
				<h1>Listen To Manchester <br/>we love new Manchester music</h1>
				<p>Listen To Manchester is a place to find out about new and unsigned Manchester bands and music. There's band profiles, gig listings, news and articles, and a huge collection of Manchester music.</p>
                <p>Anyone can add content to the site - if you <a href="/account/register">register</a> you can add your own content - add bands, add music, add gigs and add news.</p>
                <p>But you don't have to get quite so involved to find out about the best new and unsigned music the Manchester has to offer:</p>
                
				<div class="landingBlocks clear">
					
					<ul class="itemsList">
						<li>
							<h2>Find a band</h2>
							<img width="40" height="40" alt="add a band" src="/content/images/thumbnails/thumb-artist.gif"/>
							<p>Hundreds of local bands - become a fan of the ones you like to get updates<br/>
							<strong><a href="/artist/add">Find a band...</a></strong></p>
						</li>
											
						<li>
	
							<h2>Find a gig to go to</h2>
							<img width="40" height="40" alt="add a gig" src="/content/images/thumbnails/thumb-gig.gif"/>
							<p>Manchester new and unsigned bands gig listings. Tell people you're going!<br/>
							<strong><a href="/gig/add">Find a gig...</a></strong></p>
						</li>

						<li>
							<h2>Listen to great music</h2>
							<img width="40" height="40" alt="add a track" src="/content/images/thumbnails/thumb-recording.gif"/>
							<p>Hundreds of songs added by Manchester bands - listen to our Manchester music radio<br/>
							<strong><a href="/track/add/">Listen to music...</a></strong></p>
						</li>
						
						
						<li>
							<h2>Read news and views</h2>
							<img width="40" height="40" alt="add an article" src="/content/images/thumbnails/thumb-article.gif"/>
							<p>Find out what's going on in the Manchester scene - news, rants and articles<br/>
							<strong><a href="/newsItem/add">Read music news...</a></strong></p>
						</li>
						

					</ul>
				
				</div>				
				<p class="ctaButton"><a href="/account/register"><img src="/content/images/buttons/register.gif" alt="Register"></a></p>
			</div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">

			<div class="content callToAction">
				<h2>Add your stuff!</h2>
				<p>Before you can tell the world about your really cool stuff on Listen To, you'll have to <a href="register.php">Register</a>. Once you've done that you can:</p>

                <h3>Add a band</h3>
                <p>Are you in a band, or do you manage a band? <br/>
                <strong><a href="/artist/add">Add a band...</a></strong></p>
                
                <h3>Add a gig</h3>
                <p>In a band with a gig to promote? Or know about a gig that we don't?<br/>
                <strong><a href="/gig/add">Add a gig...</a></strong></p>
                
                <h3>Upoad music</h3>
                <p>If you've added a band, upload their music.<br/>
                <strong><a href="/track/add/">Add music...</a></strong></p>
                
                <h3>Add your news</h3>
                <p>Got stuff to say? Course you have. Share it!<br/>
                <strong><a href="/newsItem/add">Add news...</a></strong></p>
                             
			</div>
</asp:Content>





