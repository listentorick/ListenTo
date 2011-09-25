<%@ Page  Language="C#" MasterPageFile="~/Views/Shared/Form.Master" AutoEventWireup="true" CodeBehind="Add.aspx.cs" Inherits="ListenTo.Web.Views.Artist.Add" %>

<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
     <%=Html.Title("Add your band | Bands | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FormPlaceHolder" runat="server">

    <form method="post" enctype="multipart/form-data" action="<%=Html.AddArtistUrl() %>">
        <h1>Add your band</h1>
        <%Html.RenderPartial("~/Views/Artist/AddArtist.ascx");%>
    </form>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
	<div class="content">
	<h2>What's this then?</h2>
	<p>Adding a band or artist to Listen To couldn't be easier. Well, it could, but it wouldn't be nearly so much fun.</p>
	<p>Add basic details, choose a web address to access them on Listen To, and then upload a picture if you want.</p>
	</div>
</asp:Content>
