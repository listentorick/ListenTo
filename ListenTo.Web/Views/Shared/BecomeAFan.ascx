<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="BecomeAFan.ascx.cs" Inherits="ListenTo.Web.Views.Shared.BecomeAFan" %>

<%if(ViewData.Model.IsUserFanOfArtist==false){ %> 
<div class="content callToAction">
    <h2>Be this band's fan!</h2>
    <p>Let them know you like them! Get updates on gigs, new music and band news. <a href="#" class="<%=ListenTo.Web.Constants.ViewClasses.BECOME_A_FAN_LAUNCH_POINT_CLASS%> <%=ListenTo.Web.Constants.ViewClasses.REQUIRES_LOGIN_LAUNCH_POINT_CLASS%> moreLink">Find out more<span class="hidden"> about being a fan</span></a></p>
    <p class="ctaButton"><a href="#" class="<%=ListenTo.Web.Constants.ViewClasses.BECOME_A_FAN_LAUNCH_POINT_CLASS%> <%=ListenTo.Web.Constants.ViewClasses.REQUIRES_LOGIN_LAUNCH_POINT_CLASS%>"><img src="/content/images/buttons/becomeafan.gif" alt="Become a fan"></a></p>
</div>	
<%} %>