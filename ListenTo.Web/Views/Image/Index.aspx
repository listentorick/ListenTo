<%@ Page Language="C#" CodeBehind="Index.aspx.cs" Inherits="ListenTo.Web.Views.Image.Index"%>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Index</title>
    <script type="text/javascript">
        window.onload = function() {
            if (parent != window) {
                parent.ImageLoaded('<%=ViewData.Model.ID%>');
            }
        }
    </script>
</head>
<body>
<%=Html.RenderImage(ViewData.Model) %>
</body>
</html>
