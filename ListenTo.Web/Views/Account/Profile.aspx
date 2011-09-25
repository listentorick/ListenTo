<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Account.Master" Inherits="ListenTo.Web.Views.Account.Profile" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content4" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Profile | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
  <div class="content">	<h1>Who is <%=ViewData.Model.UserProfile.Username%></h1>    <%Html.RenderPartial("~/Views/Account/ProfileDetail.ascx", ViewData.Model.UserProfile); %>    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
</asp:Content>
