<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title("Forgotten your password? | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
<div class="content">
 <h1>Forgotten your username or password?</h1>
 <p>Well that was silly, wasn't it. Enter your email address below, and we'll send you your username and password.</p>
 
    <form method="post" action="<%=Html.DetailsRetrieved() %>">
    	<fieldset>
		  <p>
		    <label for="email">Email address</label>
		    <%= Html.TextBox("emailAddress", null, new { @class = "text" })%> <input type="image" id="x" src="/content/images/buttons/senddetails.gif" alt="Send details" />
		  </p>
		</fieldset>
    </form>			  

</div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
	<div class="content">
		<h2>True fact!</h2>
    	<p>Ian Curtis once forgot the lyrics to all his songs in a Joy Division gig. He repeatedly sang the theme tune from Postman Pat until Hooky punched him in the throat.</p>

    </div>
</asp:Content>