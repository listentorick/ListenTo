<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
<div class="content">
    <h2>Check your email</h2>
	<p>We've sent an email to you with your details. Please be patient - sometimes emails take a while to turn up. Use the time productively - maybe use it to search for that special edition Flaming Lips cd that you know is in the house somewhere, but you haven't seen for, oh, at least a year or two.</p>
	<p>If you dont recieve your email, check your junk or spam folder.</p>
</div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
	<div class="content">
		<h2>An admission!</h2>
    	<p>The story on the previous page about Ian Curtis was a lie. He did not repeatedly sing the Postman Pat theme tune, and Hooky did not punch him in the throat. It was the chorus of David Bowie's Laughing Gnome, and Hooky kicked him in the nuts.</p>
    </div>

</asp:Content>
