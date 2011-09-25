<%@ Control Language="C#" AutoEventWireup="true" 
CodeBehind="BecomeAFanPopup.ascx.cs" 
Inherits="ListenTo.Web.Views.Shared.BecomeAFanPopup" %>

<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>		
<%@ Import Namespace="ListenTo.Web.Helpers" %>


 <%if (this.Context.User.Identity.IsAuthenticated){%>
<script type="text/javascript">
    // This script attaches the control above to any dom element with the class becomeAFanLaunchPoint applied 
    $(document).ready(function() {
        $(".becomeAFanLaunchPoint").each(
            function() {
                $(this).click(
                    function() {
                        var t = "Become a Fan!";
                        var thickBoxLink = "#TB_inline?height=245&amp;width=500&amp;inlineId=becomeFanDetails";
                        tb_show(t, thickBoxLink);
                        this.blur();
                        return false;
                    }
                );
            }
        );

    });
</script>


<div class="inPagePopup " id="becomeFanDetails">
	<form method="post" action="<%=Html.BecomeAFanUrl(ViewData.Model.Artist) %>">
  
	    <div id="reasonsToBecomeAFan">
			<h2>Become a fan of <%=ViewData.Model.Artist.Name%></h2>
    
		    <p>Be a fan of <%=ViewData.Model.Artist.Name%> and we'll help you connect with the band by letting you know when they add new <strong>gigs</strong>, <strong>music</strong> and <strong>news</strong>.</p>
			<p>You'll also let the band know that you like them, which will make them feel warm and fuzzy inside. Unless they're an experimental thrash metal band, in which case they'll feel slightly angrier than usual. But in a good way, y'know.</p> 
    	</div>
    	
 	    <div class="formButtons">
		    <input  type="image" id="x" src="/content/images/buttons/becomeafan.gif" alt="Become a fan" />
        </div>
    </form>
</div> 
<%}%>