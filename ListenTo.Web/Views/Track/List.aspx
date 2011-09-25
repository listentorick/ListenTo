<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Listing.Master" Inherits="ListenTo.Web.Views.Track.List" %>
<%@ Import Namespace="ListenTo.Web.Helpers.Paging" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content4" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Manchester Music | Listen To Manchester - we love new manchester music" )%>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="ListingPlaceHolder" runat="server">
<%= Html.Pager(ViewData.Model.Tracks)%>
<div class="clear listing">
<%Html.RenderPartial("~/Views/Track/TrackList.ascx", ViewData.Model.Tracks);%>
</div>
<%= Html.Pager(ViewData.Model.Tracks)%>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderPlaceHolder" runat="server">
    <h1>Manchester <%if (ViewData.Model.StyleFilter != null) {%><%=ViewData.Model.StyleFilter.Name%>&nbsp;<%} %>Music</h1>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
    <%Html.RenderPartial("~/Views/Shared/AddATrack.ascx");%>
     <%Html.RenderPartial("~/Views/Shared/TagCloud.ascx", ViewData.Model.StyleTagCloudViewModel);%>

</asp:Content>
