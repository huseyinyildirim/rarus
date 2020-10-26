<%@ Page Language="C#" AutoEventWireup="true" CodeFile="resimler-videolar.aspx.cs" Inherits="yonetim_Kullanici"
	EnableViewState="False" ViewStateMode="Disabled" EnableEventValidation="False" ValidateRequest="false" %>

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

		Ext.data.Connection.override({
			timeout: 300000
		});

		Ext.Ajax.timeout = 300000;

		var ExportYap = function () {
			Ext.net.Mask.show();
			Ext.net.Mask.hide.defer(500);
		};

		var DosyaURL = function (data) {
			if (data != null) {
				return String.format("<a href=\"" + data + "\" target=\"_blank\">" + data + "</a>");
			}
		};

		var DosyaGonder = function () {
			if (!gonderilecek_dosya.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir dosya seçiniz.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

		var Ekle_TipKontrol = function () {
			switch (Ekle_ComboBoxTip.getSelectedItem().value) {
				case "1":
					Ekle_TextFieldAdi.setDisabled(false);
					Ekle_ComboBoxResim.setDisabled(true);
					Ekle_TextFieldUrl.setDisabled(false);
					break;

				case "0":
					Ekle_TextFieldAdi.setDisabled(true);
					Ekle_ComboBoxResim.setDisabled(false);
					Ekle_TextFieldUrl.setDisabled(true);
					break;
			}

			Ekle_KategorilerNodeTemizle();
			Ekle_DropDownFieldKategoriler.clear();
			Ext.net.DirectMethods.Ekle_KategoriDegistir();
		}

		var Duzenle_TipKontrol = function () {
			switch (Duzenle_Tip.getValue()) {
				case "1":
					Duzenle_TextFieldResim.setVisible(false);
					Duzenle_TextFieldAdi.setVisible(true);
					Duzenle_TextFieldUrl.setVisible(true);
					Duzenle_TextFieldAdi.setDisabled(false);
					Duzenle_TextFieldUrl.setDisabled(false);
					break;

				case "0":
					Duzenle_TextFieldResim.setVisible(true);
					Duzenle_TextFieldAdi.setVisible(false);
					Duzenle_TextFieldUrl.setVisible(false);
					Duzenle_TextFieldAdi.setDisabled(true);
					Duzenle_TextFieldUrl.setDisabled(true);
					break;
			}

			Ext.net.DirectMethods.Duzenle_KategoriDegistir();
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

		var DugmelerinDurumu2 = function (grid, toolbar, rowIndex, record) {
			switch (record.data.tip) {
				case "VIDEO":
					toolbar.items.itemAt(0).hide();
					toolbar.add(new Ext.Button({
						iconCls: "icon-film",
						command: "Goster",
						tooltip: "Videoyu izlemek için tıklayın."
					}));
					toolbar.doLayout();
					break;

				case "RESIM":
					toolbar.items.get(0).setTooltip("Resmi görmek için tıklayın.");
					break;
			}
		};

		var WindowEkleClear = function () {
			for (var i = 0; i <= WindowEkle.items.items.length; i++) {
				if (WindowEkle.items.items[i].xtype == "textfield" || WindowEkle.items.items[i].xtype == "textarea") {
					WindowEkle.items.items[i].clear();
				}
				else if (WindowEkle.items.items[i].xtype == "combo") {
					if (WindowEkle.items.items[i].id == "Ekle_ComboBoxOnay" || WindowEkle.items.items[i].id == "Ekle_ComboBoxTip") {
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
					if (WindowDuzenle.items.items[i].id == "Duzenle_ComboBoxOnay" || WindowDuzenle.items.items[i].id == "Duzenle_ComboBoxTip") {
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
			if (Duzenle_DropDownFieldKategoriler.getValue() == "Grup Seçiniz..." || Duzenle_DropDownFieldKategoriler.getValue() == "[]" || Duzenle_DropDownFieldKategoriler.getValue() == "") {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir grup seçin.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
			else if (Duzenle_Tip.getValue() == "1") {
				if (Duzenle_TextFieldAdi.getValue() == "") {
					Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir video adı yazın.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
					return false;
				}
				else if (Duzenle_TextFieldUrl.getValue() == "") {
					Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir URL yazın.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
					return false;
				}
			}
		}

		var KaydetKontrol = function () {
			if (Ekle_DropDownFieldKategoriler.getValue() == "Grup Seçiniz..." || Ekle_DropDownFieldKategoriler.getValue() == "[]" || Ekle_DropDownFieldKategoriler.getValue() == "") {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir grup seçin.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
			else if (Ekle_ComboBoxTip.getSelectedItem().value == "1") {
				if (Ekle_TextFieldAdi.getValue() == "") {
					Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir video adı yazın.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
					return false;
				}
				else if (Ekle_TextFieldUrl.getValue() == "") {
					Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir URL yazın.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
					return false;
				}
			}
			else if (Ekle_ComboBoxTip.getSelectedItem().value == "0") {
				if (Ekle_ComboBoxResim.getSelectedIndex() == -1) {
					Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir resim seçin.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
					return false;
				}
			}
		}

		var GridKomutlari = function (cmd, record) {
			var furl = null;
			var ficon = null;

			switch (cmd) {

				case "Goster":

					switch (record.data.tip) {
						case "RESIM":
							furl = '../images/product/' + record.data.ad;
							ficon = "icon-picture";
							break;

						case "VIDEO":
							furl = record.data.url;
							ficon = "icon-film";
							break;
					}

					var win = new Ext.Window({
						id: 'WindowY' + record.data.id,
						iconCls: ficon,
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
							url: furl,
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

				case "IslemKaydi":

					var win2 = new Ext.Window({
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
							url: "isleme-ait-kayitlar.aspx?tablo_adi=tbl_dosyalar&kayit_id=" + record.data.id,
							scripts: true
						},
						buttonAlign: 'right',
						buttons: [
			{
				iconCls: "icon-cancel",
				text: 'KAPAT',
				handler: function () {
					win2.close();
				}
			}
		]
					});

					win2.show();

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

		function Ekle_KategorilerYukle(node) {
			Ext.net.DirectMethods.Ekle_NodeYukle(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

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

		var Duzenle_KategorilerEkle = function (tree) {
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

		function Duzenle_KategorilerYukle(node) {
			Ext.net.DirectMethods.Duzenle_NodeYukle(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

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
	</script>
	<form id="form1" runat="server">
	<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Gray" Locale="tr-TR"
		GZip="true" />
	<ext:Viewport ID="Viewport1" runat="server" Layout="FitLayout" StyleSpec="background-color:#F0F0F0">
		<Items>
			<ext:Window ID="Window1" runat="server" Maximized="true" Title="Resimler/Videolar" Layout="FitLayout"
				Icon="PageWhitePicture" Closable="false" Minimizable="false" MinHeight="480"
				MinWidth="640">
				<Items>
					<ext:GridPanel ID="GridPanel1" runat="server" ColumnLines="true" SortType="AsUCString" AutoExpandColumn="url"
						OnBeforeClientInit="GridPanelYuklenmedenOnce" AnchorHorizontal="100%" Region="Center" AutoScroll="true" MonitorResize="true" TrackMouseOver="true">
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
											<ext:RecordField Name="ad" />
											<ext:RecordField Name="tip" />
											<ext:RecordField Name="url" />
											<ext:RecordField Name="kategoriler" />
											<ext:RecordField Name="aciklama" />
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
								<ext:Column DataIndex="ad" Header="Adı" />
								<ext:Column DataIndex="tip" Header="Tipi" Width="50" />
								<ext:Column DataIndex="url" Header="URL">
								<Renderer Fn="DosyaURL" />
								</ext:Column>
								<ext:Column DataIndex="kategoriler" Header="Grup(lar)" Sortable="false" />
								<ext:Column DataIndex="aciklama" Header="Açıklama" Hidden="true" />
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
									<PrepareToolbar Fn="DugmelerinDurumu2" />
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
									<ext:StringFilter DataIndex="adi" />
									<ext:ListFilter DataIndex="tip" Options="RESIM,VIDEO" />
									<ext:StringFilter DataIndex="url" />
									<ext:StringFilter DataIndex="aciklama" />
									<ext:StringFilter DataIndex="ekleyen" />
									<ext:StringFilter DataIndex="guncelleyen" />
									<ext:DateFilter DataIndex="tarih_ek">
										<DatePickerOptions runat="server" TodayText="Now" />
									</ext:DateFilter>
									<ext:DateFilter DataIndex="tarih_gun">
										<DatePickerOptions runat="server" TodayText="Now" />
									</ext:DateFilter>
									<ext:ListFilter DataIndex="onay" Options="EVET,HAYIR" />
								</Filters>
							</ext:GridFilters>
						</Plugins>
						<SelectionModel>
							<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server" />
						</SelectionModel>
						<Buttons>
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
				Shadow="Frame" LabelSeparator=" : " Draggable="True" AutoFocus="True" AutoHeight="True"
				Hidden="true">
				<Items>
					<ext:ComboBox ID="Ekle_ComboBoxTip" runat="server" FieldLabel="Tipi" Editable="false"
						Selectable="true">
						<Items>
							<ext:ListItem Text="RESİM" Value="0" />
							<ext:ListItem Text="VİDEO" Value="1" />
						</Items>
						<SelectedItem Value="0" />
						<Listeners>
							<Select Fn="Ekle_TipKontrol" />
						</Listeners>
					</ext:ComboBox>
					<ext:ComboBox ID="Ekle_ComboBoxResim" FieldLabel="Resim" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan"
						runat="server" DisplayField="resim" ValueField="resim" Editable="true" TypeAhead="true"
						Mode="Local" ForceSelection="true" SelectOnFocus="true" EmptyText="Resim Seçiniz...">
						<Store>
							<ext:Store ID="StoreResimler1" runat="server" WarningOnDirty="false">
								<Reader>
									<ext:JsonReader>
										<Fields>
											<ext:RecordField Name="resim" />
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
					<ext:TextField ID="Ekle_TextFieldAdi" MaxLength="255" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Video Adı" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
					<ext:TextField ID="Ekle_TextFieldUrl" MaxLength="600" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="URL" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
					<ext:DropDownField ID="Ekle_DropDownFieldKategoriler" FieldLabel="Grup" runat="server"
						Editable="false" TriggerIcon="SimpleArrowDown" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" EmptyText="Grup Seçiniz...">
						<Component>
							<ext:TreePanel Shadow="None" ID="Ekle_TreePanelKategoriler" runat="server" MinWidth="200" Title="Resim Grupları"
								Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true" Animate="true"
								EnableDD="false" ContainerScroll="true" RootVisible="False" Selectable="true">
								<Root>
									<ext:AsyncTreeNode NodeID="0" Text="Kategoriler" Icon="ColorSwatch" Expanded="true" />
								</Root>
								<Listeners>
									<BeforeLoad Fn="Ekle_KategorilerYukle" />
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
					<ext:TextArea ID="Ekle_TextAreaAciklama" MaxLength="500" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Açıklama" AnchorHorizontal="100%" />
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
					<Show Fn="Ekle_TipKontrol" />
				</Listeners>
			</ext:Window>
			<ext:Window ID="WindowDuzenle" runat="server" Modal="true" Resizable="True" Height="500"
				Icon="NoteEdit" Title="Düzenle" Width="640" Padding="5" Layout="FormLayout" ButtonAlign="Center"
				Shadow="None" LabelSeparator=" : " Draggable="True" AutoFocus="True" AutoHeight="True"
				Hidden="true">
				<Items>
					<ext:TextField ID="Duzenle_ID" Hidden="true" runat="server" />
					<ext:TextField ID="Duzenle_Tip" Hidden="true" runat="server" />
					<ext:TextField ID="Duzenle_TextFieldResim" runat="server" FieldLabel="Resim" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" Disabled="true" />
					<ext:TextField ID="Duzenle_TextFieldAdi" MaxLength="255" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Video Adı" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" MsgTarget="Side" AllowBlank="false" BlankText="Lütfen video adını yazın" />
					<ext:TextField ID="Duzenle_TextFieldUrl" MaxLength="600" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="URL" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" MsgTarget="Side" AllowBlank="false" BlankText="Lütfen URL yi yazın" />
					<ext:DropDownField ID="Duzenle_DropDownFieldKategoriler" FieldLabel="Grup" runat="server"
						Editable="false" TriggerIcon="SimpleArrowDown" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" EmptyText="Grup Seçiniz...">
						<Component>
							<ext:TreePanel Shadow="None" ID="Duzenle_TreePanelKategoriler" runat="server" MinWidth="200" Title="Resim Grupları"
								Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true" Animate="true"
								EnableDD="false" ContainerScroll="true" RootVisible="False" Selectable="true">
								<Root>
									<ext:AsyncTreeNode NodeID="0" Text="Kategoriler" Icon="ColorSwatch" Expanded="true" />
								</Root>
								<Listeners>
									<BeforeLoad Fn="Duzenle_KategorilerYukle" />
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
									<CheckChange Handler="this.dropDownField.setValue(Duzenle_KategorilerEkle(this), false)" />
								</Listeners>
							</ext:TreePanel>
						</Component>
					</ext:DropDownField>
					<ext:TextArea ID="Duzenle_TextAreaAciklama" MaxLength="500" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Açıklama" AnchorHorizontal="100%" />
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
					<Show Fn="Duzenle_TipKontrol" />
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
