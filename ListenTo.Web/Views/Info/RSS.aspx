<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" Inherits="ListenTo.Web.Views.Info.RSS" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>


<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "TermsAndConditions" )%>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
<h1>TermsAndConditions</h1>
    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">


</asp:Content>
