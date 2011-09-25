<%@ Page Title=""  Language="C#" MasterPageFile="~/Views/Shared/Form.Master" Inherits="ListenTo.Web.Views.NewsItem.Add" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="FormPlaceHolder" runat="server">

 <form method="post" enctype="multipart/form-data" action="<%=Html.AddNewsItemUrl()%>">
     <h1>Add a news article</h1>
    <%-- This is a bit crap - if the NewsItemEditViewModel.NewsItem is null, the framework passes the NewsItemEditViewModel through to the view....---%> 
<%--    
     <%if (ViewData.Model != null && ViewData.Model.NewsItem != null)
     { %>--%>
        <%Html.RenderPartial("~/Views/NewsItem/AddNewsItem.ascx", ViewData.Model);%>
<%--     <%} else {%>
        <%Html.RenderPartial("~/Views/NewsItem/AddNewsItem.ascx");%>
     <%} %>--%>
</form>
        
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">

	        <%Html.RenderPartial("~/Views/Shared/MarkDown.ascx");%>

<div class="content callToAction">
	<h2>Talking about a gig?</h2>
	<p>Don't forget to also add the gig to Listen To so it appears in our listings! Ta, petal.</p>
	<p class="ctaButton">
	<a href="/gig/add"><img src="/content/images/buttons/addagig.gif" alt="Add a gig" /></a></p>
</div>

</asp:Content>
