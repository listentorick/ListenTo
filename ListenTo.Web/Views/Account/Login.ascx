<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Login.ascx.cs" Inherits="ListenTo.Web.Views.Account.Login" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %> 
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>	  

	
	<%if (!this.Context.User.Identity.IsAuthenticated) {%>
	  <div class="loginPanel">
		  <h2>Login or Register</h2>
		   <form method="post" action="/Account/Login">
		   
		     <input type="hidden" name="ReturnUrl" value="<%=this.GetReturnUrl()%>" />
		    
		  <fieldset>
			  <p>
			  <label for="Username">Username</label>
			  <%= Html.TextBox("Username", null, new { @class = "text" })%>
			  </p>
			  
			  <p>
			  <label for="Password">Password</label>
			  <%= Html.Password("Password", null, new { @class = "text" })%>
			 </p>
  			 
			   <div class="formButtons">
                    <a href="/Account/Register">
                        <img src="/content/images/buttons/register-top.gif" alt="Register" />
                    </a>
			   	    <input type="image" id="Image1" src="/content/images/buttons/login-top.gif" alt="Login" />
			   	    <p><a href="<%=Html.RetrieveDetails()%>" title="Forgotten your password? Click here">Forgotten your username or password?</a></p>
			   </div>
		  </fieldset>
		</form>
      <!-- AddThis Button BEGIN -->
<a class="addthis_button" href="http://www.addthis.com/bookmark.php?v=250&amp;pub=listentomanchester"><img src="http://s7.addthis.com/static/btn/v2/lg-share-en.gif" width="125" height="16" alt="Bookmark and Share" style="border:0"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=listentomanchester"></script>
<!-- AddThis Button END -->


	  </div>
 	<%} else {%>
	  <div class="loggedInPanel">
		    <h2>Your details</h2>
            <p>Hello <a href="<%=Html.WhatsNewUrl(this.Context.User.Identity.Name)%>"><strong><%=this.Context.User.Identity.Name%></strong></a>. Fancy seeing you here!</p>
            <div class="formButtons">
                
                <a href="<%=Html.WhatsNewUrl(this.Context.User.Identity.Name)%>"><img src="/content/images/buttons/yourhomepage-top.gif" alt="Go to your homepage" /></a>
      
                <form method="post" action="/Account/Logout">
                	<input type="image" src="/content/images/buttons/logout-top.gif" alt="Logout" />
                </form>
			</div>
      <!-- AddThis Button BEGIN -->
<a class="addthis_button" href="http://www.addthis.com/bookmark.php?v=250&amp;pub=listentomanchester"><img src="http://s7.addthis.com/static/btn/v2/lg-share-en.gif" width="125" height="16" alt="Bookmark and Share" style="border:0"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=listentomanchester"></script>
<!-- AddThis Button END -->

	  </div>
	<%} %>
