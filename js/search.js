$.holdReady(true);
$.getScript("/js/JSLINQ.js",function(){$.holdReady(false)})

var trh = new Date();
var xsonuc;
var xdeger = [{ dil: '', id: '', text: '', sayfa: ''}];
var ttt;

$(document).ready
(
	function () {
		VeriCek();

		if (!$.browser.msie) {
			$("#bosarama,#arama h1,#arama h1,#arama_aramatext,#arama_aramabutton").corner("5px keep");
		} else {
			DD_roundies.addRule("#bosarama,#arama h1", '5px');
		}

		$("#arama_aramatext").width(($("#aramadiv").width() - $("#arama_aramabutton").width() - 30));

		$("#arama_aramabutton").click(
function () {
	if ($("#arama_aramatext").val() == "") {
		alert(VeriGetir(48));
		YakSondur($("#arama_aramatext"));
		return (false)
	}
	if ($("#arama_aramatext").val() != "") {
		if ($("#arama_aramatext").val().length < 3) {
			alert(VeriGetir(49));
			YakSondur($("#arama_aramatext"));
			return (false)
		}
	}
}
);

	})

function VeriCek() {
	$.ajax
(
{
	type: "GET",
	dataType: "xml",
	url: "/xml/js.aspx?_=" + trh.getTime(),
	error: function (request, status, error) { alert(status + "\r\n" + error) },
	statusCode: { 404: function (err) { alert(err.status + "\r\n" + err.statusText) } },
	success: function (s, d) { xsonuc = s; DegerleriBas() }
}
)
}

function DegerleriBas() {
	$(xsonuc).find('search').each
(
function () {
	xdeger.push({ dil: $(this).find('dil').text(), id: $(this).find('id').text(), text: $(this).find('text').text(), sayfa: $(this).find('sayfa').text() });
}
);
}

function VeriGetir(ID) {
	var cevap = JSLINQ(xdeger)
.Where(function (b) { return b.id.length > 0 && b.id == ID })
.Select(function (i) { return i.text; })
.FirstOrDefault('{}');

	if (cevap == "{}") {
		return "Language Error";
	}
	else {
		return cevap;
	}

}