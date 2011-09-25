<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/ArtistInner.Master" Inherits="ListenTo.Web.Views.Artist.Gigs" %>

<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
     <%=Html.Title("Gigs | " +Html.Escape(ViewData.Model.Artist.Name) + " | Listen To Manchester - we love new manchester music")%>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">

  <div class="content">
    <h1><%=Html.Escape(ViewData.Model.Artist.Name)%><span class="hide"> - Gigs</span></h1>
          
    
     <%if (ViewData.Model.UpcomingGigs.Count == 0 && ViewData.Model.PreviousGigs.Count==0)
       { %>  
     <p><%=Html.Escape(ViewData.Model.Artist.Name)%> havent told us about any of their gigs. Sorry!<p>
    <%   }
       else
       { %> 
  
    <div id="col2" class="col2">
    <h2>Upcoming gigs</h2>
    
    
    <%if (ViewData.Model.UpcomingGigs.Count == 0)
      { %>  
        <p><%=Html.Escape(ViewData.Model.Artist.Name)%> havent told us about any upcoming gigs<p>
    <%}
      else
      {%>
        <%Html.RenderPartial("~/Views/Gig/GigList.ascx", ViewData.Model.UpcomingGigs);%>
    <%}%>
    </div>

    <div id="recentGigs" class="col1">
    <h2>Recent gigs</h2>
    
      <%if (ViewData.Model.PreviousGigs.Count == 0)
        { %>  
        <p><%=Html.Escape(ViewData.Model.Artist.Name)%> havent played any gigs yet (as far as we know).<p>
    <%}
        else
        {%>
       <%Html.RenderPartial("~/Views/Gig/GigList.ascx", ViewData.Model.PreviousGigs);%>
    <%}%>
    </div>
    <%} %>
    
    
    
   </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">


    <div class="content" >
        <h2>Fans</h2>
        <%Html.RenderPartial("~/Views/Shared/Fans.ascx", ViewData.Model.FansPartialViewModel); %>
    </div>
        <%Html.RenderPartial("~/Views/Shared/BecomeAFan.ascx");%>
    
</asp:Content>
