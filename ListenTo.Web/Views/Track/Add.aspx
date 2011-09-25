<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Form.Master" Inherits="ListenTo.Web.Views.Track.Add" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Add music | Listen To Manchester - we love new manchester music" )%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FormPlaceHolder" runat="server">

    <form method="post" enctype="multipart/form-data" action="<%=Html.AddTrackUrl() %>">
        <h1>Add music</h1>
        <%Html.RenderPartial("~/Views/Track/AddTrack.ascx");%>
    </form>

</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
	<div class="content">
	    <h2>Uploading music? Oh?</h2>
	    <p>Let people hear your beautiful music! Fill in details about the track, and upload the file. Pretty straightforward, I'm sure you'll agree.</p>
	    <p>One thing, though - we can only use songs in MP3 format. So no AAC, no WMA, and you know where you can stick your Ogg Vorbis, you big cuddly geek.</p>
	    <p>Remember that uploading your song might take a while. Only press the button once, then chill out for a bit. Make a cup of tea, maybe listen to some old Beta Band tunes. That's what I'd do, anyway.</p>
    </div>
</asp:Content>
