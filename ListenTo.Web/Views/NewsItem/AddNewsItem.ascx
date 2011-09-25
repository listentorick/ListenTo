<%@ Control Language="C#" Inherits="ListenTo.Web.Views.NewsItem.AddNewsItem" %>

<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Shared.Validation" %>
					
		<fieldset>
		
			<h3>Article text</h3>

			<p><label for="Name">Headline <em>(required)</em></label>
			<%=Html.TextBox("NewsItem.Name", null, new { @class = "text" })%>
			<%=Html.ValidationMessage("NewsItem.Name")%>
			</p>

		    <p><label for="Description">Extract <em>(required)</em> - a couple of lines explaining what your news story is about</label>
                <%=Html.TextArea("NewsItem.Description", null, new { @class = "expanding small", @rows = "10", @cols = "10" })%>
                <%=Html.ValidationMessage("NewsItem.Description")%>
		    </p>
		    

		    <p><label for="Body">Body <em>(required)</em> - the text of your news article</label>
                <%=Html.TextArea("NewsItem.Body", null, new { @class = "expanding", @rows = "10", @cols = "20" })%>
                <%=Html.ValidationMessage("NewsItem.Body")%>
		    </p>
		    
	    </fieldset>
        
         <%Html.RenderPartial("~/Views/Shared/UploadImagePopup.ascx", ViewData.Model.UploadImagePopupViewModel);%>

                  
		<div class="formButtons">
		<input type="image" id="x" src="/content/images/buttons/addnews.gif" alt="Add News" />
		</div>


