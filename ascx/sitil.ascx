<%@ Control Language="C#" AutoEventWireup="true" CodeFile="sitil.ascx.cs" Inherits="sitil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<asp:Literal ID="ContentType" runat="server"></asp:Literal>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
	<asp:Literal ID="ContentLanguage" runat="server" />
	<asp:Literal ID="Charset" runat="server" />
	<meta http-equiv="Imagetoolbar" content="no" />
	<asp:Literal ID="description" runat="server" />
	<asp:Literal ID="keywords" runat="server" />
	<asp:Literal ID="GoogleDogrulamaKodu" runat="server" Visible="false" />
	<meta name="Revisit-After" content="1 Weeks" />
	<meta name="Robots" content="ALL" />
	<title>
		<%=Class.Fonksiyonlar.Firma.Title()%>
	</title>

		<!--[if IE 6]>
<script type="text/javascript" language="javascript" src="/js/DD_belatedPNG.js"></script>
<script type="text/javascript" language="javascript" >
DD_belatedPNG.fix('#rribbon img,#htop ul li img,#hri,#cma,.pro .h3,.icon,#lribbon img,#logo a img,#cleft,#mbleft img,.product,#lribbon_image,#mright p img,#socialmedia ul li a img');
</script>
<![endif]-->

	<!--[if lt IE 6]>
<script type="text/javascript">window.location="tarayici.aspx"</script>
<![endif]-->
	<style media="all" type="text/css" title="<%=Class.Fonksiyonlar.Genel.OzelAyar("URL")%>">
		@import url("/css/sitil.css");
		<asp:Literal ID="colorbox" runat="server" Visible="false">
		@import url("/css/colorbox.css");
		</asp:Literal>
	</style>
	<!--SCRIPTS-->
	<script type="text/javascript" src="/js/jquery.js"></script>
	<script type="text/javascript" src="/js/jquery-ui.js"></script>
	<script type="text/javascript" src="/js/cookies.js"></script>
	<script type="text/javascript" src="/js/cufon.js"></script>
	<script type="text/javascript" src="/js/PF_DinDisplay_Pro_Medium.js"></script>
	<script type="text/javascript" src="/js/PF_DinDisplay_Pro_Thin.js"></script>
	<script type="text/javascript" src="/js/seekattention.js"></script>
	<script type="text/javascript" src="/js/js.js"></script>
	<asp:Literal ID="GoogleAnalytics" runat="server" Visible="false"/>
	<script type="text/javascript">
<!--
		function NoError() {
			//alert("Sayfada JS hatasý oluþtu.\nLütfen tarayýcýyý kapatýp açarak, yeniden deneyiniz");
			return (true);
		}
		onerror = NoError;
//-->
	</script>
	<!--SCRIPTS-->
	<!--[if IE 6]>
<style type="text/css">
html{overflow-x:hidden}
</style>
<script type="text/javascript">
var IE6UPDATE_OPTIONS =
{
icons_path: "http://static.ie6update.com/hosted/ie6update/images/",
message: "Internet Explorer versiyonunuz çok düþük. Güncellemek için týklayýnýz.",url: "http://www.microsoft.com/turkiye/windows/internet-explorer"
}
</script>
<script type="text/javascript" src="http://static.ie6update.com/hosted/ie6update/ie6update.js"></script>
<![endif]-->
</head>
<body>
	<!--NOSCRIPT-->
	<noscript>
		<div id="noscript">
			<p>
				<img class="alignmid" src="/images/icon/info.png" alt="" />
				<u>Tarayýcýnýzýn JavaScript desteði bulunmamaktadýr.</u>
			</p>
			<p style="margin-top: 5px">
				Tarayýcýnýzýn bu desteðinin olmayýþý web sitemizi etkili bir þekilde kullanamamanýzý
				saðlayacaktýr.</p>
			<p>
				Lütfen tarayýcýnýzla ilgili gerekli ayarlarý yaparak sayfayý yenileyiniz.</p>
		</div>
	</noscript>
	<!--NOSCRIPT-->
