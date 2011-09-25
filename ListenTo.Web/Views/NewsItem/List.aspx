<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Listing.Master" Inherits="ListenTo.Web.Views.NewsItem.List" %>
<%@ Import Namespace="ListenTo.Web.Helpers.Paging" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content4" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">

     <%=Html.Title("News | Listen To Manchester - we love new manchester music")%>

</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="ListingPlaceHolder" runat="server">

    <h1>News</h1>
    <%= Html.Pager(ViewData.Model.NewsItemSummaries)%>
    <%Html.RenderPartial("~/Views/NewsItem/NewsItemList.ascx", ViewData.Model.NewsItemSummaries);%>
    <%= Html.Pager(ViewData.Model.NewsItemSummaries)%>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderPlaceHolder" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
 <%Html.RenderPartial("~/Views/Shared/AddANewsItem.ascx");%>
</asp:Content>
