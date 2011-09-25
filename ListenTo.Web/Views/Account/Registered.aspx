<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" AutoEventWireup="true" CodeBehind="Registered.aspx.cs" Inherits="ListenTo.Web.Views.Account.Registered" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Almost done | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
<div class="content">
 <h1>Listen To registration - almost done</h1>
<p>There's one more thing we need you to do before you can play with Listen To.</p>

<p>So we can check you're real, and not one of Kraftwerk's freaky robots, we just sent you an email.</p>

<p>Check your email, delete your spam, get a bit sidetracked replying to your mate in Australia, then read the email from us and click on the enclosed web address.</p>

<p>This will return you to ListenTo and confirm your account.</p>
</div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
	<div class="content">
		<h2>True fact!</h2>
    	<p>Shaun Ryder has long been a registered member of the National Trust. For three years in the early nineties he was their honorary president, until an unfortunate smack-induced incident in the tea shop at Dunham Massey.</p>

    </div>
</asp:Content>