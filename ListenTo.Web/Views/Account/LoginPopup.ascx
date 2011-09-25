<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="ListenTo.Web.Helpers" %>
<%@ Import Namespace="ListenTo.Web.Helpers.HtmlHelperExtensions" %>



 <%if (!this.Context.User.Identity.IsAuthenticated){%>
<script type="text/javascript">

    $(document).ready(function() {
        $(".<%=ListenTo.Web.Constants.ViewClasses.REQUIRES_LOGIN_LAUNCH_POINT_CLASS%>").each(
            function() {
                $(this).click(
                    function() {
                        showLoginPopup();
                        return false;
                    }
                );
            }
        );

    });
</script>


<div class="inPagePopup " id="loginPopup">

	    <div>
			<h2 id="ajaxLoginHeader">You need to be logged in to do that!</h2>
                <fieldset>
                    <input type="hidden" name="ReturnUrl" value="<%=this.GetReturnUrl()%>" />

                    <p>
                        <label id="<%=ListenTo.Web.Constants.ViewIdentifiers.LOGIN_POPUP_USERNAME_FIELD_LABEL_ID %>" for="Username">Username</label>
                        <%= Html.TextBox(ListenTo.Web.Constants.ViewIdentifiers.LOGIN_POPUP_USERNAME_FIELD_ID, null, new { @class = "text" })%> 
                    </p>
                    <p>
                        <label id="<%=ListenTo.Web.Constants.ViewIdentifiers.LOGIN_POPUP_PASSWORD_FIELD_LABEL_ID %>" for="Password">Password</label>
                        <%= Html.Password(ListenTo.Web.Constants.ViewIdentifiers.LOGIN_POPUP_PASSWORD_FIELD_ID, null, new { @class = "text" })%>
                    </p>

                    <div class="formButtons">
                        <a href="<%=Html.RegisterAccountUrl()%>">
                            <img src="/content/images/buttons/register-top.gif" alt="Register" />
                        </a>
                        <input id="ajaxLogin" type="image"  src="/content/images/buttons/login-top.gif" alt="Login" />
                    </div>
			  </fieldset>
	  	</div>

</div>


<script type="text/javascript">

    var LOGIN_POPUP_LOGON_BUTTON_CLASS = "<%=ListenTo.Web.Constants.ViewClasses.LOGIN_POPUP_LOGON_BUTTON_CLASS%>";
    var LOGIN_POPUP_USERNAME_FIELD_ID = "<%=ListenTo.Web.Constants.ViewIdentifiers.LOGIN_POPUP_USERNAME_FIELD_ID%>";
    var LOGIN_POPUP_USERNAME_FIELD_LABEL_ID = "<%=ListenTo.Web.Constants.ViewIdentifiers.LOGIN_POPUP_USERNAME_FIELD_LABEL_ID%>";
    var LOGIN_POPUP_PASSWORD_FIELD_ID = "<%=ListenTo.Web.Constants.ViewIdentifiers.LOGIN_POPUP_PASSWORD_FIELD_ID%>";
    var LOGIN_POPUP_PASSWORD_FIELD_LABEL_ID = "<%=ListenTo.Web.Constants.ViewIdentifiers.LOGIN_POPUP_PASSWORD_FIELD_LABEL_ID%>";

    function lock() {
        $("#loginPopup").attr("disabled", true);
    }

    function unlock() {
        $("#loginPopup").removeAttr("disabled"); 
    }

    function setHeader(text) {
        var headerDOM = $("#ajaxLoginHeader");
        headerDOM.html(text);
    }

    function getUsername() {
        var usernameDOM = $("#" + LOGIN_POPUP_USERNAME_FIELD_ID);
        return usernameDOM.val();
    }

    function getPassword() {
        var passwordDOM = $("#" + LOGIN_POPUP_PASSWORD_FIELD_ID);
        return passwordDOM.val();
    }

    function setUsernameLabel(value) {
        $("#" + LOGIN_POPUP_USERNAME_FIELD_LABEL_ID).html(value);
    }
    
    
    function setPasswordLabel(value) {
        $("#" + LOGIN_POPUP_PASSWORD_FIELD_LABEL_ID).html(value);
    }

    function getErrorHtml(value) {
        return "<span class=\"field-validation-error\">" + value + "</span>";
    }

    function highlightPasswordError(errorMessage) {
        setPasswordLabel(getErrorHtml(errorMessage));
        $("#" + LOGIN_POPUP_PASSWORD_FIELD_ID).parent().addClass("validateError");
    }

    function clearPasswordError() {
        setPasswordLabel("Password");
        $("#" + LOGIN_POPUP_PASSWORD_FIELD_ID).parent().removeClass("validateError");
    }

    function highlightUsernameError(errorMessage) {
        setUsernameLabel(getErrorHtml(errorMessage));
        $("#" + LOGIN_POPUP_USERNAME_FIELD_ID).parent().addClass("validateError");
    }

    function clearUsernameError() {
        setUsernameLabel("Username");
        $("#" + LOGIN_POPUP_USERNAME_FIELD_ID).parent().removeClass("validateError");
    }

    $(document).ready(function() {
        $("#ajaxLogin").click(function() {
            var valid = true;
            var username = getUsername();
            var password = getPassword();

            if (username == "") {
                highlightUsernameError("Whats your username?");
                valid = false;
            } else {
                clearUsernameError();
            }

            if (password == "") {
                highlightPasswordError("Whats your password?");
                valid = false;
            } else {
                clearPasswordError();
            }

            if (valid == false) {
                setHeader("Enter a username and password!");
                return false;
            }

            setHeader("Logging you in<blink>.....</blink>");
            lock();

            $.ajax({
                type: "POST",
                url: "/account/ajaxlogin",
                data: "username=" + getUsername() + "&password=" + getPassword(),
                success: function(result) {

                    if (result == "true") {
                        location.reload(true);
                    } else {
                        setHeader("Invalid username or password!");
                        highlightUsernameError("Invalid Username or Password");
                        highlightPasswordError("Invalid Username or Password");
                        unlock();
                        return false;
                    }
                }
            });

            return false;

        });

    });
        

    function showLoginPopup() {
        var t = "You need to be logged in to do that!";
        var thickBoxLink = "#TB_inline?height=215&amp;width=500&amp;inlineId=loginPopup";
        tb_show(t, thickBoxLink);
        setHeader(t);
        clearUsernameError();
        clearPasswordError();
        unlock();
        this.blur();
        return false;  
    }

</script>

<%} %>