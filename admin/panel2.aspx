<%@ Page Language="C#" AutoEventWireup="true" CodeFile="panel2.aspx.cs" Inherits="yonetim_panel"
	EnableViewState="False" ViewStateMode="Disabled" EnableEventValidation="False"
	ValidateRequest="false" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-9" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
	<meta http-equiv="Content-Language" content="TR" />
	<meta http-equiv="Charset" content="iso-8859-9" />
	<meta http-equiv="Imagetoolbar" content="no" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta name="Robots" content="noindex,nofollow" />
	<title>Yönetici Paneli</title>
	<style media="all" type="text/css">
		@import url("css/sitil.css");
	</style>
	<style type="text/css">
		.invite {
			background-color: #99bbe8 !important;
		}
		
		.x-drop-marker {
			background-color: silver;            
		}
	</style>
	<script type="text/javascript">
<!--
		function NoError() {
			//alert("Sayfada JS hatası oluştu.\nLütfen tarayıcıyı kapatıp açarak, yeniden deneyiniz");
			return (true);
		}
		onerror = NoError;
//-->
	</script>
	<ext:ResourcePlaceHolder ID="ResourcePlaceHolder1" runat="server" Mode="Script" />
</head>
<body>
	<script type="text/javascript">

		/*
		jQuery.noConflict();

		jQuery(function ($) {
		$("#HyperLink2_Container").cssRemove();
		}
		);

		$(function () {
		$("#HyperLink1_Container,#HyperLink2_Container,#HyperLink3_Container").attr("style", "")
		});

		Ext.select("BayrakResimDiv").setStyle('float', '');
		Ext.get("BayrakResimDiv").dom.style;
		*/

		var CikisYap = function () {
			Ext.Msg.confirm('Uyarı', 'Çıkış yapmak istediğinize emin misiniz?', function (btn) {
				if (btn == "yes") {
					Ext.net.DirectMethods.CikisYap();
				}
			});
		}

		var OnlineYoneticiler = function () {
			TabEkle(TabPanel1, 'MenuItem22', 'online-yoneticiler.aspx', 'MenuPanel7', 'Online Yöneticiler');
		}

		var OnlineKullanicilar = function () {
			TabEkle(TabPanel1, 'MenuItem21', 'online-kullanicilar.aspx', 'MenuPanel7', 'Online Kullanıcılar');
		}

		var GirisCikislar = function () {
			TabEkle(TabPanel1, 'MenuItem18', 'giris-cikis-kayitlari.aspx', 'MenuPanel3', 'Giriş - Çıkış Kayıtları');
		}

		var TabEkle = function (panelID, id, url, MenuPanelID, MenuTitle) {

			//var nurl = url;
			var trh = new Date();
			var cache = "?cache=ok";
			var tab = panelID.getComponent(id);
			var url2 = url;

			if (CheckBox1.getValue()) {
				url2 = url2 + cache + "&rnd=" + trh.getTime();
			}
			else {
				url2 = url2 + "?rnd=" + trh.getTime();
			}

			if (!tab) {
				tab = panelID.add({
					id: id,
					//title: MenuTitle + " | " + nurl,
					title: MenuTitle,
					closable: true,
					iconCls: "icon-table",
					autoLoad: {
						showMask: true,
						url: url2,
						mode: "iframe",
						maskMsg: "Yükleniyor..."
					}
				});

			}

			tab.on("activate", function () {
				var item = MenuPanelID.menu.items.get(id);

				if (item) {
					MenuPanelID.setSelection(item);
				}
			}, this);

			panelID.setActiveTab(tab);
		}
	</script>
	<form id="form1" runat="server">
	<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Gray" Locale="tr-TR"
		GZip="true" />
	<ext:Viewport ID="Viewport1" runat="server" Layout="BorderLayout" StyleSpec="background:none #F0F0F0">
		<Items>
			<ext:BorderLayout ID="BorderLayout1" runat="server">
				<North>
					<ext:Container ID="North" runat="server" Cls="dropable" Layout="Fit" Height="77">
						<Items>
							<ext:Panel ID="Panel1" runat="server" Header="false" Shadow="None" Border="false">
								<Content>
									<div id="top">
										<div id="ust">
											<div id="ustsol">
												<ext:LinkButton runat="server" ID="LinkButton1" Icon="User">
													<Listeners>
														<Click Handler="GirisCikislar()" />
													</Listeners>
												</ext:LinkButton>
											</div>
											<div id="ustsag">
												<div id="Div1" style="float: left">
													<ext:Checkbox ID="CheckBox1" runat="server">
														<ToolTips>
															<ext:ToolTip Title="Cache Aktif?">
															</ext:ToolTip>
														</ToolTips>
													</ext:Checkbox>
												</div>
												<ext:LinkButton runat="server" ID="LinkButton2" Icon="UserRed">
													<Listeners>
														<Click Handler="OnlineKullanicilar()" />
													</Listeners>
												</ext:LinkButton>
												<ext:LinkButton runat="server" ID="LinkButton3" Icon="User">
													<Listeners>
														<Click Handler="OnlineYoneticiler()" />
													</Listeners>
												</ext:LinkButton>
											</div>
										</div>
										<div id="sol">
											<div id="logo">
												<ext:ImageButton runat="server" ID="ImageButton1" />
											</div>
										</div>
										<div id="sag">
											<ext:Label ID="Label1" runat="server" Icon="User" />
											<ext:Button ID="Button2" runat="server" Icon="DoorOut" ToolTip="Çıkış yap" Text="Çıkış Yap">
												<Listeners>
													<Click Fn="CikisYap" />
												</Listeners>
											</ext:Button>
										</div>
									</div>
								</Content>
								<DraggableConfig ID="DraggableConfig1" runat="server" Group="panelDD">
									<StartDrag Handler="Ext.select('.dropable').addClass('x-drop-marker');" />
									<EndDrag Handler="Ext.select('.dropable').removeClass('x-drop-marker');" />
								</DraggableConfig>
							</ext:Panel>
						</Items>
					</ext:Container>
				</North>
				<East MarginsSummary="5 10 5 10">
					<ext:Container ID="EastRegion" runat="server" Cls="dropable" Layout="Fit" Width="200" />
				</East>
				<West MarginsSummary="5 10 5 10">
					<ext:Container ID="WestRegion" runat="server" Cls="dropable" Layout="Fit" Width="200">
						<Items>
							<ext:Panel ID="Panel2" runat="server" Title="İŞLEMLER" Icon="Plugin" Layout="AccordionLayout"
								Width="200" MinWidth="200" AnimCollapse="true"
								Shadow="None">
								<Items>
									<ext:MenuPanel ID="MenuPanel5" runat="server" Title="Ürün İşlemleri" Icon="Package"
										Border="false" Collapsed="true">
										<Menu ID="Menu6" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem10" runat="server" Text="Ürünler" Icon="PackageGreen">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem10','urunler.aspx',#{MenuPanel5},#{MenuItem10.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator23" runat="server" />
												<ext:MenuItem ID="MenuItem25" runat="server" Text="Ürün Resimleri [K]" Icon="Picture">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem25','urun-resimleri.aspx',#{MenuPanel5},#{MenuItem25.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator18" runat="server" />
												<ext:MenuItem ID="MenuItem12" runat="server" Text="Resimler/Videolar" Icon="PageWhitePicture">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem12','resimler-videolar.aspx',#{MenuPanel5},#{MenuItem12.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator24" runat="server" />
												<ext:MenuItem ID="MenuItem6" runat="server" Text="Ürün Kodları" Icon="PackageLink">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem6','urun-kodlari.aspx',#{MenuPanel5},#{MenuItem6.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator6" runat="server" />
												<ext:MenuItem ID="MenuItem33" runat="server" Text="* Arama Kayıtları" Icon="Style">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem33','#',#{MenuPanel5},#{MenuItem33.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator33" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel10" runat="server" Title="Resim/Video Grupları" Icon="FilmSave"
										Border="false" Collapsed="true">
										<Menu ID="Menu7" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem13" runat="server" Text="Resim Grupları" Icon="PhotoLink">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem13','resim-gruplari.aspx',#{MenuPanel10},#{MenuItem13.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator25" runat="server" />
												<ext:MenuItem ID="MenuItem20" runat="server" Text="Video Grupları" Icon="FilmLink">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem20','video-gruplari.aspx',#{MenuPanel10},#{MenuItem20.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator20" runat="server" />
												<ext:MenuItem ID="MenuItem24" runat="server" Text="Gruplara Atanan Resim/Video" Icon="LinkGo">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem24','gruplara-atanan-resim-video.aspx',#{MenuPanel10},#{MenuItem24.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator22" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel12" runat="server" Title="Kategori İşlemleri" Icon="PackageWhite"
										Border="false" Collapsed="true">
										<Menu ID="Menu9" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem34" runat="server" Text="Ürün Kategorileri" Icon="PackageLink">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem34','urun-kategorileri.aspx',#{MenuPanel12},#{MenuItem34.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator34" runat="server" />
												<ext:MenuItem ID="MenuItem35" runat="server" Text="Kategorilere Atanan Ürünler" Icon="PackageStart">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem35','kategorilere-atanan-urunler.aspx',#{MenuPanel12},#{MenuItem35.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator35" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel13" runat="server" Title="Marka İşlemleri" Icon="ShapeMoveBack"
										Border="false" Collapsed="true">
										<Menu ID="Menu10" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem36" runat="server" Text="Markalar" Icon="ShapeMoveBackwards">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem36','markalar.aspx',#{MenuPanel13},#{MenuItem36.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator36" runat="server" />
												<ext:MenuItem ID="MenuItem37" runat="server" Text="Markalara Atanan Ürünler" Icon="ShapeMoveFront">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem37','markalara-atanan-urunler.aspx',#{MenuPanel13},#{MenuItem37.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator37" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel1" runat="server" Title="Etiket İşlemleri" Icon="TagBlueAdd"
										Border="false" Collapsed="true">
										<Menu ID="Menu1" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem1" runat="server" Text="Etiketler" Icon="TagOrange">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem1','etiketler.aspx',#{MenuPanel1},#{MenuItem1.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator1" runat="server" />
												<ext:MenuItem ID="MenuItem2" runat="server" Text="Etiketlere Atanan Ürünler" Icon="TagBlueEdit">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem2','etiketlere-atanan-urunler.aspx',#{MenuPanel1},#{MenuItem2.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator2" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel9" runat="server" Title="* Gelen Mail İşlemleri" Icon="Mail"
										Border="false" Collapsed="true">
										<Menu ID="Menu3" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem26" runat="server" Text="İletişimden Gelen Mailler" Icon="EmailOpen">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem26','#',#{MenuPanel9},#{MenuItem26.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator26" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel14" runat="server" Title="* Maillist İşlemleri" Icon="EmailStar"
										Border="false" Collapsed="true">
										<Menu ID="Menu11" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem27" runat="server" Text="Liste İşlemleri" Icon="EmailEdit">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem27','#',#{MenuPanel14},#{MenuItem14.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator27" runat="server" />
												<ext:MenuItem ID="MenuItem28" runat="server" Text="Mail Tanımlama İşlemleri" Icon="EmailAdd">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem28','#',#{MenuPanel14},#{MenuItem28.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator28" runat="server" />
												<ext:MenuItem ID="MenuItem29" runat="server" Text="Mail Gönderim İşlemleri" Icon="EmailTransfer">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem29','#',#{MenuPanel14},#{MenuItem29.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator29" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel4" runat="server" Title="Bottom/Header İşlemleri" Icon="Pictures"
										Border="false" Collapsed="true">
										<Menu ID="Menu5" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem7" runat="server" Text="Bottom/Header" Icon="PictureSave">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem7','bottom-header.aspx',#{MenuPanel4},#{MenuItem7.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator7" runat="server" />
												<ext:MenuItem ID="MenuItem8" runat="server" Text="Bottom/Header Resimleri [K]" Icon="PicturesThumbs">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem8','bottom-header-resimleri.aspx',#{MenuPanel9},#{MenuItem8.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator8" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel2" runat="server" Title="Header (Slogan) İşlemleri" Icon="PageWorld"
										Border="false" Collapsed="true">
										<Menu ID="Menu4" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem4" runat="server" Text="Headerlar (Sloganlar)" Icon="PictureKey">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem4','headerlar-sloganlar.aspx',#{MenuPanel2},#{MenuItem4.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator4" runat="server" />
												<ext:MenuItem ID="MenuItem5" runat="server" Text="Header (Slogan) Resimleri [K]"
													Icon="Photo">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem5','header-slogan-resimleri.aspx',#{MenuPanel2},#{MenuItem5.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator5" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel15" runat="server" Title="* Kod (Script) İşlemleri" Icon="Html"
										Border="false" Collapsed="true">
										<Menu ID="Menu12" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem30" runat="server" Text="Kodlar (Scriptler)" Icon="ScriptCodeRed">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem30','#',#{MenuPanel15},#{MenuItem30.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator30" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel8" runat="server" Title="Menü İşlemleri" Icon="PageWhiteText"
										Border="false" Collapsed="true">
										<Menu ID="Menu111" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem23" runat="server" Text="Menüler" Icon="PageWhiteStar">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem23','menuler.aspx',#{MenuPanel8},#{MenuItem23.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator19" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel6" runat="server" Title="Dil İşlemleri" Icon="FlagTr"
										Border="false" Collapsed="true">
										<Menu ID="Menu2" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem16" runat="server" Text="Diller" Icon="FlagChecked">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem16','diller.aspx',#{MenuPanel6},#{MenuItem16.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator9" runat="server" />
												<ext:MenuItem ID="MenuItem11" runat="server" Text="Bayraklar [K]" Icon="FlagPurple">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem11','bayraklar.aspx',#{MenuPanel6},#{MenuItem11.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator21" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel3" runat="server" Title="Yönetici İşlemleri" Icon="UserMature"
										Border="false" Collapsed="true">
										<Menu ID="Menu31" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem3" runat="server" Text="Yöneticiler" Icon="Group">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem3','yoneticiler.aspx',#{MenuPanel3},#{MenuItem3.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator3" runat="server" />
												<ext:MenuItem ID="MenuItem17" runat="server" Text="Giriş Hataları" Icon="Error">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem17','giris-hatalari.aspx',#{MenuPanel3},#{MenuItem17.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator10" runat="server" />
												<ext:MenuItem ID="MenuItem18" runat="server" Text="Giriş - Çıkış Kayıtları" Icon="DatabaseTable">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem18','giris-cikis-kayitlari.aspx',#{MenuPanel3},#{MenuItem18.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator11" runat="server" />
												<ext:MenuItem ID="MenuItem19" runat="server" Text="İşlem Kayıtları" Icon="ServerChart">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem19','islem-kayitlari.aspx',#{MenuPanel3},#{MenuItem19.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator12" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel7" runat="server" Title="Online Kişiler" Icon="Connect"
										Border="false" Collapsed="true">
										<Menu ID="Menu24" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem21" runat="server" Text="Online Kullanıcılar" Icon="UserRed">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem21','online-kullanicilar.aspx',#{MenuPanel7},#{MenuItem21.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator13" runat="server" />
												<ext:MenuItem ID="MenuItem22" runat="server" Text="Online Yöneticiler" Icon="GroupLink">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem22','online-yoneticiler.aspx',#{MenuPanel7},#{MenuItem22.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator15" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
									<ext:MenuPanel ID="MenuPanel11" runat="server" Title="Site İşlemleri" Icon="Wrench"
										Border="false" Collapsed="true">
										<Menu ID="Menu8" runat="server">
											<Items>
												<ext:MenuItem ID="MenuItem15" runat="server" Text="Site Ziyaretleri" Icon="TableSort">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem15','site-ziyaretleri.aspx',#{MenuPanel11},#{MenuItem15.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator17" runat="server" />
												<ext:MenuItem ID="MenuItem9" runat="server" Text="Firma Bilgileri" Icon="VcardEdit">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem9','firma-bilgileri.aspx',#{MenuPanel11},#{MenuItem9.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator14" runat="server" />
												<ext:MenuItem ID="MenuItem14" runat="server" Text="Mail Ayarları" Icon="EmailEdit">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem14','mail-ayarlari.aspx',#{MenuPanel11},#{MenuItem14.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator16" runat="server" />
												<ext:MenuItem ID="MenuItem31" runat="server" Text="Site Sabitleri" Icon="CalendarViewWeek">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem31','site-sabitleri.aspx',#{MenuPanel11},#{MenuItem31.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator31" runat="server" />
												<ext:MenuItem ID="MenuItem32" runat="server" Text="Sabitlere Atananlar" Icon="CalendarLink">
													<Listeners>
														<Click Handler="TabEkle(#{TabPanel1},'MenuItem32','sabitlere-atananlar.aspx',#{MenuPanel11},#{MenuItem32.Text})" />
													</Listeners>
												</ext:MenuItem>
												<ext:MenuSeparator ID="MenuSeparator32" runat="server" />
											</Items>
										</Menu>
									</ext:MenuPanel>
								</Items>
								<%--
			<BottomBar>
			<ext:StatusBar runat="server" ID="StatusBar2" Icon="Bomb">
			<Items>
			<ext:Label runat="server" Text="deneme text" ID="Label2"></ext:Label>
			</Items>
			</ext:StatusBar>
			</BottomBar>
								--%>
								<DraggableConfig ID="DraggableConfig2" runat="server" Group="panelDD">
									<StartDrag Handler="Ext.select('.dropable').addClass('x-drop-marker');" />
									<EndDrag Handler="Ext.select('.dropable').removeClass('x-drop-marker');" />
								</DraggableConfig>
							</ext:Panel>
						</Items>
					</ext:Container>
				</West>
				<South CollapseMode="Mini" Collapsible="true">
					<ext:Container ID="SouthtRegion" runat="server" Cls="dropable" Layout="Fit" Height="77" />
				</South>
				<Center MarginsSummary="5 0 5 0">
					<ext:Container ID="CenterRegion" runat="server" Cls="dropable" Layout="Fit">
						<Items>
							<ext:TabPanel ID="TabPanel1" runat="server" Closable="false" Header="false" Collapsible="false"
								Shadow="None">
								<LoadMask ShowMask="true" Msg="Yükleniyor..." />
								<BottomBar>
									<ext:StatusBar runat="server" ID="StatusBar1" Icon="Time" Split="true">
										<Items>
											<ext:Label runat="server" Icon="RosetteBlue" Text="Root Yönetici" ID="BottomLabel">
											</ext:Label>
										</Items>
									</ext:StatusBar>
								</BottomBar>
								<DraggableConfig ID="DraggableConfig3" runat="server" Group="panelDD">
									<StartDrag Handler="Ext.select('.dropable').addClass('x-drop-marker');" />
									<EndDrag Handler="Ext.select('.dropable').removeClass('x-drop-marker');" />
								</DraggableConfig>
							</ext:TabPanel>
						</Items>
					</ext:Container>
				</Center>
			</ext:BorderLayout>
		</Items>
	</ext:Viewport>
	<ext:DropTarget ID="DropTarget1" runat="server" Target="${.dropable}" Group="panelDD"
		OverClass="invite">
		<NotifyDrop Handler="var cmp = Ext.getCmp(this.el.dom.id);cmp.add(data.panel);cmp.doLayout.defer(10,cmp);" />
		<NotifyOver Handler="Ext.select('.dropable').removeClass('invite'); this.el.addClass('invite');" />
	</ext:DropTarget>
	<ext:TaskManager ID="TaskManager1" runat="server">
		<Tasks>
			<ext:Task TaskID="Task1" Interval="60000">
				<DirectEvents>
					<Update OnEvent="OnlineDurumlari">
					</Update>
				</DirectEvents>
			</ext:Task>
		</Tasks>
	</ext:TaskManager>
	</form>
</body>
</html>
