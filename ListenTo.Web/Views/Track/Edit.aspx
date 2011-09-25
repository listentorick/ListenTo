<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Form.Master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="ListenTo.Web.Views.Track.Edit" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Edit track - " + ViewData.Model.Track.Name + " | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FormPlaceHolder" runat="server">

    <form method="post" enctype="multipart/form-data" action="<%=this.Context.Request.Path%>">
        <h1>Edit your Track</h1>
        <%Html.RenderPartial("~/Views/Track/AddTrack.ascx");%>
    </form>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
	<div class="content">
	    <h2>Help!</h2>
	    <p>Adding a track to Listen To couldn't be easier. Well, it could, but it wouldn't be nearly so much fun.</p>
	    <p>On this page, add basic details about the artist, choose a web address to access them on ListenTo, and then upload a picture if you want.</p>
    </div>
</asp:Content>
