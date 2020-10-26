Cufon.DOM.ready(function () {
	Cufon.replace('#ccom h1');
});

$(document).ready
(
	function () {
	if (!$.browser.msie) {
		$("#ccom h1,#ccom p,#ures h1,#about").corner("5px keep")
	} else {
		DD_roundies.addRule('#ccom h1,#ccom p,#ures h1,#about', '5px')
	}
})

$(function () {
var img = new Image();
$(img).load(function () {
//$(this).css("display", "none"); // .hide() doesn"t work in Safari when the element isn"t on the DOM already
$(this).hide();
$("#aboutdiv").removeClass("loading").append(this);
$(this).fadeIn("slow");
}).error(function () {
$("#aboutdiv").removeClass("loading").append(this);
$("#aboutdiv").html("<p>Image could not be loaded!<\/p>");
}).attr("src","images/engineering.gif").attr("alt","SERASMAC");
});