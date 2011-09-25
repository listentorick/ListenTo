<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/ArtistInner.Master" Inherits="ListenTo.Web.Views.Artist.Music" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
     <%=Html.Title("Music | " +Html.Escape(ViewData.Model.Artist.Name) + " | Listen To Manchester - we love new manchester music")%>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">

<div class="content">

<h1><%=Html.Escape(ViewData.Model.Artist.Name)%><span class="hide"> - Music</span></h1>

  <%if (  ViewData.Model.Player.PlayList.Count==0){%>
    
    <p>Well, <strong><%=Html.Escape(ViewData.Model.Artist.Name)%></strong> havent uploaded any music yet</p>

    <p>Perhaps they're a conceptual avant garde band, and the silence you hear represents the dark well of despair present in all our mortal souls, pushing us with stark inevitability towards our lonely final endings.</p>

<p>More likely they just haven't got round to it yet.</p>



    
    <%} else {%>


<script type="text/javascript">

function configurePlaylist(playList)
{
    playList.enableLoopPlaylist();
    playList.addArtist("<%=ViewData.Model.Artist.ID%>");
}

</script>
   
   <%Html.RenderPartial("~/Views/Shared/Player.ascx");%>

	
	<%}%>
</div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">

   <div class="content" >
    <h2>Fans</h2>
     <%Html.RenderPartial("~/Views/Shared/Fans.ascx", ViewData.Model.FansPartialViewModel); %>
    </div>
        <%Html.RenderPartial("~/Views/Shared/BecomeAFan.ascx");%>


</asp:Content>
