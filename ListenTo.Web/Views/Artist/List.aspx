<%@ Page Title="ListenToManchester - Bands" Language="C#" MasterPageFile="~/Views/Shared/Listing.Master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ListenTo.Web.Views.Artist.List" %>
<%@ Import Namespace="ListenTo.Web.Helpers.Paging" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content4" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title("Bands | Listen To Manchester - we love new manchester music")%>
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="HeaderPlaceHolder" runat="server">
<h1><%if (ViewData.Model.StyleFilter != null) {%><%=ViewData.Model.StyleFilter.Name%>&nbsp;<%} %>Bands</h1>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ListingPlaceHolder" runat="server">
<%= Html.Pager(ViewData.Model.Artists)%>
<div class="clear listing">
<%Html.RenderPartial("~/Views/Artist/ArtistList.ascx", ViewData.Model.Artists);%>
</div>
<%= Html.Pager(ViewData.Model.Artists)%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
   
     <%Html.RenderPartial("~/Views/Shared/AddAnArtist.ascx");%>

   
    <%Html.RenderPartial("~/Views/Shared/TagCloud.ascx", ViewData.Model.StyleTagCloudViewModel);%>

  
</asp:Content>
