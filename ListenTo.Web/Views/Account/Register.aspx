<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Form.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="ListenTo.Web.Views.Account.Register" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title("Register | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FormPlaceHolder" runat="server">
   <form method="post" enctype="multipart/form-data" action="/account/register">
    <h1>Register</h1>
        <%Html.RenderPartial("~/Views/Account/AddUser.ascx");%>
   </form>
     
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
<div class="content">
<h2>Register?</h2>
<p>Registering is a ballache. We know that, but hey - it's not all bad!</p>
<p>Register and you can:</p>
<ul>
<li>access all music on the site - not just bands' latest tracks</li>
<li>rate music - so help songs move up the charts</li>
<li>add reviews and articles</li>
<li>add bands and upload music</li>
</ul>
<p>You'll also get your own profile page where other people can contact you.</p>
<p>So tell us some basic stuff about yourself, and we'll let you go play with ListenTo!</p>

<p>Why the faff and bother with typing in the weird security number? Because it stops automatic registrations that could be used for spammming our users, and cause untold other mischief. It checks you're a human, or in the case of Kraftwerk fans, a close approximation.</p>
</div>
</asp:Content>
