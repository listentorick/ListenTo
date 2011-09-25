<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NextGig.ascx.cs" Inherits="ListenTo.Web.Views.Shared.NextGig" %>
	
				<div class="content">
					<h2>Next gig</h2>
					<ul class="itemsList">
						<li>
			                <%Html.RenderPartial("~/Views/Gig/GigListItem.ascx", ViewData.Model);%>
						</li>
					</ul>	
				</div>
