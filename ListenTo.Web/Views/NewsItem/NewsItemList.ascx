<%@ Control Language="C#" Inherits="ListenTo.Web.Views.NewsItem.NewsItemList" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<ul class="itemsList">
    <% foreach (ListenTo.Shared.DTO.NewsItemSummary newsItemSummary in ViewData.Model)
       {%>
        
        <%if (ViewData.Model.IndexOf(newsItemSummary) == 0)
          {%>
        <li class="firstItem">
        <% }
          else{%>
          <li>
        <% }%>
		
        <%=Html.RenderImage(newsItemSummary.Thumbnail, "thumb!", newsItemSummary.Name, new {})%>

        <%if (Html.IsOwner(newsItemSummary))
        { %>

        <p class="edit">
            <a href="<%=Html.EditNewsItemUrl(newsItemSummary)%>">
                <img src="/content/images/buttons/edit.gif" alt="Edit: <%=Html.Escape(newsItemSummary.Name)%>" />
            </a>
        </p>
            
         <%} %>

        <a id="<%=newsItemSummary.ID%>" href="<%=Html.ViewNewsItemUrl(newsItemSummary)%>"><strong><%=Html.Escape(newsItemSummary.Name)%></strong></a>
      
        <br /> <%=Html.Escape(newsItemSummary.Description)%>
        <br /> by <a href="<%=Html.ViewWhoIsUrl(newsItemSummary.OwnerUsername) %>"><%=newsItemSummary.OwnerUsername%></a>   <%=Html.RenderDate(newsItemSummary.Created)%>
    </li>
    <%} %>
</ul>