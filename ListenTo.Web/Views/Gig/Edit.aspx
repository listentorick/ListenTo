<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Form.Master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="ListenTo.Web.Views.Gig.Edit" %>

<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title("Edit gig | Gigs | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FormPlaceHolder" runat="server">
    <%-- <%using (Html.Form("gig","edit")){ %>--%>
    
    <form method="post" enctype="mulitipart/form-data" action="<%=this.Context.Request.Path%>">
        <h1>Edit a gig</h1> 
        <%Html.RenderPartial("~/Views/Gig/AddGig.ascx");%>
    </form>
   <%--  <%} %>--%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
	<div class="content">
	    <h2>Help!</h2>
	    <p>Adding a gig to Listen To couldn't be easier. Well, it could, but it wouldn't be nearly so much fun.</p>
	    <p>Add all the details. When you add the bands, we'll suggest band names that are already on ListenTo - choose one of these, or add your own.</p>
    </div>
</asp:Content>
