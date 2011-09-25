<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" Inherits="ListenTo.Web.Views.WhoIs.Index" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
     <%=Html.Title("Who is " + Html.Escape(ViewData.Model.UserProfile.Username) + "? | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">

    <div class="content">
		<h1>Who is <%=ViewData.Model.UserProfile.Username%></h1>
        
        <%Html.RenderPartial("~/Views/Account/ProfileDetail.ascx", ViewData.Model.UserProfile); %>
    </div>

    <%if(ViewData.Model.UsersActions.Count>0){ %>
    <div class="content">
        <h2>Recent actions</h2>
        <%Html.RenderPartial("~/Views/Shared/ActionList.ascx", ViewData.Model.UsersActions); %>
	</div>
	<%}%>
	
 <%if (ViewData.Model.Comments != null) { Html.RenderPartial("~/Views/Shared/CommentList.ascx", ViewData.Model.Comments); }%>
 <%Html.RenderPartial("~/Views/Shared/AddComment.ascx", ViewData.Model.AddCommentViewModel); %>
 

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">

<div class="content">
 <h2>Bands liked</h2>
     <%Html.RenderPartial("~/Views/Shared/BandsLiked.ascx", ViewData.Model.BandsLikedPartialViewModel); %>
     </div>
</asp:Content>
