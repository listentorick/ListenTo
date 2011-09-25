<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ListenTo.Web.Views.Venue.Index" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>


<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title(Html.Escape(ViewData.Model.Venue.Name) + " | Venues | Listen To Manchester - we love new manchester music")%>
</asp:Content>



<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">

<%if (ViewData.Model.Venue.Address != null)
{%>
<!--
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAAhM4RD9hq_WUnW3m7bpH8fRSIkuGPMQWMqXtoFzEzm-aw-gT2TRR4UWs3mBgA491MDRT4Xz6ZEEU_Zg" type="text/javascript"></script>
<script type="text/javascript" src="/content/js/venue.js"></script>
-->
<%} %>


<div class="content">	
    <h1>Venue - <%=ViewData.Model.Venue.Name%></h1>	
    <div class="venueDetails">
	    <dl class="columnList">
	    
	        <%if (ViewData.Model.Venue.Address != null)
           {%>

		        <dt>Address</dt><dd id="addressData"><%=ViewData.Model.Venue.Address%><br />
                <!--<a href="#map" class="moreLink">Show map</a>--></dd>
						<!--
                        <dt class="hidden">Map</dt>
						<dd id="googleMap">
							<div id="map">
							</div>
						</dd>
                        -->
		    <%} %>
		    
		    <%if (ViewData.Model.Venue.Address != null)
        {%>
		        <dt>Phone</dt><dd><%=ViewData.Model.Venue.Telephone%></dd>
		    <%} %>
		    
		    <%if (ViewData.Model.Venue.URL != null)
        {%>
		        <dt>Website</dt><dd><a href="#"><%=ViewData.Model.Venue.URL%></a></dd>
            <%} %>
            
	    </dl>
    </div>

    <div class="clear">
	    <div class="col1">
		    <h2>Recent gigs</h2>
		    <%Html.RenderPartial("~/Views/Gig/GigList.ascx", ViewData.Model.RecentGigs);%>	    
		</div>
	    <div class="col2">
		    <h2>Upcoming gigs</h2>
		    <%Html.RenderPartial("~/Views/Gig/GigList.ascx", ViewData.Model.UpcomingGigs);%>
	    </div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">

 <%Html.RenderPartial("~/Views/Shared/AddAGig.ascx");%>
</asp:Content>
