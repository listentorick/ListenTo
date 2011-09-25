<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddUser.ascx.cs" Inherits="ListenTo.Web.Views.Account.AddUser" %>

<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>	

				<p><strong>If you're an artist or in a band</strong>, register here first and then go to 'Add Content' to add your band afterwards. Otherwise your band won't be listed on Listen To, and you won't be able to upload your music!</p>

				<h2 class="hidden">Registration Form</h2>
				<fieldset>
					<h3>1 User Info</h3>
					
			        <p><label for="Username">Username <em>(required)</em></label>
			        <%=Html.TextBox("Username", null, new { @class = "text" })%>
			        <%=Html.ValidationMessage("Username")%>
			        </p>
              
      	            <p><label for="Password">Password <em>(required)</em></label>
			        <%=Html.Password("Password", null, new { @class = "text" })%>
			        <%=Html.ValidationMessage("Password")%>
			        </p>

      	            <p><label for="ConfirmPassword">Confirm Password <em>(required)</em></label>
			        <%=Html.Password("ConfirmPassword", null, new { @class = "text" })%>
			        <%=Html.ValidationMessage("ConfirmPassword")%>
			        </p>

			        <p><label for="EmailAddress">Email Address <em>(required)</em></label>
			        <%=Html.TextBox("EmailAddress", null, new { @class = "text" })%>
			        <%=Html.ValidationMessage("EmailAddress")%>
			        </p>		
        					
			        <p><label for="ConfirmEmail">Confirm Email Address <em>(required)</em></label>
			        <%=Html.TextBox("ConfirmEmailAddress", null, new { @class = "text" })%>
			        <%=Html.ValidationMessage("ConfirmEmailAddress")%>
			        
			        
			        </p>	
					
			    </fieldset>
	
				<fieldset>
					<h3>2 The Newsletter</h3>
					<p class="checkbox">
					<%=Html.CheckBox("RecievesNewsletter")%>	
					<label for="RecievesNewsletter">Send me the ListenTo newsletter.</label></p>
					<p>The ListenTo newsletter is sent at most once
					every two weeks and contains site updates and details of new bands,
					reviews, articles and more. We will <strong>never</strong> sell or pass on your
					email address to anyone else, and we promise we won't spam you with
					viagra adverts or Nigerian money scams. Read our <a href="/privacypolicy.aspx" target="_blank" title="(opens a new window)">privacy policy</a>.</p>
					
				</fieldset>



				<fieldset>
					<h3>3 Our Terms and Conditions and our Privacy Policy</h3>
					
					
					<p class="checkbox">
					<%=Html.ValidationMessage("Policy")%>
					<%=Html.CheckBox("Policy", false)%>		
					<label for="Policy"> I have read and accept the 
					<a href="/info/termsandconditions" target="_blank" title="(opens a new window)">Terms &amp; Conditions</a> of our service and our <a href="/info/privacypolicy" target="_blank" title="(opens a new window)">Privacy Policy</a> (links open a new window).</label>
					</p>
				</fieldset>


			    <div class="formButtons">
		            <input type="image" id="x" src="/content/images/buttons/register.gif" alt="Register" />
		        </div>
