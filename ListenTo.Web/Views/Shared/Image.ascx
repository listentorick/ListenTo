<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Image.ascx.cs" Inherits="ListenTo.Web.Views.Shared.Image" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<% if(ViewData.Model!=null){ %>

 <%=Html.RenderImage(ViewData.Model)%>

<%} %>