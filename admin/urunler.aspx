<%@ Page Language="C#" AutoEventWireup="true" CodeFile="urunler.aspx.cs" Inherits="yonetim_Kullanici"
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
		var OnayTemplate = '<span style="color:{0};font-weight:{1}">{2}</span>';

		var OnayRenk = function (v) {
			return String.format(OnayTemplate, (v == "HAYIR") ? "red" : "black", (v == "HAYIR") ? "bold" : "normal", v);
		};

		var AnasayfaTemplate = '<span style="color:{0};font-weight:{1}">{2}</span>';

		var AnasayfaRenk = function (v) {
			return String.format(AnasayfaTemplate, (v == "HAYIR") ? "red" : "black", (v == "HAYIR") ? "bold" : "normal", v);
		};

		Ext.data.Connection.override({
			timeout: 300000
		});

		Ext.Ajax.timeout = 300000;

		var ExportYap = function () {
			Ext.net.Mask.show();
			Ext.net.Mask.hide.defer(500);
		};

		var DosyaGonder = function () {
			if (!gonderilecek_dosya.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir dosya seçiniz.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

		var UrunResimYol = function (data) {
			if (data != null) {
				return String.format("<a href=\"" + data.replace(data, "../images/product/" + data) + "\" target=\"_blank\">" + data + "</a>");
			}
		};

		var DilDegistir = function () {
			Ext.net.DirectMethods.DilDegistir();
		}

		var DugmelerinDurumu = function (grid, toolbar, rowIndex, record) {
			switch (record.data.onay) {
				case "EVET":
					toolbar.items.get(2).setDisabled(true);
					toolbar.items.get(2).setTooltip("İlgili kaydın durumu nedeniyle bu buton devre dışı bırakılmıştır.");
					break;

				case "HAYIR":
					toolbar.items.get(4).setDisabled(true);
					toolbar.items.get(4).setTooltip("İlgili kaydın durumu nedeniyle bu buton devre dışı bırakılmıştır.");
					break;
			}
		};

		var WindowEkleClear = function () {
			for (var i = 0; i <= WindowEkle.items.items.length; i++) {
				if (WindowEkle.items.items[i].xtype == "textfield" || WindowEkle.items.items[i].xtype == "textarea") {
					WindowEkle.items.items[i].clear();
				}
				else if (WindowEkle.items.items[i].xtype == "combo") {
					if (WindowEkle.items.items[i].id == "Ekle_ComboBoxOnay" || WindowEkle.items.items[i].id == "Ekle_ComboBoxAnasayfa") {
						WindowEkle.items.items[i].selectByIndex(0);
					}
					else {
						WindowEkle.items.items[i].clear();
					}
				}
				else if (WindowEkle.items.items[i].xtype == "netdropdown") {
					Ekle_KategorilerNodeTemizle();
					WindowEkle.items.items[i].clear();
				}
			}
		}

		var WindowDuzenleClear = function () {
			for (var i = 0; i <= WindowDuzenle.items.items.length; i++) {
				if (WindowDuzenle.items.items[i].xtype == "textfield" || WindowDuzenle.items.items[i].xtype == "textarea") {
					WindowDuzenle.items.items[i].clear();
				}
				else if (WindowDuzenle.items.items[i].xtype == "combo") {
					if (WindowDuzenle.items.items[i].id == "Duzenle_ComboBoxOnay" || WindowDuzenle.items.items[i].id == "Duzenle_ComboBoxAnasayfa") {
						WindowDuzenle.items.items[i].selectByIndex(0);
					}
					else {
						WindowDuzenle.items.items[i].clear();
					}
				}
				else if (WindowDuzenle.items.items[i].xtype == "netdropdown") {
					Duzenle_KategorilerNodeTemizle();
					WindowDuzenle.items.items[i].clear();
				}
			}
		}

		var DuzenleKontrol = function () {
			if (!Duzenle_TextFieldAd.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen zorunlu tüm alanları doldurun.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
			else if (Duzenle_DropDownFieldKategoriler.getValue() == "Kategori Seçiniz..." || Duzenle_DropDownFieldKategoriler.getValue() == "[]" || Duzenle_DropDownFieldKategoriler.getValue() == "") {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir kategori seçin.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
			else if (!Duzenle_TextAreaOnAciklama.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen zorunlu tüm alanları doldurun.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

		var KaydetKontrol = function () {
			if (!Ekle_TextFieldAd.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen zorunlu tüm alanları doldurun.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
			else if (Ekle_DropDownFieldKategoriler.getValue() == "Kategori Seçiniz..." || Ekle_DropDownFieldKategoriler.getValue() == "[]" || Ekle_DropDownFieldKategoriler.getValue() == "") {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir kategori seçin.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
			else if (!Ekle_TextAreaOnAciklama.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen zorunlu tüm alanları doldurun.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

		var GridKomutlari = function (cmd, record) {
			switch (cmd) {

				case "Goster":

					var winResim = new Ext.Window({
						id: 'WindowR' + record.data.id,
						iconCls: "icon-picture",
						title: 'Dosya Gösterim Penceresi - ' + record.data.id,
						closable: false,
						width: 640,
						height: 480,
						resizable: true,
						renderTo: Ext.getBody(),
						maximizable: true,
						minimizable: false,
						modal: false,
						layout: 'fit',
						autoLoad: {
							maskMsg: "Dosya gösterim için yükleniyor...",
							showMask: true,
							mode: "iframe",
							url: '../images/product/' + record.data.resim,
							scripts: true
						},
						buttonAlign: 'right',
						buttons: [
			{
				iconCls: "icon-cancel",
				text: 'KAPAT',
				handler: function () {
					winResim.close();
				}
			}
		]
					});

					winResim.show();
					break;

				case "IslemKaydi":

					var win = new Ext.Window({
						id: 'WindowY' + record.data.id,
						iconCls: "icon-usercomment",
						title: 'İşlem Kayıtlarını Gösterim Penceresi - ' + record.data.id,
						closable: false,
						width: 640,
						height: 480,
						resizable: true,
						renderTo: Ext.getBody(),
						maximizable: true,
						minimizable: false,
						modal: false,
						layout: 'fit',
						autoLoad: {
							maskMsg: "İşlem kayıtları yükleniyor...",
							showMask: true,
							mode: "iframe",
							url: "isleme-ait-kayitlar.aspx?tablo_adi=tbl_urunler&kayit_id=" + record.data.id,
							scripts: true
						},
						buttonAlign: 'right',
						buttons: [
			{
				iconCls: "icon-cancel",
				text: 'KAPAT',
				handler: function () {
					win.close();
				}
			}
		]
					});

					win.show();

					break;

				case "Sil":
					Ext.Msg.confirm('Uyarı', 'Seçilen Kaydı Sil?', function (btn) {
						if (btn == "yes") {
							Store1.remove(record);
							Store1.save();
						}
					});
					break;

				case "Duzenle":
					Ext.net.DirectMethods.GuncellemeEkraniGetir(record.data.id);
					break;

				case "OnayVer":
					Ext.Msg.confirm('Uyarı', 'Seçilen Kaydı Onayla?', function (btn) {
						if (btn == "yes") {
							Ext.net.DirectMethods.OnayVer(record.data.id);
						}
					});
					break;

				case "OnayKaldir":
					Ext.Msg.confirm('Uyarı', 'Seçilen Kaydın Onayını Kaldır?', function (btn) {
						if (btn == "yes") {
							Ext.net.DirectMethods.OnayKaldir(record.data.id);
						}
					});
					break;
			}
		}

		function Ekle_NodeYukleKategoriler(node) {
			Ext.net.DirectMethods.Ekle_NodeYukleKategoriler(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

		var Ekle_KategorilerEkle = function (tree) {
			var msg = [],
				selNodes = tree.getChecked();
			msg.push("[");

			Ext.each(selNodes, function (node) {
				if (msg.length > 1) {
					msg.push(",");
				}

				msg.push(node.text);
			});

			//msg.push("]");

			msg = msg.join("");

			return msg.substring(1, msg.length);
		};

		var Ekle_KategorilerNodeTemizle = function () {
			Ekle_TreePanelKategoriler.getRootNode().cascade(function (n) {
				var ui = n.getUI();
				ui.toggleCheck(false);
			});
		}

		var Ekle_KategorilerNodeSec = function () {
			Ekle_TreePanelKategoriler.getRootNode().cascade(function (n) {
				var ui = n.getUI();
				ui.toggleCheck(true);
			});
		}

		function Ekle_NodeYukleKategorilerResim(node) {
			Ext.net.DirectMethods.Ekle_NodeYukleKategorilerResim(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

		var Ekle_KategorilerResimEkle = function (tree) {
			var msg = [],
				selNodes = tree.getChecked();

			Ext.each(selNodes, function (node) {
				if (msg.length > 1) {
					msg.push(",");
				}

				msg.push(node.text);
			});

			return msg.join("");
		};

		var Ekle_KategorilerResimNodeTemizle = function () {
			Ekle_TreePanelKategorilerResim.getRootNode().cascade(function (n) {
				var ui = n.getUI();
				ui.toggleCheck(false);
			});
		}

		function Ekle_NodeYukleKategorilerVideo(node) {
			Ext.net.DirectMethods.Ekle_NodeYukleKategorilerVideo(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

		var Ekle_KategorilerVideoEkle = function (tree) {
			var msg = [],
				selNodes = tree.getChecked();

			Ext.each(selNodes, function (node) {
				if (msg.length > 1) {
					msg.push(",");
				}

				msg.push(node.text);
			});

			return msg.join("");
		};

		var Ekle_KategorilerVideoNodeTemizle = function () {
			Ekle_TreePanelKategorilerVideo.getRootNode().cascade(function (n) {
				var ui = n.getUI();
				ui.toggleCheck(false);
			});
		}

		function Duzenle_NodeYukleKategoriler(node) {
			Ext.net.DirectMethods.Duzenle_NodeYukleKategoriler(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

		var Duzenle_KategorilerDuzenle = function (tree) {
			var msg = [],
				selNodes = tree.getChecked();
			msg.push("[");

			Ext.each(selNodes, function (node) {
				if (msg.length > 1) {
					msg.push(",");
				}

				msg.push(node.text);
			});

			//msg.push("]");

			msg = msg.join("");

			return msg.substring(1, msg.length);
		};

		var Duzenle_KategorilerNodeTemizle = function () {
			Duzenle_TreePanelKategoriler.getRootNode().cascade(function (n) {
				var ui = n.getUI();
				ui.toggleCheck(false);
			});
		}

		var Duzenle_KategorilerNodeSec = function () {
			Duzenle_TreePanelKategoriler.getRootNode().cascade(function (n) {
				var ui = n.getUI();
				ui.toggleCheck(true);
			});
		}

		function Duzenle_NodeYukleKategorilerResim(node) {
			Ext.net.DirectMethods.Duzenle_NodeYukleKategorilerResim(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

		var Duzenle_KategorilerResimEkle = function (tree) {
			var msg = [],
				selNodes = tree.getChecked();

			Ext.each(selNodes, function (node) {
				if (msg.length > 1) {
					msg.push(",");
				}

				msg.push(node.text);
			});

			return msg.join("");
		};

		var Duzenle_KategorilerResimDuzenle = function (tree) {
			var msg = [],
				selNodes = tree.getChecked();
			msg.push("[");

			Ext.each(selNodes, function (node) {
				if (msg.length > 1) {
					msg.push(",");
				}

				msg.push(node.text);
			});

			//msg.push("]");

			msg = msg.join("");

			return msg.substring(1, msg.length);
		};

		function Duzenle_NodeYukleKategorilerVideo(node) {
			Ext.net.DirectMethods.Duzenle_NodeYukleKategorilerVideo(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

		var Duzenle_KategorilerVideoEkle = function (tree) {
			var msg = [],
				selNodes = tree.getChecked();

			Ext.each(selNodes, function (node) {
				if (msg.length > 1) {
					msg.push(",");
				}

				msg.push(node.text);
			});

			return msg.join("");
		};

		var Duzenle_KategorilerVideoDuzenle = function (tree) {
			var msg = [],
				selNodes = tree.getChecked();
			msg.push("[");

			Ext.each(selNodes, function (node) {
				if (msg.length > 1) {
					msg.push(",");
				}

				msg.push(node.text);
			});

			//msg.push("]");

			msg = msg.join("");

			return msg.substring(1, msg.length);
		};

		var Duzenle_ResimKategoriDegistir = function () {
			if (Duzenle_ChecboxResimKategori.getValue()) {
				Duzenle_DropDownFieldKategorilerResim.setDisabled(false);
				Duzenle_DropDownFieldKategorilerResim.AllowBlank(true);
			}
			else {
				Duzenle_DropDownFieldKategorilerResim.setDisabled(true);
				Duzenle_DropDownFieldKategorilerResim.AllowBlank(false);
			}
		}

		var Duzenle_VideoKategoriDegistir = function () {
			if (Duzenle_ChecboxVideoKategori.getValue()) {
				Duzenle_DropDownFieldKategorilerVideo.setDisabled(false);
				Duzenle_DropDownFieldKategorilerVideo.AllowBlank(true);
			}
			else {
				Duzenle_DropDownFieldKategorilerVideo.setDisabled(true);
				Duzenle_DropDownFieldKategorilerVideo.AllowBlank(false);
			}
		}

		var Duzenle_MarkaDegistir = function () {
			if (Duzenle_ChecboxMarka.getValue()) {
				Duzenle_MultiComboMarka.setDisabled(false);
				Duzenle_MultiComboMarka.AllowBlank(true);
			}
			else {
				Duzenle_MultiComboMarka.setDisabled(true);
				Duzenle_MultiComboMarka.AllowBlank(false);
			}
		}
	</script>
	<form id="form1" runat="server">
	<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Gray" Locale="tr-TR"
		GZip="true" />
	<ext:Viewport ID="Viewport1" runat="server" Layout="FitLayout" StyleSpec="background-color:#F0F0F0">
		<Items>
			<ext:Window ID="Window1" runat="server" Maximized="true" Title="Ürünler" Layout="FitLayout"
				Icon="PackageGreen" Closable="false" Minimizable="false" MinHeight="480" MinWidth="640">
				<Items>
					<ext:GridPanel ID="GridPanel1" runat="server" ColumnLines="true" SortType="AsUCString"
						AutoExpandColumn="ad" OnBeforeClientInit="GridPanelYuklenmedenOnce" AnchorHorizontal="100%"
						Region="Center" AutoScroll="true" MonitorResize="true" TrackMouseOver="true">
						<Store>
							<ext:Store ID="Store1" runat="server" OnRefreshData="KayitlariYenile" OnAfterRecordDeleted="KayitSil"
								RemoteSort="true">
								<Proxy>
									<ext:PageProxy />
								</Proxy>
								<AutoLoadParams>
									<ext:Parameter Name="start" Value="0" Mode="Raw" />
									<ext:Parameter Name="limit" Value="25" Mode="Raw" />
									<ext:Parameter Name="sort" Value="" />
									<ext:Parameter Name="dir" Value="" />
								</AutoLoadParams>
								<SortInfo Field="id" Direction="DESC" />
								<Reader>
									<ext:JsonReader IDProperty="id">
										<Fields>
											<ext:RecordField Name="id" Type="Int" />
											<ext:RecordField Name="dil_id" Type="Int" />
											<ext:RecordField Name="dil" />
											<ext:RecordField Name="kod_id" Type="Int" />
											<ext:RecordField Name="kod" />
											<ext:RecordField Name="resim_id" Type="Int" />
											<ext:RecordField Name="resim" />
											<ext:RecordField Name="resim_kategori_id" Type="Int" />
											<ext:RecordField Name="resim_kategori" />
											<ext:RecordField Name="video_kategori_id" Type="Int" />
											<ext:RecordField Name="video_kategori" />
											<ext:RecordField Name="etiket_id" Type="Int" />
											<ext:RecordField Name="marka" />
											<ext:RecordField Name="kategori" />
											<ext:RecordField Name="etiket" />
											<ext:RecordField Name="ad" />
											<ext:RecordField Name="on_aciklama" />
											<ext:RecordField Name="anasayfa" />
											<ext:RecordField Name="ziyaret" Type="Int" />
											<ext:RecordField Name="ekleyen" />
											<ext:RecordField Name="tarih_ek" Type="Date" />
											<ext:RecordField Name="guncelleyen" />
											<ext:RecordField Name="tarih_gun" Type="Date" />
											<ext:RecordField Name="onay" />
										</Fields>
									</ext:JsonReader>
								</Reader>
							</ext:Store>
						</Store>
						<ColumnModel runat="server">
							<Columns>
								<ext:RowNumbererColumn MenuDisabled="true" ColumnID="check" Resizable="false" Editable="false"
									Width="55" />
								<ext:Column DataIndex="id" Header="ID" />
								<ext:Column DataIndex="dil_id" Header="Dil ID" Hidden="true" />
								<ext:Column DataIndex="dil" Header="Dil" MenuDisabled="true" Sortable="false" />
								<ext:Column DataIndex="resim_id" Header="Resim ID" Hidden="true" />
								<ext:Column DataIndex="resim" Header="Resim" MenuDisabled="true" Sortable="false">
									<Renderer Fn="UrunResimYol" />
								</ext:Column>
								<ext:Column DataIndex="resim_kategori_id" Header="Resim Grup ID" Hidden="true" />
								<ext:Column DataIndex="resim_kategori" Header="Resim Grup(lar)" MenuDisabled="true"
									Sortable="false" />
								<ext:Column DataIndex="video_kategori_id" Header="Video Grup ID" Hidden="true" />
								<ext:Column DataIndex="video_kategori" Header="Video Grup(lar)" MenuDisabled="true"
									Sortable="false" />
								<ext:Column DataIndex="marka" Header="Marka(lar)" MenuDisabled="true" Sortable="false" />
								<ext:Column DataIndex="kategori" Header="Kategori(ler)" MenuDisabled="true" Sortable="false" />
								<ext:Column DataIndex="etiket" Header="Etiket(ler)" MenuDisabled="true" Sortable="false" />
								<ext:Column DataIndex="kod_id" Header="Kod ID" Hidden="true" />
								<ext:Column DataIndex="kod" Header="Ürün Kodu" MenuDisabled="true" Sortable="false" />
								<ext:Column DataIndex="ad" Header="Ürün Adı" />
								<ext:Column DataIndex="on_aciklama" Header="Ön Açıklama" Hidden="true" />
								<ext:Column DataIndex="anasayfa" Header="Anasayfa" Align="Center" Width="60">
									<Renderer Fn="AnasayfaRenk" />
								</ext:Column>
								<ext:Column DataIndex="ziyaret" Header="Ziyaret" Width="55" MenuDisabled="true" Sortable="false" />
								<ext:Column DataIndex="ekleyen" Header="Ekleyen" />
								<ext:DateColumn DataIndex="tarih_ek" Header="Kayıt Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
									Width="125" />
								<ext:Column DataIndex="guncelleyen" Header="Güncelleyen" />
								<ext:DateColumn DataIndex="tarih_gun" Header="Güncelleme Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
									Width="125" />
								<ext:Column DataIndex="onay" Header="Onay" Align="Center" Width="60">
									<Renderer Fn="OnayRenk" />
								</ext:Column>
								<ext:CommandColumn Header="Gör" Align="Center" Width="30" MenuDisabled="true" Resizable="false"
									ButtonAlign="Center">
									<Commands>
										<ext:GridCommand Icon="Picture" CommandName="Goster">
											<ToolTip Text="Resmi göster" />
										</ext:GridCommand>
									</Commands>
								</ext:CommandColumn>
								<ext:CommandColumn Header="İşlemler" Align="Center" Width="115" MenuDisabled="true"
									Resizable="false" ButtonAlign="Center">
									<Commands>
										<ext:GridCommand Icon="NoteEdit" CommandName="Duzenle">
											<ToolTip Text="Seçilen kaydı düzenle." />
										</ext:GridCommand>
										<ext:CommandSeparator />
									</Commands>
									<Commands>
										<ext:GridCommand Icon="Tick" CommandName="OnayVer">
											<ToolTip Text="Seçilen kayıt için onay ver." />
										</ext:GridCommand>
										<ext:CommandSeparator />
									</Commands>
									<Commands>
										<ext:GridCommand Icon="Cross" CommandName="OnayKaldir">
											<ToolTip Text="Seçilen kayıt için onayı kaldır." />
										</ext:GridCommand>
										<ext:CommandSeparator />
									</Commands>
									<Commands>
										<ext:GridCommand Icon="Delete" CommandName="Sil">
											<ToolTip Text="Seçilen kaydı sil." />
										</ext:GridCommand>
									</Commands>
									<PrepareToolbar Fn="DugmelerinDurumu" />
								</ext:CommandColumn>
								<ext:CommandColumn Header="İK" Align="Center" Width="28" MenuDisabled="true" Resizable="false"
									ButtonAlign="Center">
									<Commands>
										<ext:GridCommand Icon="UserComment" CommandName="IslemKaydi">
											<ToolTip Text="İşlem Kaydını göster" />
										</ext:GridCommand>
									</Commands>
								</ext:CommandColumn>
							</Columns>
						</ColumnModel>
						<Plugins>
							<ext:GridFilters runat="server" ID="GridFilters1" Local="true">
								<Filters>
									<ext:NumericFilter DataIndex="id" />
									<ext:NumericFilter DataIndex="dil_id" />
									<ext:NumericFilter DataIndex="kod_id" />
									<ext:NumericFilter DataIndex="resim_id" />
									<ext:NumericFilter DataIndex="resim_kategori_id" />
									<ext:NumericFilter DataIndex="video_kategori_id" />
									<ext:StringFilter DataIndex="ad" />
									<ext:StringFilter DataIndex="on_aciklama" />
									<ext:StringFilter DataIndex="ekleyen" />
									<ext:StringFilter DataIndex="guncelleyen" />
									<ext:DateFilter DataIndex="tarih_ek">
										<DatePickerOptions runat="server" TodayText="Now" />
									</ext:DateFilter>
									<ext:DateFilter DataIndex="tarih_gun">
										<DatePickerOptions runat="server" TodayText="Now" />
									</ext:DateFilter>
									<ext:ListFilter DataIndex="anasayfa" Options="EVET,HAYIR" />
									<ext:ListFilter DataIndex="onay" Options="EVET,HAYIR" />
								</Filters>
							</ext:GridFilters>
						</Plugins>
						<SelectionModel>
							<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server" />
						</SelectionModel>
						<Buttons>
							<ext:Button runat="server" ID="Button7" Text="Anasayfada Yayınla" Icon="BookLink">
								<DirectEvents>
									<Click OnEvent="AnasayfaEkle">
										<Confirmation ConfirmRequest="true" Message="İşlemi onaylıyor musunuz?" Title="Onay" />
										<EventMask ShowMask="true" MinDelay="500" Msg="Yükleniyor..." />
									</Click>
								</DirectEvents>
							</ext:Button>
														<ext:Button runat="server" ID="Button5" Text="Anasayfadan Kaldır" Icon="BookDelete">
								<DirectEvents>
									<Click OnEvent="AnasayfaKaldir">
										<Confirmation ConfirmRequest="true" Message="İşlemi onaylıyor musunuz?" Title="Onay" />
										<EventMask ShowMask="true" MinDelay="500" Msg="Yükleniyor..." />
									</Click>
								</DirectEvents>
							</ext:Button>
							<ext:Button runat="server" ID="ButtonResimYukle" Text="Dosya Yükle" Icon="Attach">
								<DirectEvents>
									<Click OnEvent="DosyaYuklemeEkraniGetir">
										<EventMask ShowMask="true" MinDelay="500" Msg="Yükleniyor..." />
									</Click>
								</DirectEvents>
							</ext:Button>
							<ext:Button runat="server" ID="Button1" Text="Yeni" Icon="Add">
								<DirectEvents>
									<Click OnEvent="YeniKayitEkraniGetir">
										<EventMask ShowMask="true" MinDelay="500" Msg="Yükleniyor..." />
									</Click>
								</DirectEvents>
							</ext:Button>
							<ext:Button runat="server" ID="Button2" Text="Onayla" Icon="Tick">
								<DirectEvents>
									<Click OnEvent="SecilenleriOnayla">
										<Confirmation ConfirmRequest="true" Message="İşlemi onaylıyor musunuz?" Title="Onay" />
										<EventMask ShowMask="true" MinDelay="500" Msg="Yükleniyor..." />
									</Click>
								</DirectEvents>
							</ext:Button>
							<ext:Button runat="server" ID="Button3" Text="Onay Kaldır" Icon="Cross">
								<DirectEvents>
									<Click OnEvent="SecilenleriOnaysizYap">
										<Confirmation ConfirmRequest="true" Message="İşlemi onaylıyor musunuz?" Title="Onay" />
										<EventMask ShowMask="true" MinDelay="500" Msg="Yükleniyor..." />
									</Click>
								</DirectEvents>
							</ext:Button>
							<ext:Button runat="server" ID="Button4" Text="Sil" Icon="Delete">
								<DirectEvents>
									<Click OnEvent="SecilenleriSil">
										<Confirmation ConfirmRequest="true" Message="İşlemi onaylıyor musunuz?" Title="Onay" />
										<EventMask ShowMask="true" MinDelay="500" Msg="Yükleniyor..." />
									</Click>
								</DirectEvents>
							</ext:Button>
						</Buttons>
						<LoadMask ShowMask="true" Msg="Yükleniyor..." />
						<SaveMask ShowMask="true" Msg="Kaydediliyor..." />
						<TopBar>
							<ext:Toolbar ID="Toolbar1" runat="server">
								<Items>
									<ext:ComboBox ID="ComboBoxDil" AnchorHorizontal="100%" runat="server" DisplayField="dil"
										ValueField="id" Editable="false" Selectable="true" StyleSpec="float:left">
										<Store>
											<ext:Store ID="StoreDil" runat="server" WarningOnDirty="false">
												<Reader>
													<ext:JsonReader>
														<Fields>
															<ext:RecordField Name="id" Type="Int" />
															<ext:RecordField Name="dil" />
														</Fields>
													</ext:JsonReader>
												</Reader>
											</ext:Store>
										</Store>
										<Listeners>
											<Select Handler="DilDegistir()" />
										</Listeners>
									</ext:ComboBox>
									<ext:ToolbarFill ID="ToolbarFill1" runat="server" />
									<ext:Button ID="ButtonXLS" runat="server" Text="XLS" Icon="PageWhiteExcel">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="xls" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
									<ext:Button ID="ButtonDOC" runat="server" Text="DOC" Icon="PageWhiteWord">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="doc" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
									<ext:Button ID="ButtonCSV" runat="server" Text="CSV" Icon="PageAttach">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="csv" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
									<ext:Button ID="ButtonXML" runat="server" Text="XML" Icon="PageWhiteCode">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="xml" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
									<ext:Button ID="ButtonHTML" runat="server" Text="HTML" Icon="PageWhiteH">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="html" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
									<ext:Button ID="ButtonPDF" runat="server" Text="PDF" Icon="PageWhiteAcrobat">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="pdf" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
								</Items>
							</ext:Toolbar>
						</TopBar>
						<BottomBar>
							<ext:PagingToolbar ID="PagingToolbar1" runat="server" PageSize="25">
								<Items>
									<ext:ToolbarSeparator>
									</ext:ToolbarSeparator>
									<ext:Label ID="Label_Sayfalama" runat="server" Text="Sayfalama Sayısı :" />
									<ext:ToolbarSpacer ID="ToolbarSpacer1" runat="server" Width="10" />
									<ext:ComboBox ID="ComboBox1" runat="server" Width="60" Editable="false">
										<Items>
											<ext:ListItem Text="10" />
											<ext:ListItem Text="25" />
											<ext:ListItem Text="50" />
											<ext:ListItem Text="100" />
											<ext:ListItem Text="500" />
											<ext:ListItem Text="1000" />
											<ext:ListItem Text="2500" />
											<ext:ListItem Text="5000" />
										</Items>
										<SelectedItem Value="25" />
										<Listeners>
											<Select Handler="#{PagingToolbar1}.pageSize = parseInt(this.getValue()); #{PagingToolbar1}.doLoad();" />
										</Listeners>
									</ext:ComboBox>
									<ext:ToolbarSpacer ID="ToolbarSpacer2" runat="server" Width="5" />
									<ext:ToolbarSeparator>
									</ext:ToolbarSeparator>
									<ext:Label runat="server" ID="YoneticiAdi" OnBeforeClientInit="YoneticiAdiYaz">
									</ext:Label>
								</Items>
							</ext:PagingToolbar>
						</BottomBar>
						<Listeners>
							<Command Fn="GridKomutlari" />
						</Listeners>
					</ext:GridPanel>
				</Items>
			</ext:Window>
			<ext:Window ID="WindowEkle" runat="server" Modal="false" Resizable="True" Height="500"
				Icon="Add" Title="Ekle" Width="640" Padding="5" Layout="FormLayout" ButtonAlign="Center"
				Shadow="None" LabelSeparator=" : " Draggable="True" AutoFocus="True" AutoHeight="True"
				Hidden="true">
				<Items>
					<ext:ComboBox ID="Ekle_ComboBoxDil" FieldLabel="Dil" AnchorHorizontal="100%" runat="server"
						DisplayField="dil" ValueField="id" Editable="true" TypeAhead="true" Mode="Local"
						ForceSelection="true" SelectOnFocus="true" EmptyText="Dil Seçiniz...">
						<Store>
							<ext:Store ID="StoreDil1" runat="server" WarningOnDirty="false">
								<Reader>
									<ext:JsonReader>
										<Fields>
											<ext:RecordField Name="id" Type="Int" />
											<ext:RecordField Name="dil" />
										</Fields>
									</ext:JsonReader>
								</Reader>
							</ext:Store>
						</Store>
						<Listeners>
						<Change Handler="Ekle_KategorilerNodeTemizle();" />
						</Listeners>
						<DirectEvents>
						<Change OnEvent="Ekle_DileGoreKategoriYukle">
						<EventMask ShowMask="true" MinDelay="500" Msg="Seçilen dile ait kategoriler yükleniyor..." />
						</Change>
						</DirectEvents>
					</ext:ComboBox>
					<ext:Panel ID="Ekle_PanelCollapsedMarkaKod" runat="server" Title="Marka/Kod Bilgileri"
						FormGroup="true" Layout="FormLayout" Padding="5" StyleSpec="margin-top:5px;margin-bottom:5px;background:#fff;border:1px solid #C3DAF9"
						Collapsed="true" LabelSeparator=" : ">
						<Content>
							<ext:MultiCombo ID="Ekle_MultiComboMarka" FieldLabel="Marka" AnchorHorizontal="100%"
								runat="server" DisplayField="marka" ValueField="id" TypeAhead="true" Mode="Local"
								ForceSelection="true" SelectOnFocus="true" EmptyText="Marka Seçiniz...">
								<Store>
									<ext:Store ID="StoreMarka1" runat="server" WarningOnDirty="false">
										<Reader>
											<ext:JsonReader>
												<Fields>
													<ext:RecordField Name="id" Type="Int" />
													<ext:RecordField Name="marka" />
												</Fields>
											</ext:JsonReader>
										</Reader>
									</ext:Store>
								</Store>
								<Triggers>
									<ext:FieldTrigger Icon="Clear" Qtip="Seçimi Temizle" />
								</Triggers>
								<Listeners>
									<TriggerClick Handler="this.clearValue();" />
								</Listeners>
							</ext:MultiCombo>
							<ext:ComboBox ID="Ekle_ComboBoxKod" FieldLabel="Ürün Kodu" AnchorHorizontal="100%"
								runat="server" DisplayField="kod" ValueField="id" Editable="true" TypeAhead="true"
								Mode="Local" ForceSelection="true" SelectOnFocus="true" EmptyText="Ürün Kodu Seçiniz...">
								<Store>
									<ext:Store ID="StoreKod1" runat="server" WarningOnDirty="false">
										<Reader>
											<ext:JsonReader>
												<Fields>
													<ext:RecordField Name="id" Type="Int" />
													<ext:RecordField Name="kod" />
												</Fields>
											</ext:JsonReader>
										</Reader>
									</ext:Store>
								</Store>
								<Triggers>
									<ext:FieldTrigger Icon="Clear" Qtip="Seçimi Temizle" />
								</Triggers>
								<Listeners>
									<TriggerClick Handler="this.clearValue();" />
								</Listeners>
							</ext:ComboBox>
						</Content>
					</ext:Panel>
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Ekle_TextFieldAd" MaxLength="110" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Ürün Adı" BlankText="Lütfen ürün adını yazın." AnchorHorizontal="96%"
						IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" EnableKeyEvents="true">
						<Listeners>
							<KeyUp Handler="this.setValue(this.getValue().toUpperCase());" />
						</Listeners>
					</ext:TextField>
					<ext:ComboBox ID="Ekle_ComboBoxResim" FieldLabel="Resim" AnchorHorizontal="100%"
						runat="server" DisplayField="ad" ValueField="id" Editable="true" TypeAhead="true"
						Mode="Local" ForceSelection="true" SelectOnFocus="true" EmptyText="Resim Seçiniz...">
						<Store>
							<ext:Store ID="StoreResim1" runat="server" WarningOnDirty="false">
								<Reader>
									<ext:JsonReader>
										<Fields>
											<ext:RecordField Name="id" Type="Int" />
											<ext:RecordField Name="ad" />
										</Fields>
									</ext:JsonReader>
								</Reader>
							</ext:Store>
						</Store>
						<Triggers>
							<ext:FieldTrigger Icon="Clear" Qtip="Seçimi Temizle" />
						</Triggers>
						<Listeners>
							<TriggerClick Handler="this.clearValue();" />
						</Listeners>
					</ext:ComboBox>
					<ext:DropDownField ID="Ekle_DropDownFieldKategoriler" FieldLabel="Kategori" runat="server"
						Editable="false" TriggerIcon="SimpleArrowDown" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" EmptyText="Kategori Seçiniz...">
						<Component>
							<ext:TreePanel Shadow="None" ID="Ekle_TreePanelKategoriler" runat="server" MinWidth="200" Title="Kategoriler"
								Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true" Animate="true"
								EnableDD="false" ContainerScroll="true" RootVisible="False" Selectable="true">
								<Root>
									<ext:AsyncTreeNode NodeID="0" Text="Kategoriler" Icon="ColorSwatch" Expanded="true" />
								</Root>
								<Listeners>
									<BeforeLoad Fn="Ekle_NodeYukleKategoriler" />
								</Listeners>
								<BottomBar>
									<ext:Toolbar runat="server" ID="Ekle_ToolbarKategoriler" StyleSpec="padding:5px">
										<Items>
											<ext:Button ID="Ekle_ButtonKategorilerSec" runat="server" Icon="ArrowDivide" Text="Tümünü Seç"
												StandOut="true">
												<Listeners>
													<Click Handler="Ekle_KategorilerNodeSec()" />
												</Listeners>
											</ext:Button>
											<ext:Button StyleSpec="margin-left:10px" ID="Ekle_ButtonKategorilerTemizle" runat="server"
												Icon="ArrowOut" Text="Temizle" StandOut="true">
												<Listeners>
													<Click Handler="Ekle_KategorilerNodeTemizle()" />
												</Listeners>
											</ext:Button>
										</Items>
									</ext:Toolbar>
								</BottomBar>
								<Listeners>
									<CheckChange Handler="this.dropDownField.setValue(Ekle_KategorilerEkle(this), false)" />
								</Listeners>
							</ext:TreePanel>
						</Component>
					</ext:DropDownField>
					<ext:TextArea ID="Ekle_TextAreaOnAciklama" MaxLength="500" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Ön Açıklama" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" MsgTarget="Side" AllowBlank="false"
						BlankText="Lütfen bir ön açıklama yazın" />
					<ext:Panel ID="Ekle_PanelCollapsedAciklama" runat="server" Title="Açıklama (Detay) Bilgileri"
						FormGroup="true" Layout="FormLayout" Padding="5" StyleSpec="margin-top:5px;background:#fff;border:1px solid #C3DAF9"
						Collapsed="true" LabelSeparator=" : ">
						<Content>
							<ext:HtmlEditor ID="Ekle_HtmlEditorAciklama" runat="server" FieldLabel="Açıklama"
								Height="150" AnchorHorizontal="100%" AnchorVertical="100%" />
						</Content>
					</ext:Panel>
					<ext:Panel ID="Ekle_PanelCollapsedResimVideo" runat="server" Title="Resim Grup ve Video Grup Bilgileri"
						FormGroup="true" Layout="FormLayout" Padding="5" StyleSpec="margin-top:5px;margin-bottom:5px;background:#fff;border:1px solid #C3DAF9"
						Collapsed="true" LabelSeparator=" : ">
						<Content>
							<ext:DropDownField ID="Ekle_DropDownFieldKategorilerResim" FieldLabel="Resim Grup"
								runat="server" Editable="false" TriggerIcon="SimpleArrowDown" AnchorHorizontal="100%"
								EmptyText="Resim grubu seçiniz...">
								<Component>
									<ext:TreePanel Shadow="None" ID="Ekle_TreePanelKategorilerResim" runat="server" MinWidth="200"
										Title="Resim Grupları" Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true"
										Animate="true" EnableDD="false" ContainerScroll="true" RootVisible="False" Selectable="true">
										<Root>
											<ext:AsyncTreeNode NodeID="0" Text="KategorilerResim" Icon="ColorSwatch" Expanded="true" />
										</Root>
										<Listeners>
											<BeforeLoad Fn="Ekle_NodeYukleKategorilerResim" />
											<CheckChange Handler="if(this.lock){return;}if(checked){if(!this.checkedNode){this.checkedNode=node;}else{this.lock=true;this.checkedNode.ui.toggleCheck(false);this.lock=false;this.checkedNode=node;}}else{this.checkedNode=null;};this.dropDownField.setValue(Ekle_KategorilerResimEkle(this), false)" />
										</Listeners>
									</ext:TreePanel>
								</Component>
							</ext:DropDownField>
							<ext:DropDownField ID="Ekle_DropDownFieldKategorilerVideo" FieldLabel="Video Grup"
								runat="server" Editable="false" TriggerIcon="SimpleArrowDown" AnchorHorizontal="100%"
								EmptyText="Video grubu seçiniz...">
								<Component>
									<ext:TreePanel Shadow="None" ID="Ekle_TreePanelKategorilerVideo" runat="server" MinWidth="200"
										Title="Video Grupları" Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true"
										Animate="true" EnableDD="false" ContainerScroll="true" RootVisible="False" Selectable="true">
										<Root>
											<ext:AsyncTreeNode NodeID="0" Text="KategorilerVideo" Icon="ColorSwatch" Expanded="true" />
										</Root>
										<Listeners>
											<BeforeLoad Fn="Ekle_NodeYukleKategorilerVideo" />
											<CheckChange Handler="if(this.lock){return;}if(checked){if(!this.checkedNode){this.checkedNode=node;}else{this.lock=true;this.checkedNode.ui.toggleCheck(false);this.lock=false;this.checkedNode=node;}}else{this.checkedNode=null;};this.dropDownField.setValue(Ekle_KategorilerVideoEkle(this), false)" />
										</Listeners>
									</ext:TreePanel>
								</Component>
							</ext:DropDownField>
						</Content>
					</ext:Panel>
					<ext:TextField ID="Ekle_TextFieldEtiketler" runat="server" FieldLabel="Etiket(ler)" AnchorHorizontal="100%"
						EnableKeyEvents="true">
						<Listeners>
							<KeyUp Handler="this.setValue(this.getValue().toLowerCase());" />
						</Listeners>
					</ext:TextField>
					<ext:ComboBox ID="Ekle_ComboBoxAnasayfa" runat="server" FieldLabel="Anasayfa" Editable="false"
						Selectable="true">
						<Items>
							<ext:ListItem Text="EVET" Value="1" />
							<ext:ListItem Text="HAYIR" Value="0" />
						</Items>
						<SelectedItem Value="1" />
					</ext:ComboBox>
					<ext:ComboBox ID="Ekle_ComboBoxOnay" runat="server" FieldLabel="Onay" Editable="false"
						Selectable="true">
						<Items>
							<ext:ListItem Text="Onay Ver" Value="1" />
							<ext:ListItem Text="Henüz Değil" Value="0" />
						</Items>
						<SelectedItem Value="1" />
					</ext:ComboBox>
				</Items>
				<Buttons>
					<ext:Button ID="Ekle_Kaydet" runat="server" Text="Kaydet" Icon="Accept" Type="Submit">
						<Listeners>
							<Click Fn="KaydetKontrol" />
						</Listeners>
						<DirectEvents>
							<Click OnEvent="YeniKayitYap">
								<EventMask ShowMask="true" Msg="Kaydediliyor..." MinDelay="500" />
							</Click>
						</DirectEvents>
					</ext:Button>
				</Buttons>
				<Listeners>
					<Hide Handler="WindowEkleClear()" />
					<Show Handler="Ekle_HtmlEditorAciklama.clear();Ekle_KategorilerResimNodeTemizle();Ekle_KategorilerVideoNodeTemizle();" />
				</Listeners>
			</ext:Window>
			<ext:Window ID="WindowDuzenle" runat="server" Modal="true" Resizable="True" Height="500"
				Icon="NoteEdit" Title="Düzenle" Width="640" Padding="5" Layout="FormLayout" ButtonAlign="Center"
				Shadow="None" LabelSeparator=" : " Draggable="True" AutoFocus="True" AutoHeight="True"
				Hidden="true">
				<Items>
					<ext:TextField ID="Duzenle_ID" Hidden="true" runat="server" />
					<ext:ComboBox ID="Duzenle_ComboBoxDil" FieldLabel="Dil" AnchorHorizontal="100%" runat="server"
						DisplayField="dil" ValueField="id" Editable="true" TypeAhead="true" Mode="Local"
						ForceSelection="true" SelectOnFocus="true" EmptyText="Dil Seçiniz...">
						<Store>
							<ext:Store ID="StoreDil2" runat="server" WarningOnDirty="false">
								<Reader>
									<ext:JsonReader>
										<Fields>
											<ext:RecordField Name="id" Type="Int" />
											<ext:RecordField Name="dil" />
										</Fields>
									</ext:JsonReader>
								</Reader>
							</ext:Store>
						</Store>
						<Listeners>
						<Change Handler="Duzenle_KategorilerNodeTemizle();" />
						</Listeners>
						<DirectEvents>
						<Change OnEvent="Duzenle_DileGoreKategoriYukle">
						<EventMask ShowMask="true" MinDelay="500" Msg="Seçilen dile ait kategoriler yükleniyor..." />
						</Change>
						</DirectEvents>
					</ext:ComboBox>
					<ext:Panel ID="Duzenle_PanelCollapsedMarkaKod" runat="server" Title="Marka/Kod Bilgileri"
						FormGroup="true" Layout="FormLayout" Padding="5" StyleSpec="margin-top:5px;margin-bottom:5px;background:#fff;border:1px solid #C3DAF9"
						Collapsed="true" LabelSeparator=" : ">
						<Content>
							<ext:Panel ID="Duzenle_PanelMarka" runat="server" FormGroup="true" Layout="FormLayout"
								Padding="5" StyleSpec="border:1px solid #C3DAF9" LabelSeparator=" : ">
								<Content>
									<ext:Checkbox ID="Duzenle_ChecboxMarka" runat="server" FieldLabel="Marka Değiştir">
										<Listeners>
											<Check Fn="Duzenle_MarkaDegistir" />
										</Listeners>
									</ext:Checkbox>
									<ext:Label ID="Duzenle_LabelMarka" runat="server" FieldLabel="Marka (lar)" />
									<ext:MultiCombo ID="Duzenle_MultiComboMarka" FieldLabel="Marka" AnchorHorizontal="100%"
										runat="server" DisplayField="marka" ValueField="id" TypeAhead="true" Mode="Local"
										ForceSelection="true" SelectOnFocus="true" EmptyText="Marka Seçiniz..." Disabled="true">
										<Store>
											<ext:Store ID="StoreMarka2" runat="server" WarningOnDirty="false">
												<Reader>
													<ext:JsonReader>
														<Fields>
															<ext:RecordField Name="id" Type="Int" />
															<ext:RecordField Name="marka" />
														</Fields>
													</ext:JsonReader>
												</Reader>
											</ext:Store>
										</Store>
										<Triggers>
											<ext:FieldTrigger Icon="Clear" Qtip="Seçimi Temizle" />
										</Triggers>
										<Listeners>
											<TriggerClick Handler="this.clearValue();" />
										</Listeners>
									</ext:MultiCombo>
								</Content>
							</ext:Panel>
							<ext:Panel ID="Duzenle_PanelKod" runat="server" FormGroup="true" Layout="FormLayout"
								Padding="5" StyleSpec="margin-top:5px;border:1px solid #C3DAF9" LabelSeparator=" : ">
								<Content>
									<ext:ComboBox ID="Duzenle_ComboBoxKod" FieldLabel="Ürün Kodu" AnchorHorizontal="100%"
										runat="server" DisplayField="kod" ValueField="id" Editable="true" TypeAhead="true"
										Mode="Local" ForceSelection="true" SelectOnFocus="true" EmptyText="Ürün Kodu Seçiniz...">
										<Store>
											<ext:Store ID="StoreKod2" runat="server" WarningOnDirty="false">
												<Reader>
													<ext:JsonReader>
														<Fields>
															<ext:RecordField Name="id" Type="Int" />
															<ext:RecordField Name="kod" />
														</Fields>
													</ext:JsonReader>
												</Reader>
											</ext:Store>
										</Store>
										<Triggers>
											<ext:FieldTrigger Icon="Clear" Qtip="Seçimi Temizle" />
										</Triggers>
										<Listeners>
											<TriggerClick Handler="this.clearValue();" />
										</Listeners>
									</ext:ComboBox>
								</Content>
							</ext:Panel>
						</Content>
					</ext:Panel>
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Duzenle_TextFieldAd" MaxLength="110" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Ürün Adı" BlankText="Lütfen ürün adını yazın." AnchorHorizontal="96%"
						IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" EnableKeyEvents="true">
						<Listeners>
							<KeyUp Handler="this.setValue(this.getValue().toUpperCase());" />
						</Listeners>
					</ext:TextField>
					<ext:ComboBox ID="Duzenle_ComboBoxResim" FieldLabel="Resim" AnchorHorizontal="100%"
						runat="server" DisplayField="ad" ValueField="id" Editable="true" TypeAhead="true"
						Mode="Local" ForceSelection="true" SelectOnFocus="true" EmptyText="Resim Seçiniz...">
						<Store>
							<ext:Store ID="StoreResim2" runat="server" WarningOnDirty="false">
								<Reader>
									<ext:JsonReader>
										<Fields>
											<ext:RecordField Name="id" Type="Int" />
											<ext:RecordField Name="ad" />
										</Fields>
									</ext:JsonReader>
								</Reader>
							</ext:Store>
						</Store>
						<Triggers>
							<ext:FieldTrigger Icon="Clear" Qtip="Seçimi Temizle" />
						</Triggers>
						<Listeners>
							<TriggerClick Handler="this.clearValue();" />
						</Listeners>
					</ext:ComboBox>
					<ext:DropDownField ID="Duzenle_DropDownFieldKategoriler" FieldLabel="Kategori" runat="server"
						Editable="false" TriggerIcon="SimpleArrowDown" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" EmptyText="Kategori Seçiniz...">
						<Component>
							<ext:TreePanel Shadow="None" ID="Duzenle_TreePanelKategoriler" runat="server" MinWidth="200" Title="Kategoriler"
								Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true" Animate="true"
								EnableDD="false" ContainerScroll="true" RootVisible="False" Selectable="true">
								<Root>
									<ext:AsyncTreeNode NodeID="0" Text="Kategoriler" Icon="ColorSwatch" Expanded="true" />
								</Root>
								<Listeners>
									<BeforeLoad Fn="Duzenle_NodeYukleKategoriler" />
								</Listeners>
								<BottomBar>
									<ext:Toolbar runat="server" ID="Duzenle_ToolbarKategoriler" StyleSpec="padding:5px">
										<Items>
											<ext:Button ID="Duzenle_ButtonKategorilerSec" runat="server" Icon="ArrowDivide" Text="Tümünü Seç"
												StandOut="true">
												<Listeners>
													<Click Handler="Duzenle_KategorilerNodeSec()" />
												</Listeners>
											</ext:Button>
											<ext:Button StyleSpec="margin-left:10px" ID="Duzenle_ButtonKategorilerTemizle" runat="server"
												Icon="ArrowOut" Text="Temizle" StandOut="true">
												<Listeners>
													<Click Handler="Duzenle_KategorilerNodeTemizle()" />
												</Listeners>
											</ext:Button>
										</Items>
									</ext:Toolbar>
								</BottomBar>
								<Listeners>
									<CheckChange Handler="this.dropDownField.setValue(Duzenle_KategorilerDuzenle(this), false)" />
								</Listeners>
							</ext:TreePanel>
						</Component>
					</ext:DropDownField>
					<ext:TextArea ID="Duzenle_TextAreaOnAciklama" MaxLength="500" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Ön Açıklama" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" MsgTarget="Side" AllowBlank="false"
						BlankText="Lütfen bir ön açıklama yazın" />
					<ext:Panel ID="Duzenle_PanelCollapsedAciklama" runat="server" Title="Açıklama (Detay) Bilgileri"
						FormGroup="true" Layout="FormLayout" Padding="5" StyleSpec="margin-top:5px;background:#fff;border:1px solid #C3DAF9"
						Collapsed="true" LabelSeparator=" : ">
						<Content>
							<ext:HtmlEditor ID="Duzenle_HtmlEditorAciklama" runat="server" FieldLabel="Açıklama"
								Height="150" AnchorHorizontal="100%" AnchorVertical="100%" />
						</Content>
					</ext:Panel>
					<ext:Panel ID="Duzenle_PanelCollapsedResimVideo" runat="server" Title="Resim Grup ve Video Grup Bilgileri"
						FormGroup="true" Layout="FormLayout" Padding="5" StyleSpec="margin-top:5px;margin-bottom:5px;background:#fff;border:1px solid #C3DAF9"
						Collapsed="true" LabelSeparator=" : ">
						<Content>
							<ext:Panel ID="Duzenle_PanelResim" runat="server" FormGroup="true" Layout="FormLayout"
								Padding="5" StyleSpec="border:1px solid #C3DAF9" LabelSeparator=" : ">
								<Content>
									<ext:Checkbox ID="Duzenle_ChecboxResimKategori" runat="server" FieldLabel="Res. Grup Değ.">
										<Listeners>
											<Check Fn="Duzenle_ResimKategoriDegistir" />
										</Listeners>
									</ext:Checkbox>
									<ext:Label ID="Duzenle_LabelResimKategori" runat="server" FieldLabel="Resim Grup" />
									<ext:DropDownField ID="Duzenle_DropDownFieldKategorilerResim" FieldLabel="Yeni Res. Grup"
										runat="server" Editable="false" TriggerIcon="SimpleArrowDown" AnchorHorizontal="100%"
										EmptyText="Resim grubu seçiniz..." Disabled="true">
										<Component>
											<ext:TreePanel Shadow="None" ID="Duzenle_TreePanelKategorilerResim" runat="server" MinWidth="200"
												Title="Resim Grupları" Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true"
												Animate="true" EnableDD="false" ContainerScroll="true" RootVisible="False" Selectable="true">
												<Root>
													<ext:AsyncTreeNode NodeID="0" Text="KategorilerResim" Icon="ColorSwatch" Expanded="true" />
												</Root>
												<Listeners>
													<BeforeLoad Fn="Duzenle_NodeYukleKategorilerResim" />
													<CheckChange Handler="if(this.lock){return;}if(checked){if(!this.checkedNode){this.checkedNode=node;}else{this.lock=true;this.checkedNode.ui.toggleCheck(false);this.lock=false;this.checkedNode=node;}}else{this.checkedNode=null;};this.dropDownField.setValue(Duzenle_KategorilerResimDuzenle(this), false)" />
												</Listeners>
											</ext:TreePanel>
										</Component>
									</ext:DropDownField>
								</Content>
							</ext:Panel>
							<ext:Panel ID="Duzenle_PanelVideo" runat="server" FormGroup="true" Layout="FormLayout"
								Padding="5" StyleSpec="margin-top:5px;border:1px solid #C3DAF9" LabelSeparator=" : ">
								<Content>
									<ext:Checkbox ID="Duzenle_ChecboxVideoKategori" runat="server" FieldLabel="Vid. Grup Değ.">
										<Listeners>
											<Check Fn="Duzenle_VideoKategoriDegistir" />
										</Listeners>
									</ext:Checkbox>
									<ext:Label ID="Duzenle_LabelVideoKategori" runat="server" FieldLabel="Video Grup" />
									<ext:DropDownField ID="Duzenle_DropDownFieldKategorilerVideo" FieldLabel="Yeni Vid. Grup"
										runat="server" Editable="false" TriggerIcon="SimpleArrowDown" AnchorHorizontal="100%"
										EmptyText="Video grubu seçiniz..." Disabled="true">
										<Component>
											<ext:TreePanel Shadow="None" ID="Duzenle_TreePanelKategorilerVideo" runat="server" MinWidth="200"
												Title="Video Grupları" Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true"
												Animate="true" EnableDD="false" ContainerScroll="true" RootVisible="False" Selectable="true">
												<Root>
													<ext:AsyncTreeNode NodeID="0" Text="KategorilerVideo" Icon="ColorSwatch" Expanded="true" />
												</Root>
												<Listeners>
													<BeforeLoad Fn="Duzenle_NodeYukleKategorilerVideo" />
													<CheckChange Handler="if(this.lock){return;}if(checked){if(!this.checkedNode){this.checkedNode=node;}else{this.lock=true;this.checkedNode.ui.toggleCheck(false);this.lock=false;this.checkedNode=node;}}else{this.checkedNode=null;};this.dropDownField.setValue(Duzenle_KategorilerVideoDuzenle(this), false)" />
												</Listeners>
											</ext:TreePanel>
										</Component>
									</ext:DropDownField>
								</Content>
							</ext:Panel>
						</Content>
					</ext:Panel>
					<ext:TextField ID="Duzenle_TextFieldEtiketler" runat="server" FieldLabel="Etiket(ler)"
						AnchorHorizontal="100%" EnableKeyEvents="true">
						<Listeners>
							<KeyUp Handler="this.setValue(this.getValue().toLowerCase());" />
						</Listeners>
					</ext:TextField>
					<ext:ComboBox ID="Duzenle_ComboBoxAnasayfa" runat="server" FieldLabel="Anasayfa"
						Editable="false" Selectable="true">
						<Items>
							<ext:ListItem Text="EVET" Value="1" />
							<ext:ListItem Text="HAYIR" Value="0" />
						</Items>
					</ext:ComboBox>
					<ext:ComboBox ID="Duzenle_ComboBoxOnay" runat="server" FieldLabel="Onay" Editable="false"
						Selectable="true">
						<Items>
							<ext:ListItem Text="EVET" Value="1" />
							<ext:ListItem Text="HAYIR" Value="0" />
						</Items>
					</ext:ComboBox>
				</Items>
				<Buttons>
					<ext:Button ID="Duzenle_Kaydet" runat="server" Text="Güncelle" Icon="Accept">
						<Listeners>
							<Click Fn="DuzenleKontrol" />
						</Listeners>
						<DirectEvents>
							<Click OnEvent="GuncellemeYap">
								<EventMask ShowMask="true" Msg="Güncelleniyor..." MinDelay="500" />
							</Click>
						</DirectEvents>
					</ext:Button>
				</Buttons>
				<Listeners>
					<Hide Handler="WindowDuzenleClear()" />
				</Listeners>
			</ext:Window>
			<ext:Window ID="WindowResimYukle" runat="server" Modal="true" Resizable="True" Height="500"
				Icon="Attach" Title="Dosya Yükle" Width="640" Padding="5" Layout="FormLayout"
				ButtonAlign="Center" Shadow="Frame" LabelSeparator=" : " Draggable="true" AutoFocus="True"
				AutoHeight="True" Hidden="true">
				<Items>
					<ext:FileUploadField ID="gonderilecek_dosya" runat="server" AnchorHorizontal="90%"
						Icon="Attach" runat="server" MsgTarget="Side" AllowBlank="false" BlankText="Lütfen bir dosya seçiniz."
						FieldLabel="Dosya" />
				</Items>
				<Buttons>
					<ext:Button ID="Button6" runat="server" Text="Gönder" Icon="Accept" Type="Submit">
						<Listeners>
							<Click Fn="DosyaGonder" />
						</Listeners>
						<DirectEvents>
							<Click OnEvent="DosyaGonderClick">
								<EventMask ShowMask="true" Msg="Dosya yükleniyor..." MinDelay="500" />
							</Click>
						</DirectEvents>
					</ext:Button>
				</Buttons>
			</ext:Window>
		</Items>
	</ext:Viewport>
	</form>
</body>
</html>
