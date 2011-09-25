<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Form.Master" AutoEventWireup="true" CodeBehind="Add.aspx.cs" Inherits="ListenTo.Web.Views.Gig.Add" %>

<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>


<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title("Add a gig | Gigs | Listen To Manchester - we love new manchester music")%>
</asp:Content>



<asp:Content ID="Content1" ContentPlaceHolderID="FormPlaceHolder" runat="server">

	<form method="post" enctype="multipart/form-data" action="<%=Html.AddGigUrl()%>">
		<h1>Add a gig</h1>
		<%Html.RenderPartial("~/Views/Gig/AddGig.ascx");%>
	</form>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
	<div class="content">
        <h2>Oh, isn't that clever!</h2>
        <p>I won't lie to you, adding a gig to Listen To is pretty bloody easy. But because we like you, we've made it even easier! We're too good to you, we really are.</p>
        <p>When you add the bands and artists who are playing the gig, start typing and we'll suggest names that are already on Listen To - choose one of these, or just add your own. Same deal with the venue - start typing and we'll suggest venues we already know about. Simple, eh?</p>
    </div>
</asp:Content>
