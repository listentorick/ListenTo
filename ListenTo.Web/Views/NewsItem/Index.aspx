<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" Inherits="ListenTo.Web.Views.NewsItem.Index" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>


<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">

        <%=Html.Title(Html.Escape(ViewData.Model.NewsItem.Name) + " | News | Listen To Manchester - we love new manchester music")%>

</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">

    <div class="content">
		<h1><%=Html.Escape(ViewData.Model.NewsItem.Name)%></h1>
        
        <div class="inlineImage">
        
            <%= Html.RenderImage(ViewData.Model.NewsItem.Image, "profileImage", ViewData.Model.NewsItem.Name, new { width = "300" })%>
       
        </div>

         <dl class="columnList">
			<dt>Author</dt><dd><a href="<%=Html.ViewWhoIsUrl(ViewData.Model.AuthorUserProfile.Username) %>"><%=ViewData.Model.AuthorUserProfile.Username%></a></dd>
			<dt>Published on</dt><dd><%=Html.RenderDate(ViewData.Model.NewsItem.Created)%></dd>
		</dl>


	    <%=Html.TextToHtml(ViewData.Model.NewsItem.Body)%>
	    
	</div>
	
 <%if (ViewData.Model.Comments != null) { Html.RenderPartial("~/Views/Shared/CommentList.ascx", ViewData.Model.Comments); }%>
 <%Html.RenderPartial("~/Views/Shared/AddComment.ascx", ViewData.Model.AddCommentViewModel); %>
 
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
 <%Html.RenderPartial("~/Views/Shared/AddANewsItem.ascx");%>

</asp:Content>
