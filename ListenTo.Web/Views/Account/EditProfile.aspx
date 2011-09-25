<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Form.Master" Inherits="ListenTo.Web.Views.Account.EditProfile" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>
	
<asp:Content ID="Content4" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Edit Profile | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FormPlaceHolder" runat="server">

	<h1>Edit your profile</h1>
	<form method="post" enctype="multipart/form-data" action="<%=this.Context.Request.Path%>">
    	<h2 class="hidden">Edit profile form</h2>
    	<fieldset>
            <h3>1 Personal details</h3>
            <p>Remember - <strong>this isn't the place to put your band details!</strong> Go to the <a href="/artist/add">add a band page</a> page to do that - otherwise it won't be listed on Listen To, and you won't be able to upload your music.</p>
            
            <p><label for="Forename">Forename <em>(required)</em></label>
            <%=Html.TextBox("UserProfile.Forename", null, new { @class = "text" })%>
            <%=Html.ValidationMessage("UserProfile.Forename")%>
            </p>		
            
            <p><label for="Surname">Surname <em>(required)</em></label>
            <%=Html.TextBox("UserProfile.Surname", null, new { @class = "text" })%>
            <%=Html.ValidationMessage("UserProfile.Surname")%>
            </p>		
            
            <p><label for="Surname">Tell us about yourself</label>
            <%=Html.TextArea("UserProfile.Profile", null, new { @class = "expanding", @rows = "10", @cols = "20" })%>
            <%=Html.ValidationMessage("UserProfile.Profile")%>
            </p>	

	</fieldset>
	
	
    <fieldset>
		<h3>2 What you like</h3>
		<p class="label">Select the music you like:</p>
		<ul class="radioButtons">
        <% 
        bool hasStyle = false;
        foreach (ListenTo.Shared.DTO.StyleSummary s in ViewData.Model.StyleSummaries)
        {
            hasStyle = UserProfileHelper.UserProfileHasStyle(ViewData.Model.UserProfile, s); 
           if (hasStyle)
           {%>
                <li><label><input type="checkbox" name="Styles" checked="true" value="<%=s.ID%>"/><%=s.Name%></label></li>
           <%}
           else
           {%>
                <li><label><input type="checkbox" name="Styles" value="<%=s.ID%>"/><%=s.Name%></label></li>
           <%}
        }%>
		</ul>
	</fieldset>

     <%Html.RenderPartial("~/Views/Shared/UploadImagePopup.ascx", ViewData.Model.UploadImagePopupViewModel);%>


    <div class="formButtons">
        <input type="image" id="x" src="/content/images/buttons/update.gif" alt="Update" />
    </div>

    </form>
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
<div class="content">
<h2>Help</h2>
<p>Tell other Listen To users about yourself - who you are, and what you like.</p>
</div>
</asp:Content>
