<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Form.Master" Inherits="ListenTo.Web.Views.NewsItem.Edit" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Edit your news - " + ViewData.Model.NewsItem.Name + " | News | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FormPlaceHolder" runat="server">

 <form method="post" enctype="multipart/form-data" action="<%=this.Context.Request.Path%>">
     <h1>Edit your News!</h1>
     <%Html.RenderPartial("~/Views/NewsItem/AddNewsItem.ascx", ViewData.Model);%>
</form>
        
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
    <div class="content">
        <h2>Help!</h2>
	    <p>Adding News to Listen To couldn't be easier. Well, it could, but it wouldn't be nearly so much fun.</p>
    </div>	
	
	<%Html.RenderPartial("~/Views/Shared/MarkDown.ascx");%>
</asp:Content>
