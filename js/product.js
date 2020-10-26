$.holdReady(true);
$.getScript("/js/colorbox.js",function(){$.holdReady(false)})

Cufon.DOM.ready(function () {
Cufon.replace('#ccom h1', {
fontFamily : 'PF DinDisplay Pro Thin'
});
Cufon.replace('#product2 ul li a', {
fontFamily : 'PF DinDisplay Pro Medium',
hover : true
});
});

$(document).ready
(
function () {
if (!$.browser.msie) {

$("#ccom h1,#rmenu h1,#rmarkalar h1,#etiket h1").corner("5px keep");
$("#product2 ul li").corner("5px top keep");
} else {
DD_roundies.addRule("#ccom h1,#rmenu h1,#rmarkalar h1,#etiket h1", '5px');
DD_roundies.addRule('#product2 ul li', '5px 5px 0 0');
}

$('#product2ar img').live('click', function () {
$("#LinkButton2").click()
});

$("#LinkButton1").mouseover(function () {
if (!$.browser.msie)
$("#LinkButton1").corner("5px top keep");
else
DD_roundies.addRule("#LinkButton1", "5px 5px 0 0")
})
$("#LinkButton2").mouseover(function () {
if (!$.browser.msie)
$("#LinkButton2").corner("5px top keep");
else
DD_roundies.addRule("#LinkButton2", "5px 5px 0 0")
})
$("#LinkButton3").mouseover(function () {
if (!$.browser.msie)
$("#LinkButton3").corner("5px top keep");
else
DD_roundies.addRule("#LinkButton3", "5px 5px 0 0")
})

//MenuYukle();
Yuvarla();
})

function Yuvarla() {
UrunResmiYukle();
Cufon.replace('#Panel1 .h3', {
fontFamily : 'PF DinDisplay Pro Thin'
});
$(".group1").colorbox({
rel : 'group1',
iframe : true,
innerWidth : 640,
innerHeight : 480
});

if (!$.browser.msie) {
$(".product2aic,#product2ar,.product2aic2,.prores,.prores img").corner("5px keep");
$("#product2a").corner("5px bottom keep");
$("#product2a").corner("5px right keep");
} else {
DD_roundies.addRule(".product2aic,#product2ar,.product2aic2,.prores", '5px');
DD_roundies.addRule('#product2a', '0 5px 5px 5px');
}
}

function Anthem_PreCallBack() {
$("#aloading").show();
$("#aloading").html("<img src=\"/images/loading.gif\" alt=\"\"/>")
}
function Anthem_PostCallBack() {
Yuvarla();
$("#aloading").hide();
$("#aloading").html("")
}
function Anthem_Error(result) {
$("#aloading").show();
$("#aloading").html(result.error)
}
