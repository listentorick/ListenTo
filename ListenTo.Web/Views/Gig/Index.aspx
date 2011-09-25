<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ListenTo.Web.Views.Gig.Index" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( Html.Escape(ViewData.Model.Name) + "| Gig | Listen To Manchester - we love new manchester music" )%>
</asp:Content>

<asp:Content  ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
    <div class="content withCTA">
		<h1>Gig - <%=Html.Escape(ViewData.Model.Name)%></h1>

        <%=Html.TextToHtml(ViewData.Model.Description)%>
        
<%--		<div class="callToAction">
			<h2><a href="#">Going to this gig? Tell the bands! <img src="/content/images/buttons/illbethere.gif" alt="I'll be there!" /></a></h2>
		</div>--%>
		<div class="col1">
			<h2>Artists playing</h2>
             <ul>

                <% foreach (ListenTo.Shared.DO.Act act in ViewData.Model.Acts) {
                            if (act.Artist != null){%>
	                        <li><a href="<%=Html.ViewArtistUrl(act.Artist)%>"><%=Html.Escape(act.Artist.Name)%></a></li>
                            <%} else {%>
                              <li><%= Html.Escape(act.Name)%></li>
                            <%}   
                }%>
            </ul>
		</div>
		<div class="col2">
			<h2>Details</h2>
			<dl class="columnList">
				<dt>Date</dt><dd><%=ViewData.Model.StartDate.ToString("dddd, d MMM yyy")%></dd>
				<dt>Doors</dt><dd><%=ViewData.Model.StartDate.ToString("hh:mm")%></dd>
				<dt>Venue</dt><dd><a href="<%=Html.ViewVenueUrl( ViewData.Model.Venue ) %>"><%=Html.Escape(ViewData.Model.Venue.Name)%></a> <%--<a href="gig-venue.php">(map and more details)</a>--%></dd>
				<%if (ViewData.Model.TicketPrice != null && ViewData.Model.TicketPrice.Trim() != string.Empty)
                {%> <dt>Price</dt><dd><%=Html.Escape(ViewData.Model.TicketPrice)%></dd><%} %>
			</dl>
		</div>
		
	</div>
			
</asp:Content>


<asp:Content ID="Content1"  ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
    
<%--    <div class="content">
		<h2>Who's going?</h2>
		<p>These lovely people are going to this gig. Join them, start a band! Or if there's loads of them, start a cult like the Polyphonic Spree.</p>
		<ul class="userList">
			<li><a href="whois.php"><img class="userThumb" width="56" src="images/userthumb1.jpg" alt="tomadams" />tomadams</a></li>
			<li><a href="whois.php"><img class="userThumb" width="56" src="images/userthumb2.jpg" alt="keepoffthegrass" />keepoffthegrass</a></li>
			<li><a href="whois.php"><img class="userThumb" width="56" src="images/userthumb3.jpg" alt="sonofswiss" />sonofswiss</a></li>
			<li><a href="whois.php"><img class="userThumb" width="56" src="images/userthumb4.jpg" alt="leftventricle" />leftventricle</a></li>
		</ul>
	</div>--%>

    <%Html.RenderPartial("~/Views/Shared/AddAGig.ascx");%>

</asp:Content>