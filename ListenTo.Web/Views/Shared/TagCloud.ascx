<%@ Control Language="C#" Inherits="ListenTo.Web.Views.Shared.TagCloud" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>

<div class="tagCloud content">
	<h2>Styles</h2>
    <ul class="tagCloud">
    
    
<%

string[] cssClasses = new[] { "weight1", "weight2", "weight3", "weight4", "weight5", "weight6", "weight7" };

foreach (ListenTo.Web.Models.TagViewModel tag in ViewData.Model.Tags)
{
    int index = Convert.ToInt32(Math.Floor((tag.Count / ViewData.Model.Max) * cssClasses.Length));

    if (index == cssClasses.Length) index -= 1; //The last tag might exceed the css classes length.

    string cssClass = cssClasses[index];
%>
    <li class="<%=cssClass%>"><a href="<%=tag.URL%>"><%=tag.Tag%></a></li>
<%
}
%>

	</ul>
</div>

