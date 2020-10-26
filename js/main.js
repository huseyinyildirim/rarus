$(window).resize(function(){ScreenResize()})

$.holdReady(true);
$.getScript(!$.browser.msie?"/js/corner.js":"/js/DD_roundies.js",function(){$.holdReady(false)})

Cufon.DOM.ready(function () {
	Cufon.replace('#hleft h1,.ptext h2,#cright h1,#basr h1,#mright p strong,#mright h4', {
		fontFamily : 'PF DinDisplay Pro Medium'
	});
	Cufon.replace('#menu ul li a,#htop ul li a,#basl h1,#basl ul li a,#altmenu ul li a', {
		fontFamily : 'PF DinDisplay Pro Medium',
		hover : true
	});

Cufon.replace('.pro h3,#logo a span,#header_textp,#basl ul li span,#mright p', {
		fontFamily : 'PF DinDisplay Pro Thin'
	});
});

$(document).ready
(
	function () {

		if (!$.browser.msie) {
			$("#menu ul li a").corner("15px keep");
			$(".mmenu li a").corner("5px keep");
		} else {
			DD_roundies.addRule('#menu ul li a', '25px');
		}

		ScreenResize();

		if ($.cookies.get('VITRIN') != "logo") {
			$("#lribbon").hide("fast");
			$("#lribbon").show('slide', { direction: 'left' }, 3000);
			$.cookies.set('VITRIN', 'logo', { hoursToLive: 24 });
		}

     
		if ($("#cleft").height() < $("#cright").height()) {
			$("#cleft").css({
				'height': $('#cmain').height()
			})
		}

	})
