/* --------------------
* JS used on listento homepage
* - uses jquery
* - tom adams 020708
-------------------- */

$(function() {

	/* --------------------
	* Bands Section
	-------------------- */
	fnBandsSlideshow = function(){
		//options
		slideShowPause=6000;//milliseconds
		container="#highlightBand .container";//element where highlighted band html should go

		//create div structures, set up initial states
		$("#bandsList").before('<div id="highlightBand"><div class="container"></div><div class="overlay"></div></div>').find("ul").addClass("clear");
		$("#bandsList li").each(function(){
			$this = $(this);
			$this.find("img").wrap('<a href="'+$this.find("a").attr("href")+'"></a>');
		});
		$(container).html($("#bandsList li:first").html());
		$("#bandsList li:first").addClass("on");

		fnBandStartSlideShow();
		
		//change featured band on click
		$("#bandsList li").click( function(){
			$("#bandsList .on").removeClass("on");
			$(this).addClass("on");
			fnBandChangeFeatured();
			clearInterval(runSlideshow);
			fnBandStartSlideShow();
			return false;
		});
		
		//featured band hover, and make whole area clickable
		$("#highlightBand").hover(
			function(){
				$(this).addClass("on");
				
				//pause animation
				fnBandStopSlideShow();
			},
			function(){
				$(this).removeClass("on");
				
				//restart animation
				fnBandStartSlideShow();
			}
		).click(function(){
			window.location.href = $(this).find("a").attr("href");
			return false;
		});
	}
	fnBandStartSlideShow = function(){
		runSlideshow = setInterval( "fnBandSlideSwitch()", slideShowPause );
	}
	fnBandStopSlideShow = function(){
		clearInterval(runSlideshow);
	};
	fnBandSlideSwitch = function(){
		$("#bandsList .on").removeClass("on").next().addClass("on");
		//check if that was the last item
		if ($("#bandsList .on").length==0){
			clearInterval(runSlideshow);
			//show the first slide, add on state
			$("#bandsList li:first").addClass("on");
			fnBandStartSlideShow();
		};
		fnBandChangeFeatured();
	};
	fnBandChangeFeatured = function(){
		//populate featured band
		$(container).empty().html($("#bandsList li.on").html());
	};
	//run the function
	fnBandsSlideshow();


	/* --------------------
	* Gigs Section
	-------------------- */
	gigNames=$("#gigs .itemsList>li h3 a")
	$("#gigs .itemsList>li ul").each(function(){
		//if more than 4 acts, hide all but the first 3, and add a expand link  
		numArtists = $("li", this).length;
		numIndex = $("#gigs .itemsList>li ul").index(this);
		if(numArtists>4){
			$("li:gt(1)", this).hide();
			$(this).append("<li><a class=\"extraArtists\" href=\"#\">" + (numArtists-2) + " more<span class=\"hidden\"> acts playing " + gigNames[numIndex].innerHTML + "</span>...</a></li>")
			
		}
		//when more link is clicked, hide it and show the hidden acts
		$(".extraArtists").click(function(){
			$(this).parent().hide();
			$(this).parent().siblings().show();
			return false;
		});
	});
	
});