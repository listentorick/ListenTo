<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.UploadFile" %>

    <%-- 
     This view is used only to upload files and to track a temporary file between posts and display the currently uploaded file...
     It is not designed to manage deletion of files. 
     THIS IS NOT ITS RESPONSIBILITY.
     --%>
    <input type="file" id="POSTEDFILE" name="POSTEDFILE"/>
    <input type="hidden" id="FILEID" name="FILEID" value="<%=ViewData.Model.ID%>" />

