<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Track.AddTrack" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>	
<%@ Import Namespace="System.Web.Mvc" %>	

		<%if(ViewData.Model.UserHasArtists==true){ %>
		
		        <fieldset>

			<h3>Upload your music - mp3 only</h3>
		    <p><label class="hidden" for="postedFile">Upload the file - mp3 only</label>
		    
		        <%
                bool invalidFile = Html.AreKeysInvalid(new string[] { "Track.Data" });
                bool temporaryFileExists = ViewData.Model.HasValidTemporaryFile;
                bool persistedFileExists = ViewData.Model.HasPersistedTrackData;
                %>
		        
		        <%if (invalidFile) { %>
		        <div class="validateError">
		        <p class="validateError"><%=Html.ValidationMessage("Track.Data")%></p>
                <%} %>
                
                <%if (temporaryFileExists)
                { %>
                <p><strong>Well done you've uploaded an mp3!</strong></p>
                <p><strong>You can change it at any time by selecting another file on your computer!</strong></p>
                <%} %>

                <%if (persistedFileExists)
                { %>
                <p><strong>You've already uploaded an MP3 for this track</strong></p>
                <p><strong>You can change it at any time by selecting another file on your computer!</strong></p>
                <%} %>
                
	            <%Html.RenderPartial("~/Views/Shared/UploadFile.ascx", ViewData.Model.File);%>
                <p>Sometimes it takes a long time to send your files across the internet. Dont keep pressing the upload button! It'll only slow things down even more. Chill out, sit back and make a brew, 
                maybe listen to some old Jeff Buckley songs.</p>
 
		        <%if (invalidFile) { %>
		        </div>
                <%} %>
                
		    </p>
         </fieldset>
		
		<fieldset>
		    <h3>Written/Recorded by</h3>
		
		    <%
                string selectedArtistClasses = string.Empty;
		        if(Html.AreKeysInvalid(new string[]{"Track.Artist"})){
                    selectedArtistClasses = HtmlHelper.ValidationInputCssClassName;
                }
	        %>
	        <p>Pick the band that wrote/recorded this music from the drop down list below...</p>
	        <p>You can only add music for bands <strong> you have added</strong>, so if you havent added the band yet <a href="<%=Html.AddArtistUrl() %>">go add them</a></p>
  
		    <p><label for="styles">Band/artist <em>(required)</em></label>
		        
                <%=Html.DropDownList("Track.OwnedArtist", ViewData.Model.OwnedArtists, new { @class = selectedArtistClasses })%>
		    </p>
		
		</fieldset>
		
		
		<fieldset>
		
			<h3>Track details</h3>
            <%=Html.Hidden("ID")%>
			<p><label for="Track">Track name <em>(required)</em></label>
			<%=Html.TextBox("Track.Name", null, new { @class = "text" })%>
			<%=Html.ValidationMessage("Track.Name")%>
			</p>

		    <p><label for="Description">Description - tell us a bit about it</label>
                <%=Html.TextArea("Track.Description", null, new { @class = "expanding", @rows = "10", @cols = "20" })%>
		    </p>
  
		    
		    <%
                string selectedStyleClasses = string.Empty;
		        if(Html.AreKeysInvalid(new string[]{"Track.Style"})){
                    selectedStyleClasses = HtmlHelper.ValidationInputCssClassName;
                }
	        %>
		    
		    <p><label for="styles">Style <em>(required)</em></label>
                <%=Html.DropDownList("SelectedStyle", (SelectList)ViewData["styles"], new { @class = selectedStyleClasses })%>
                <%=Html.ValidationMessage(ValidationStateKeys.TRACK_NEEDS_A_STYLE)%>
		    </p>
		    

	    </fieldset>
	    

         
		<div class="formButtons">
		<input type="image" id="x" src="/content/images/buttons/addyourtrack.gif" alt="Add your track" />
		</div>
<% } else  {%>
<p>Before you can upload some music you need to add the band the music belongs to.</p>
<p><a href="<%=Html.AddArtistUrl() %>">Add a band!</a></p>

<%} %>