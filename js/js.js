function ScreenResize() {
    if ($(window).width() > 1023) {
	if($.cookies.get('VITRIN') != "logo")
	{
$("#rribbon").hide("fast");	
	        $("#rribbon").show(1000);
	}
    }
    else {
        $("#topm").css({ 'background': 'url(../images/top2.png) no-repeat', 'width': '960px' });
        $("#logo img").css({ 'margin-left': '70px' });
        $("#menu ul").css({ 'margin-right': '35px' });
        $("#header").css({ 'background': '#096e18 url(../images/header.jpg) left no-repeat' });
        $("#cma").css({ 'background': 'url(../images/top_bg2.png) top no-repeat', 'width': '960px' })
    }
}

function YakSondur(a) { a.seekAttention({ paddingTop: 5, paddingBottom: 5, paddingLeft: 5, paddingRight: 5 }); a.focus() }
MailKontrol = function () { for (var a = arguments[0], c = "1234567890abcdefghijklmnoprstuvyzqwx[].+@-_ABCDEFGHIJKLMNOPRSTUVYZQWX", d = /(@.*@)|(\.\.)|(^\.)|(^@)|(@$)|(\.$)|(@\.)/, e = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,8}|[0-9]{1,3})(\]?)$/, b = 0; b < a.length; b++) if (c.indexOf(a.charAt(b)) < 0) return false; if (!a.match(d) && a.match(e)) return -1 }
function KucukHarf(a) { !a.val() == "" && a.val(a.val().toLowerCase()) }
function BuyukHarf(a) { !a.val() == "" && a.val(a.val().toUpperCase()) }
function SayisalKarakter(a) { if (!a.val() == "") if (!a.val().match(/^[\-0-9\s]+$/g)) { a.val(a.val().replace(/[^\-0-9\s]*/g, ""));} }