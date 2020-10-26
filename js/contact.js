$.holdReady(true);
$.getScript("/js/JSLINQ.js",function(){$.holdReady(false)})

var trh=new Date();
var xsonuc;
var xdeger = [{dil:'',id:'',text:'',sayfa:''}];

Cufon.DOM.ready(function () {
    Cufon.replace('#ccom h1');
    Cufon.replace('#adresmenu li h4', {
        fontFamily: 'PF DinDisplay Pro Medium',
        hover: true
    });
});

$(document).ready
(
	function () {
	if (!$.browser.msie) {
	    $("#cleft input,#cleft textarea,#gonder,#ccom h1,#ccom p,#rgoogle h1,#recapt,#adresmenu li h4,#adresmenu li p").corner("5px keep")
	} else {
	    DD_roundies.addRule('#gonder,#ccom h1,#ccom p,#rgoogle h1,#adresmenu li h4,#adresmenu li p', '5px')
	}
	
	VeriCek();
	
	$('#textname').bind('keyup', function () {
		BuyukHarf($(this))
	});
	$('#textmail').bind('keyup', function () {
		KucukHarf($(this))
	});
	$('#texttel').bind('keyup', function () {
		SayisalKarakter($(this))
	});
	
	if ($.browser.msie) {
	$("#recaptcha_area table tr td").css({ "padding":"0"});
	}
	
$("#recapt").width($("#textcom").width()+15);
$("#recaptcha_response_field").css({ "border": "1px solid #DFDFDF", "width": $("#recaptcha_image img").width()-15});
	if ($.browser.msie) {
$("#recaptcha_response_field").css({"margin-left":"7px"});
}

$("#gonder").click
(
function () {
    if ($("#textname").val() == "") {
        alert(VeriGetir(29)); YakSondur($("#textname"))
        return (false);
    }
    if ($("#textmail").val() == "") {
        alert(VeriGetir(30)); YakSondur($("#textmail"))
        return (false);
    }
    if (!MailKontrol($("#textmail").val())) {
        alert(VeriGetir(31)); YakSondur($("#textmail"))
        return (false);
    }
    if ($("#texttel").val() == "") {
        alert(VeriGetir(32)); YakSondur($("#texttel"))
        return (false);
    }
    if ($("#textcom").val() == "") {
        alert(VeriGetir(33)); YakSondur($("#textcom"))
        return (false);
    }
    if ($("#recaptcha_response_field").val() == "") {
        alert(VeriGetir(34));
        YakSondur($("#recaptcha_response_field"));
        return (false)
    }
    if ($("#recaptcha_response_field").val() != "") {
        if ($("#recaptcha_response_field").val().length < 5) {
            alert(VeriGetir(35));
            YakSondur($("#recaptcha_response_field"));
            return (false)
        }
    }
}
)

})

function VeriCek()
{
$.ajax
(
{
type: "GET",
dataType: "xml",
url: "/xml/js.aspx?_=" + trh.getTime(),
error: function (request, status, error){alert(status + "\r\n" + error)},
statusCode: {404: function(err) {alert(err.status + "\r\n" + err.statusText)}},
success: function (s,d){xsonuc=s;DegerleriBas()}
}
)
}

function DegerleriBas()
{
$(xsonuc).find('contact').each
(
function()
{
xdeger.push({dil:$(this).find('dil').text(),id:$(this).find('id').text(),text:$(this).find('text').text(),sayfa:$(this).find('sayfa').text()});
}
);
}

function VeriGetir(ID)
{
var cevap = JSLINQ(xdeger)
.Where(function (b) { return b.id.length > 0 && b.id == ID})
.Select(function (i){ return i.text; })
.FirstOrDefault('{}');

if(cevap=="{}")
{
return "Language Error";
}
else
{
return cevap;
}

}