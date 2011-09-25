<%@ Page Title="" Language="C#"  Inherits="ListenTo.Web.Views.Image.Upload" %>

<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

<script type="text/javascript">

    function postImage() {
        document.forms[0].submit();
    }
    
    <%
    if(ViewData.Model.ImageUploadSuccesful==true){ 
    %>
    
     window.onload = function() {
            if (parent != window) {
                parent.imageUploadSuccessful('<%=ViewData.Model.Image.ID%>');
            }
        }
    
    <%} %>
</script>
</head>
<body>

<form method="post" enctype="multipart/form-data" action="/image/upload">
    <%
        
        bool invalidFile = Html.AreKeysInvalid(new string[] { "Data" });
    %>

    <%if (invalidFile)
      { %>
        <div class="validateError">
        <p class="validateError"><%=Html.ValidationMessage("Data")%></p>
    <%}
      else
      {%>
      <div>
    <%} %>

    <%Html.RenderPartial("~/Views/Shared/UploadFile.ascx", ViewData.Model.UploadFilePartialViewModel);%>
    <p>Sometimes it takes a long time to send your files across the internet. Dont keep pressing the upload button! It'll only slow things down even more. Chill out, sit back and make a brew, 
    maybe listen to some old Jeff Buckley songs.</p>

<%--	<div class="formButtons">
	<input type="image" id="x" src="/content/images/buttons/addnews.gif" alt="Add Image" />
	</div>
		--%>
</div>


</form>
</body>
</html>