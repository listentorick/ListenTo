<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Listing.Master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ListenTo.Web.Views.Gig.List" %>
<%@ Import Namespace="ListenTo.Web.Helpers.Paging" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content4" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
     <%=Html.Title("Gigs | Listen To Manchester - we love new manchester music")%>
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="HeaderPlaceHolder" runat="server">
<h1>Manchester gigs</h1>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ListingPlaceHolder" runat="server">

<%= Html.Pager(ViewData.Model)%>
<div class="clear listingSingleCol">
<%Html.RenderPartial("~/Views/Gig/GigList.ascx", ViewData.Model);%>
</div>
<%= Html.Pager(ViewData.Model)%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
    <%Html.RenderPartial("~/Views/Shared/AddAGig.ascx");%>
</asp:Content>
