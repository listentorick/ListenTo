<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
    <div class="content">
    	<h1>Error</h1>
        <p>Well, this is embarrassing. Not quite sure what happened there! But rest assured that our crack team of website experts (two monkeys in a shed with a typewriter hooked up to a lightbulb) are on the case.</p>
        
        <p>To help them in their tough job it would be spiffing if you could <a href="info@listentomanchester.co.uk">email details of what you were doing when the error happened</a>.</p>
        
        <p>If you've followed a link from a search engine, things may have moved. Your best bet is to go to the <a href="/">Listen To Manchester homepage</a> and start again from there. Sorry!</p>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
 <%=Html.Title( "Oops, an error | Listen To Manchester - we love new manchester music" )%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
</asp:Content>
