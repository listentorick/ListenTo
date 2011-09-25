<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UploadImage.ascx.cs" Inherits="ListenTo.Web.Views.Shared.UploadImage" %>
 <p><label for="postedFile">Upload your image</label>
    <input type="file" id="postedFile" name="postedFile"/>
    <p>
     <% if (ViewData["profileImage"] != null) {
        Html.RenderPartial("~/Views/Shared/Image.ascx",ViewData["profileImage"]);
            
            %>
            <p><label for="deleteImage">Delete Image</label>
                <input type="checkbox" id="deleteImage" name="deleteImage" />
            </p>
            <%
            
    } %>
    </p>
     <%=Html.Hidden("ProfileImage.ID")%>
</p>


