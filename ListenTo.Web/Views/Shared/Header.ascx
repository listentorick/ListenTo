<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Header.ascx.cs" Inherits="ListenTo.Web.Views.Shared.Header" %>

<a href="#innerWrapper" id="skipLink">Skip to main content</a>

<div id="header">
  <div id="headerInner">
	  <h1><a href="/">Listen To Manchester - new and unsigned bands and music in Manchester<span></span></a></h1>
      
      <span id="betaBadge"><a class="thickbox img" href="#TB_inline?height=260&amp;width=500&amp;inlineId=betaInfo"><img src="/content/images/beta-badge.png" alt="Version 2 Beta! - find out more or report a problem" /></a></span>
	  
	  <%Html.RenderPartial("~/Views/Account/Login.ascx");%>
	  
  </div>
</div>

