Cufon.DOM.ready(function () {
Cufon.replace('#sorting table tbody tr td a', {
fontFamily : 'PF DinDisplay Pro Thin',
hover : true
});
});

$(document).ready
(
function () {
if (!$.browser.msie) {
$("#sorting,.prdct,#rmenu h1,#rmarkalar h1,#ures h1,#uvid h1,#etiket h1,#rmail h1,.phref a,#sayfalama").corner("5px keep");
} else {
DD_roundies.addRule('#sorting,.prdct,#rmenu h1,#rmarkalar h1,#ures h1,#uvid h1,#etiket h1,#rmail h1,.phref a,#sayfalama', '5px');
}

$("span#sayfalamasp").css({
'margin-left' : ($("#sayfalama").width() - $("span#sayfalamasp").width()) / 2
})
})
