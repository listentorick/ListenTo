<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" AutoEventWireup="true" CodeBehind="Approve.aspx.cs" Inherits="ListenTo.Web.Views.Account.Approve" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Registered! | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
<div class="content">
	<h1>Registered</h1>
	<p>Hello again, fancy seeing you here. You're all registered now on Listen To. Well done you!</p>

	<p>There's loads of things you could do now, start by logging in...</p>

    <form method="post" action="/Account/Login">
		   
	  <input type="hidden" name="ReturnUrl" value="/home/index" />
	    
	  <fieldset>
        <p>
            <label for="username">Username</label>
            <%= Html.TextBox("username", null, new { @class = "text" })%>
        </p>

        <p>
            <label for="password">Password</label>
            <%= Html.Password("password", null, new { @class = "text" })%>
        </p>

        <div class="formButtons">
            <input type="image" id="Image1" src="/content/images/buttons/login.gif" alt="Login" />
        </div>
	  </fieldset>
	</form>
</div>
</asp:Content>

