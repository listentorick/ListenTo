/* --------------------
JS used globally across listento
- uses jquery
- tom adams
-------------------- */


$(function() {
/* --------------------
*  Mark as js-enabled
-------------------- */
	$("body").addClass("js");


/* --------------------
*  Clear text fields
-------------------- */
$("input.autoclear").each( function(){
	var $this = $(this);
	origValue = $this.attr("value");
	$this.focus( function(){
		if($this.attr("value")==origValue){
			$this.attr("value", "");
		};
	}).blur( function(){
		if($this.attr("value")==""){
			$this.attr("value", origValue);
		};
	});

});

/* --------------------
* Popup Links:
* Make any link with class="popup" open a javascript popup
* Use options in the query string eg ?w=800&amp;h=375&amp;sbar=yes
* width = w
* height = h
* scrollbars = sbar
* resizable = resize
* menubar = menu
* location = loc
* status = status
-------------------- */
	$(".popup").click(function () {
		var wHref = $(this).attr("href")

		//set defaults
		var arrOptions = { height:"400", width:"500", scrollbars:"yes", resizable:"1", menubar:"0", location:"0", status:"0" };

		//get query string
		if (wHref.indexOf("?") != -1){
			var arrQs = wHref.split("?")[1].split("&");
			jQuery.each(arrQs, function() {
				var curItem = this.split("=");
				if (curItem[0]=="w"){ arrOptions.width=curItem[1]; }
				else if (curItem[0]=="h"){ arrOptions.height=curItem[1]; }
				else if (curItem[0]=="sbar"){ arrOptions.scrollbars=curItem[1]; }
				else if (curItem[0]=="resize"){ arrOptions.resizable=curItem[1]; }
				else if (curItem[0]=="menu"){ arrOptions.menubar=curItem[1]; }
				else if (curItem[0]=="loc"){ arrOptions.location=curItem[1]; }
				else if (curItem[0]=="status"){ arrOptions.status=curItem[1]; }
			});
		}

		//create string of options
		var wOptions="";
		jQuery.each(arrOptions, function(i, val) {
			wOptions += i + "=" + val + ",";
	    });
		wOptions = wOptions.substring(0,wOptions.length-1); //remove the trailing comma

		//create window name
		var wName;
		if ($(this).attr("id")){
			wName = $(this).attr("id"); 
		} else { 
			wName = "popup_" & ($(".popup").index(this));
		}

		//open the popup
		window.open(wHref, wName, wOptions);
		return false;
	});


/* --------------------
*  Increase number of input fields 
*  (used on upload photos page)
-------------------- */
	/*Add the 'add more' link after the list of fields*/
	$(".addFormFields ul").after("<p class=\"addMore\"><a href=\"#\">Add more photos +</a></p>");
	
	/*Click link to add more form fields to list */
	$(".addFormFields .addMore a").click(function(){
		var objInputsList = $(this).parent().parent().find("ul");
		var numItems = objInputsList.find("li").length +1;
		objInputsList.append("<li><label class=\"hidden\" for=\"fileUpload" + numItems + "\">Upload " + numItems + ":</label><input name=\"fileUpload" + numItems + "\" id=\"fileUpload" + numItems + "\" type=\"file\" /></li>");
		return false;
	});

/* --------------------
*  smarten up the listing and block landing pages
-------------------- */
	$(".listing .itemsList>li:even").css({marginRight:"20px"});
	$(".listing .itemsList>li:odd").css({marginRight:"0px"});
	$(".landingBlocks .itemsList>li:even").css({marginRight:"20px"});
	$(".landingBlocks .itemsList>li:odd").css({marginRight:"0px"});

/* --------------------
*  set firstItem and secondItem on listings
-------------------- */
	$(".itemsList li:first-child").addClass("firstItem").next().addClass("secondItem");

/* --------------------
*  limit length of lists of users
-------------------- */
	$(".userList").each(function(){
		//if more than 6 users, hide all but the first 6, and add a expand link
		numUsers = $("li", this).length;
		userType = $(this).parent().find("h2").text();
		if(numUsers>6){
			$("li:gt(5)", this).hide();
			$(this).after("<p class=\"moreLink\"><a class=\"extraUsers\" href=\"#\">Show all<span class=\"hidden\"> "+ userType + "</span></a></li>")
		}
		//when more link is clicked, hide it and show the hidden acts
		$(".extraUsers").click(function(){
			$(this).parent().hide();
			$(this).parent().prev().find("li").show();
			return false;
		});
	});


/* --------------------
* Drop down menus
-------------------- */
	hideOpen="";
	$("ul.ddMenu>li").hover(
		function () {
			//clear other items
			clearTimeout(hideOpen);
			$("ul.ddMenu li.hover").removeClass("hover").find("div").css("left","-999em");
			
			//show item
			$(this).addClass("hover").find("div").hide().css("left","auto").fadeIn("fast");
		}, 
		function () {
			me = $(this);
			hideOpen=setTimeout('me.removeClass("hover").find("div").css("left","-999em")', 400)
			
		}
	);


/* --------------------
* Apply error class to parent elements
--------------------- */
$(".input-validation-error").parent().addClass("validateError");


/* --------------------
* Hack to avoid unsightly rollovers when images are links
--------------------- */
$("a img").parent().addClass("img");


/* --------------------
* Auto Expanding Text Area
* by Chrys Bader (www.chrysbader.com)
*  modified by jake@hybridstudio.com
*
* Version 1.0
* 01/10/2008
-------------------- */
	$.expandingTA = function(elems) {
		// turn each element into an expanding text area
		elems.each( function()  
		{       
			var _interval = null;
			var _dummy = null;
			var _self = this;
			var _prevHeight = 0;
			var _min_height;
	
			// magically expand the textarea
			$(_self).bind('focus', __checkExpand)
				.bind('blur', __stopExpand)
				.css('overflow', 'hidden');
	
			function __checkExpand()
			{
				_min_height = $(_self).height();
	
				_interval = setInterval(function() { 
					__expandUpdate(); 
				}, 150);
			}
	
			function __stopExpand()
			{
				clearInterval(_interval);   
			}
	
			function __expandUpdate()
			{
				var line_height = 16;   // 16px assumed
	
				if ( _dummy == null ) { // create dummy
	
					_dummy = $('<div></div>')
					_dummy.css( {
									'font-size':    $(_self).css('font-size'),
									'font-family':  $(_self).css('font-family'),
									'width':        $(_self).css('width'),
									'padding':      $(_self).css('padding'),
									'xline-height':  line_height,
									'overflow-x':   'hidden',
									'display':      'none'
								}).appendTo('body');
				}
	
				// update html in dummy div
				var newHtml = $(_self).val().replace(/\n/g, '<br>new');
	
				if( _dummy.html() != newHtml ) {
	
					_dummy.html( newHtml );
					var newHeight = Math.max(_min_height, _dummy.height() + line_height);
	
					if (_prevHeight != newHeight) {
	
						//$(_self).height(newHeight);
						$(_self).animate({height:(newHeight)}, 100);    // animate?
	
						_prevHeight = newHeight;
					}
				}
			}
		});
	}
	$.expandingTA($('textarea.expanding')); // initial call to all elems of textarea.expanding                  


});













