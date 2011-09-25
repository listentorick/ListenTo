<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.UploadImagePopup" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>

<script src="/content/js/uploadimagepopup.js" type="text/javascript" ></script>			
         
<fieldset>
    <h3>Upload an Image</h3>
    <div>
    
          <%
          Guid? currentImageID = null;
          if (ViewData.Model != null && ViewData.Model.ImageMetaData != null)
          {
              currentImageID = ViewData.Model.ImageMetaData.ID;
          } 
        %>
    
	    <div>
	        <p id="imageSelectedContainer" <%if(currentImageID.HasValue==false){%> class="hide" <%}%>>You have selected the image below</p>
	        <div id="currentImageContainer" style="clear:both;">
	        <%if(currentImageID.HasValue) { %>
	            <%=Html.RenderImage(ViewData.Model.ImageMetaData, "UploadedImage", "Uploaded Image", new { width = "172" })%>
            <%} %>
            </div>
	    </div>
 
        <%=Html.Hidden("uploadImagePopupImageID", currentImageID)%>
	    <div id="uploadAnImageCallToAction" class="show">
	        <p>Pick a jpg or gif from your computer... </p>
	        <p><a href="#" id="showUploadImagePopupButton" class="style button">
                <span>Upload Image >> </span>
                </a>  
            </p> 
	      
	    </div>
		
    </div>

</fieldset>


<div class="inPagePopup" id="uploadImagePopup">
    
    <div id="uploadImagePopupContentProxy" class="show">
    </div>
    <div id="uploadImagePopupContent" class="hide">
        <h2>Upload an image!</h2>
        <div class="uploadImageIframeWrapper">
            <iframe id="uploadImagePopupIframe" frameborder="0"></iframe>
        </div>
        <div id="uploadImagePopupButtons">
                <p><a href="#" id="uploadImageButton" class="style button"  alt="Upload your selected image">
                <span>Upload Image >> </span>
                </a></p>     
        </div>
    </div>
</div>
