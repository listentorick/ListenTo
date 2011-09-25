<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" Inherits="ListenTo.Web.Views.Radio.Index" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title("Radio | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">

<div class="content">
	<h1>Manchester Music Radio</h1>
        <ul class="tagCloud buttons">
        <%foreach (ListenTo.Shared.DTO.StyleSummary style in ViewData.Model.Styles)
          {
              if (style.NumberOfTracks > 0)
              {
        
                if (ViewData.Model.StylesToSelect.Contains(style))
                {
                  %>
<li><a id="<%=style.ID%>" href="#" class="style selected button">
                  <%
                }
                else
                {
                  %>
<li><a id="<%=style.ID%>" href="#" class="style button">
                  <%
                }
                  %>
<span><%=style.Name%><!-- (<%=style.NumberOfTracks%>)--></span></a></li>
              <%
            }
          } %>
        </ul>

</div>

<div class="content">
  <%Html.RenderPartial("~/Views/Shared/Player.ascx");%>
</div>

<script type="text/javascript" src="/content/js/radio.js"></script>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">

    <div class="content">
    	<h2>Manchester music, eh?</h2>
        <p>The Listen To radio player let's you hear the best new and unsigned music in Manchester. It's dead easy to use - select the styles you like over there on the left, and we'll pick you a playlist of songs at random.</p>
        <p>There's loads of songs on Listen To Manchester. Want to search through them all?  - <a href="http://www.listentomanchester.co.uk/track/list">find all the music on Listen To listed here</a>.</p>
        
    </div>
    <%Html.RenderPartial("~/Views/Shared/AddATrack.ascx");%>
</asp:Content>
