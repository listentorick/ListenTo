<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MvcApplication1.Views.Account.Login" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="header" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Login | Listen To Manchester - we love new manchester music" )%>
</asp:Content>


<asp:Content ID="loginContent" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
   <div class="content"> 
    <h1>Login</h1>

		   <form method="post" action="/Account/Login">
		   
		     <input type="hidden" name="ReturnUrl" value="<%=this.GetReturnUrl()%>" />
		    
		  <fieldset>
			  <p>
			  <label for="username">Username</label>
			  <%= Html.TextBox("username", null, new { @class = "text" })%>
			  <%=Html.ValidationMessage("username")%>
			  </p>
			  
			  <p>
			  <label for="password">Password</label>
			  <%= Html.Password("password", null, new { @class = "text" })%>
			  <%=Html.ValidationMessage("password")%>
			 </p>
			   			 
            <div>
                 <a href="<%=Html.RegisterAccountUrl()%>">
                 <img src="/content/images/buttons/register-top.gif" alt="Register" />
                 </a>
                <input type="image"  src="/content/images/buttons/login-top.gif" alt="Login" />
                <p><a href="<%=Html.RetrieveDetails()%>" title="Forgotten your password? Click here">Forgotten your username or password?</a></p>
            </div>
            
		  </fieldset>
		</form>
</div>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
<div class="content"> 
 	<h2>New In These Parts?</h2>
 	<p>Not registered? Why not? These are some of the things you can do when you register with ListenTo:</p>
 	<ul>

 		<li>Add reviews and articles</li>
 		<li>Rate songs, gigs, whatever</li>
 		<li>Add bands</li>
 		<li>Upload music</li>
 		<li>Create world peace (note: not available to all users)</li>
 	</ul>

 	<p>Registering is easy and free. So what you waiting for, punk?</p> 
 	<p><a class="moreLink" href="/account/register">Register with Listen To</a></p>
 </div>
 </asp:Content>