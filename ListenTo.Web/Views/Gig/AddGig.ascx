<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddGig.ascx.cs" Inherits="ListenTo.Web.Views.Gig.AddGig" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>	
<%@ Import Namespace="System.Web.Mvc" %>	

<script type="text/javascript" src="/content/js/addgig.js"></script>



		<fieldset>
			<h3>Bands</h3>

			<p><label for="bandsPlaying">Which bands are playing? <em>(required)</em>
			<small>Separate band names with a comma - eg 'Joy Division, Stone Roses, Frank Sidebottom'</small></label>
			
			
			    <%
			    //This is a special case.... the Models state key is not the same as field name (ActNames).
			    //This is to avoid the Acts collection being serialised into the field!            
                if (ViewData.ModelState["Acts"]!=null && ViewData.ModelState["Acts"].Errors.Count > 0)
                {
                    Response.Write(Html.TextArea("ActNames", null, new { @class = "small input-validation-error", rows = 3, cols = 20 }));
                }
                else
                {
                    Response.Write(Html.TextArea("ActNames", null, new { @class = "small", rows = 3, cols = 20 }));
                }		
		        %>
			
			<%=Html.Hidden("ArtistIds", null)%>
		    <%=Html.ValidationMessage("Acts")%>
		</fieldset>
		
		<fieldset>
		
			<h3>Venue</h3>
			
			<p><label for="Venue">Venue name <em>(required)</em></label>
			    <%
                    string selectedVenueClasses = "venues";
			        if(Html.AreKeysInvalid(new string[]{"Venue"})){
                        selectedVenueClasses += ", " + HtmlHelper.ValidationInputCssClassName;
                    }
		        %>
				
                <%=Html.DropDownList("SelectedVenue", (SelectList)ViewData["venues"], new { @class = selectedVenueClasses })%>
                <%=Html.ValidationMessage("SelectedVenue")%>
                <%=Html.ValidationMessage("Venue")%>
            </p>
            
         	<p><label for="Venue">If you cant find the venue in the list above add the name here<em>(required)</em></label>
                <%=Html.TextBox("VenueName", null, new { @class = "text" })%>
            </p>  
            
	    </fieldset>	
				
		<fieldset>
		
			<h3>Other details</h3>

			<p><label for="gigName">Gig name <em>(required)</em></label>
			<%=Html.TextBox("Name", null, new { @class = "text" })%>
			<%=Html.ValidationMessage("Name")%>
			</p>

 
            

		    <p><label for="day">Date <span class="hidden"> - day </span><em>(required)</em></label>
				<%=Html.DropDownList("day", (SelectList)ViewData["days"], new { @class = "dateDay" })%>
				<label for="month" class="hidden">Date - month<em>(required)</em></label>
				<%=Html.DropDownList("month",(SelectList)ViewData["months"], new { @class = "dateMonth" })%>
				<label for="year" class="hidden">Date - year <em>(required)</em></label>
				<%=Html.DropDownList("year",(SelectList)ViewData["years"], new { @class = "dateYear" })%>
				<%=Html.Hidden("linkedDates", "")%>
				<span id="StartDate_evaluated" class="empty"></span>
			    
		    </p>
		    
		    <p><label for="hour">Doors open at <em>(required)</em></label>
				<%=Html.DropDownList("hour", (SelectList)ViewData["hours"], new { @class = "dateHour" })%>
				<label for="month" class="hidden">Date - month<em>(required)</em></label>
				<%=Html.DropDownList("minute",(SelectList)ViewData["minutes"], new { @class = "dateMinute" })%> 
		    	<label for="ampm" class="hidden">Date - ampm<em>(required)</em></label>
				<%=Html.DropDownList("amPm",(SelectList)ViewData["amPm"], new { @class = "dateMinute" })%> 
		   
		    </p>
		    
			
<%--		    <p><label for="StartDate_Hour">Doors open at <em>(required)</em></label>
			    <%=Html.TextBox("StartDate.Hour", null, new { @class = "text" })%>
			    <%=Html.Hidden("DoorsJSValue", "")%>
			    <span id="Doors_evaluated" class="empty"></span>
			    
		    </p>--%>

		    <p><label for="TicketPrice">Ticket price</label>
		        <%=Html.TextBox("TicketPrice", null, new { @class = "text" })%>
		    </p>

		    <p><label for="Description">Any additional information?</label>
                <%=Html.TextArea("Description", null, new { @class = "expanding", @rows="10", @cols="20" })%>
                <%= Html.ValidationMessage("Description")%>
		    </p>
		    

	    </fieldset>

		<div class="formButtons">
		<input type="image" id="x" src="/content/images/buttons/addthisgig.gif" alt="Add this gig" />
		</div>
