<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddArtist.ascx.cs" Inherits="ListenTo.Web.Views.Artist.AddArtist" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>	
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="System.Web.Mvc" %>	
		
		<fieldset>
		
			<h3>Basic</h3>

			<p><label for="Name">Band/artist name <em>(required)</em></label>
			<%=Html.TextBox("Artist.Name", null, new { @class = "text" })%>
			<%=Html.ValidationMessage("Artist.Name")%>
			</p>
      
		    <p><label for="month">When did your band/artist start playing?<span class="hidden"> Year formed</span></label>
		        <%=Html.DropDownList("month",(SelectList)ViewData["months"],new { @class = "dateMonth" })%>
		        <label for="year" class="hidden">When did the band/artist start playing? Month formed</label>
		        <%=Html.DropDownList("year", (SelectList)ViewData["years"], new { @class = "dateYear" })%>
		    </p>
      
		    <p><label for="Description">Band/artist profile text - tell us about yourselves</label>
                <%=Html.TextArea("Artist.Profile", null, new { @class = "expanding", @rows="10", @cols="20" })%>
                  <%=Html.ValidationMessage("Artist.Profile")%>
		    </p>
		    
	        <%
                string selectedStyleClasses = string.Empty;
		        if(Html.AreKeysInvalid(new string[]{"Style"})){
                    selectedStyleClasses = HtmlHelper.ValidationInputCssClassName;
                }
	        %>
		    
		    <p><label for="styles">What style of music do you play?</label>
                <%=Html.DropDownList("SelectedStyle", (SelectList)ViewData["styles"], new { @class = selectedStyleClasses })%>
                <%=Html.ValidationMessage("Style")%>
		    </p>
		    
		    <%
                string selectedTownClasses = string.Empty;
		        if(Html.AreKeysInvalid(new string[]{"Town"})){
                    selectedTownClasses = HtmlHelper.ValidationInputCssClassName;
                }
	        %>
		    
		    <p><label for="towns">What town are you from?</label>
                <%=Html.DropDownList("SelectedTown", (SelectList)ViewData["towns"], new { @class = selectedTownClasses })%>
                <%=Html.ValidationMessage("Town")%>
		    </p>
		    
		    <p><label for="OfficalWebsiteURL">Your website address</label>
		        <%=Html.TextBox("Artist.OfficalWebsiteURL", null, new { @class = "text longText" })%>
		        <%=Html.ValidationMessage("Artist.OfficalWebsiteURL")%>
		    </p>

		    <p><label for="Email">Band/artist contact email (for alerts, eg when people become your fan, or send you a message)</label>
		        <%=Html.TextBox("Artist.Email", null, new { @class = "text longText" })%>
		        <%=Html.ValidationMessage("Artist.Email")%>
		    </p>

	    </fieldset>
	    
        <fieldset>
			<h3>Choose your ListenTo web address</h3>
			<p>Choose a web address for your band/artist's homepage on Listen To. You can pick one alphanumeric word (A-Z, a-z, 1-9 and underscores).</p>
		    <p><label for="ProfileAddress" class="inline"><span class="hidden">Web address - </span>http://www.listentomanchester.co.uk/</label>
              <%=Html.TextBox("Artist.ProfileAddress", null, new { @class = "text" })%>
              <%=Html.ValidationMessage("Artist.ProfileAddress")%>
		    </p>
        </fieldset>

         <%Html.RenderPartial("~/Views/Shared/UploadImagePopup.ascx", ViewData.Model.UploadImagePopupViewModel);%>

         
		<div class="formButtons">
		<input type="image" id="x" src="/content/images/buttons/addyourband.gif" alt="Add your band" />
		</div>
