<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Detail.Master" Inherits="ListenTo.Web.Views.Info.PrivacyPolicy" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>


<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <%=Html.Title( "Privacy Policy | Listen To Manchester - we love new manchester music" )%>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="PrimaryContentPlaceHolder" runat="server">
<div class="content">
	<h1>Privacy Policy</h1>

		<p>We are committed to protecting your 
		privacy. We will only use the information that we collect about you 
		lawfully (in accordance with the Data Protection Act 1998). </p>
		
		<p>We collect information about you for 
		2 reasons: firstly, to allow you to register with the website in order 
		to gain access to restricted functionality, and second, to provide you 
		with the best possible service and experience.</p>
		
		<p>Sometimes we may send information or 
		offers via email to selected groups of Listen To Manchester users on behalf 
		of ListenTo, Artists registered on ListenTo, or other organisations. These 
		emails are sent by ListenTo, 
		and your email address or any other identifying information will never 
		be given to any third party. If you do not wish to receive such information 
		please contact us on the email address below, or follow the instructions 
		in the email.</p>
		
		<p>We will give you the chance to refuse 
		any marketing email from us in the future.<br>
		</p>
		
		<p>The type of information we will collect 
		about you includes: </p>
		<ul>
		  <li>your name</li>
		  <li>email address</li>
		  <li>the general geographic area 
		  that you live in</li>
		  <li>the type of music that you 
		  like</li>
		</ul>
		<p>It is your responsibility to keep this 
		information accurate and up to date, as specified in our Terms and Conditions. 
		You can amend the information that we hold about you by logging into 
		your account and editing your profile. If you wish to completely remove 
		your account, please contact us on the email address below.
		</p>
		<p>We will never collect sensitive or 
		personal information about you without your explicit consent. 
		</p>
		<p>The personal information which we hold 
		will be held securely in accordance with the law. </p>
		<p>If we intend to transfer your information 
		outside the EEA (European Economic Area) we will always obtain your 
		consent first. </p>
		<p>We may use technology to track the 
		patterns of behaviour of visitors to our site. This may include using 
		a "cookie" which would be stored on your browser. You can 
		usually modify your browser to prevent this happening. The information 
		collected in this way can be used to identify you unless you modify 
		your browser settings.</p>
		
		<p>This privacy policy only covers the 
		Listen To Manchester website at <a href="http://www.listentomanchester.co.uk">www.listentomanchester.co.uk</a>. Websites 
		we link to from within this site are not covered by this policy.</p>
</div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="SecondryContentPlaceHolder" runat="server">
<div class="content callToAction">
		<h2>Contact Us</h2>
		<p>If you have any questions/comments 
		about our privacy policy, please contact us at <a href="mailto:info@listentomanchester.co.uk">info@listentomanchester.co.uk</a></p>
</div>
</asp:Content>
