$(document).ready(
        function() {
            $('#showUploadImagePopupButton').click(
                function(e) {
                    e.preventDefault();
                    showUploadImagePopup();
                    return false;
                }
            );

            $('#useUploadedImageButton').click(
                function(e) {
                    e.preventDefault();
                    useUploadedImage();
                    return false;
                }
            );

            $('#uploadImageButton').click(
                function(e) {
                    e.preventDefault();
                    var iframe = $('#uploadImagePopupIframe');
                    var iframeContentWindow = iframe[0].contentWindow;
                    iframeContentWindow.postImage();
                    return false;
                }
            );
        }
    );

function showUploadImagePopup() {
    var t = "Upload an image!";
    $('#uploadImagePopupContentProxy').addClass("show");
    $('#uploadImagePopupContentProxy').removeClass("hide");
    $('#uploadImagePopupContent').addClass("hide");
    $('#uploadImagePopupContent').removeClass("show");

    var thickBoxLink = "#TB_inline?height=220&amp;width=500&amp;inlineId=uploadImagePopup";
    tb_show(t, thickBoxLink);

    $("#uploadImagePopupIframe").load(uploadImagePopupReady);
    $("#uploadImagePopupIframe").attr("src", "/image/upload");

    this.blur();
    return false;
}

function uploadImagePopupReady(elem) {

    $("#TB_window").addClass("show");
    $("#TB_window").removeClass("hide");
    $('#uploadImageButton').removeClass("hide");
    $('#uploadImageButton').addClass("show");
    $('#useUploadedImageButton').removeClass("show");
    $('#useUploadedImageButton').addClass("hide");
    $('#changeImagePopupButtons').removeClass("hide");
    $('#changeImagePopupButtons').addClass("show");

    $('#uploadImagePopupContentProxy').addClass("hide");
    $('#uploadImagePopupContentProxy').removeClass("show");

    $('#uploadImagePopupContent').addClass("show");
    $('#uploadImagePopupContent').removeClass("hide");
    //Remove the load event
    $("#uploadImagePopupIframe").unbind("load");
}

function imageUploadSuccessful(imageId) {
    //Set the hidden fields value...
    $('#uploadImagePopupImageID').val(imageId);
    $('#imageSelectedContainer').removeClass("hide");
    $('#imageSelectedContainer').addClass("show");
    $('#changeImageCallToAction').addClass("show");
    //The url shouldnt be hardcoded here. Knock up an action to return the path..
    $('#currentImageContainer').html("<img src=\"/content/images/uploadedimages/" + imageId + ".jpg\" width=\"172px\"/>");
    //hide the popup
    tb_remove();
}

