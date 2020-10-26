<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yoneticiler.aspx.cs" Inherits="yonetim_Kullanici"
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

		var RootTemplate = '<span style="color:{0}">{1}</span>';

		var RootRenk = function (v) {
			return String.format(RootTemplate, (v == "EVET") ? "red" : "blue", v);
		};

		Ext.data.Connection.override({
			timeout: 300000
		});

		Ext.Ajax.timeout = 300000;

		var ExportYap = function () {
			Ext.net.Mask.show();
			Ext.net.Mask.hide.defer(500);
		};

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

			if (!Boolean(AdminRoot())) {
				switch (record.data.root) {
					case "EVET":
						toolbar.items.get(2).setDisabled(true);
						toolbar.items.get(2).setTooltip("Root Yönetici üzerinde işlem yapamazsınız.");

						toolbar.items.get(4).setDisabled(true);
						toolbar.items.get(4).setTooltip("Root Yönetici üzerinde işlem yapamazsınız.");

						toolbar.items.get(6).setDisabled(true);
						toolbar.items.get(6).setTooltip("Root Yönetici üzerinde işlem yapamazsınız.");
						break;
				}
			}
		};

		var SifreDegistir = function () {
			if (Duzenle_Checbox.getValue()) {
				Duzenle_TextFieldSifre.setDisabled(false);
				Duzenle_TextFieldSifre.AllowBlank(true);
			}
			else {
				Duzenle_TextFieldSifre.setDisabled(true);
				Duzenle_TextFieldSifre.AllowBlank(false);
			}
		}

		var WindowEkleClear = function () {
			for (var i = 0; i <= WindowEkle.items.items.length; i++) {
				if (WindowEkle.items.items[i].xtype == "textfield") {
					WindowEkle.items.items[i].clear();
				}
				else if (WindowEkle.items.items[i].xtype == "combo") {
					if (WindowEkle.items.items[i].id == "Ekle_ComboBoxOnay") {
						WindowEkle.items.items[i].selectByIndex(0);
					}
					else {
						WindowEkle.items.items[i].clear();
					}
				}
			}
		}

		var WindowDuzenleClear = function () {
			for (var i = 0; i <= WindowDuzenle.items.items.length; i++) {
				if (WindowDuzenle.items.items[i].xtype == "textfield") {
					WindowDuzenle.items.items[i].clear();
				}
				else if (WindowDuzenle.items.items[i].xtype == "combo") {
					WindowDuzenle.items.items[i].clear();
				}
			}
		}

		var DuzenleKontrol = function () {
			if (!Duzenle_TextFieldAdiSoyadi.validate() || !Duzenle_TextFieldKullaniciAdi.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen zorunlu tüm alanları doldurun.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}

			if (Duzenle_Checbox.getValue()) {
				if (Duzenle_TextFieldSifre.getValue() == "") {
					Ext.Msg.show({ title: 'Hata', msg: 'Lütfen yeni şifreyi belirtin.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
					Ext.get("Duzenle_TextFieldSifre").focus();
					return false;
				}
			}
		}

		var KaydetKontrol = function () {
			if (!Ekle_TextFieldAdiSoyadi.validate() || !Ekle_TextFieldKullaniciAdi.validate() || !Ekle_TextFieldSifre.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen zorunlu tüm alanları doldurun.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

		var GridKomutlari = function (cmd, record) {
			switch (cmd) {

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
							url: "isleme-ait-kayitlar.aspx?tablo_adi=tbl_adminler&kayit_id=" + record.data.id,
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
	</script>
	<form id="form1" runat="server">
	<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Gray" Locale="tr-TR"
		GZip="true" />
	<ext:Viewport ID="Viewport1" runat="server" Layout="FitLayout" StyleSpec="background-color:#F0F0F0">
		<Items>
			<ext:Window ID="Window1" runat="server" Maximized="true" Title="Yöneticiler" Layout="FitLayout"
				Icon="Group" Closable="false" Minimizable="false" MinHeight="480" MinWidth="640">
				<Items>
					<ext:GridPanel ID="GridPanel1" runat="server" ColumnLines="true" SortType="AsUCString" AutoExpandColumn="ad_soyad"
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
											<ext:RecordField Name="ad_soyad" />
											<ext:RecordField Name="kullanici_adi" />
											<ext:RecordField Name="ekleyen" />
											<ext:RecordField Name="tarih_ek" Type="Date" />
											<ext:RecordField Name="guncelleyen" />
											<ext:RecordField Name="tarih_gun" Type="Date" />
											<ext:RecordField Name="onay" />
											<ext:RecordField Name="root" />
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
								<ext:Column DataIndex="ad_soyad" Header="Adı Soyadı" />
								<ext:Column DataIndex="kullanici_adi" Header="Kullanıcı Adı" />
								<ext:Column DataIndex="ekleyen" Header="Ekleyen" />
								<ext:DateColumn DataIndex="tarih_ek" Header="Kayıt Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
									Width="125" />
								<ext:Column DataIndex="guncelleyen" Header="Güncelleyen" />
								<ext:DateColumn DataIndex="tarih_gun" Header="Güncelleme Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
									Width="125" />
								<ext:Column DataIndex="onay" Header="Onay" Align="Center" Width="60">
									<Renderer Fn="OnayRenk" />
								</ext:Column>
								<ext:Column DataIndex="root" Header="Root" Align="Center" Width="60" Hidden="true">
									<Renderer Fn="RootRenk" />
								</ext:Column>
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
									<ext:StringFilter DataIndex="ad_soyad" />
									<ext:StringFilter DataIndex="kullanici_adi" />
									<ext:StringFilter DataIndex="ekleyen" />
									<ext:StringFilter DataIndex="guncelleyen" />
									<ext:DateFilter DataIndex="tarih_ek">
										<DatePickerOptions runat="server" TodayText="Now" />
									</ext:DateFilter>
									<ext:DateFilter DataIndex="tarih_gun">
										<DatePickerOptions runat="server" TodayText="Now" />
									</ext:DateFilter>
									<ext:ListFilter DataIndex="onay" Options="EVET,HAYIR" />
									<ext:ListFilter DataIndex="root" Options="EVET,HAYIR" />
								</Filters>
							</ext:GridFilters>
						</Plugins>
						<SelectionModel>
							<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server" />
						</SelectionModel>
						<Buttons>
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
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Ekle_TextFieldAdiSoyadi" MaxLength="150" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Adı Soyadı" BlankText="Lütfen kullanıcı adını ve soyadını yazın."
						AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Ekle_TextFieldKullaniciAdi" MaxLength="150" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Kullanıcı Adı" BlankText="Lütfen kullanıcı adını yazın."
						AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Ekle_TextFieldSifre" runat="server" FieldLabel="Şifre"
						BlankText="Lütfen bir şifre belirtin." AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" InputType="Password" />
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
				</Listeners>
			</ext:Window>
			<ext:Window ID="WindowDuzenle" runat="server" Modal="true" Resizable="True" Height="500"
				Icon="NoteEdit" Title="Düzenle" Width="640" Padding="5" Layout="FormLayout" ButtonAlign="Center"
				Shadow="Frame" LabelSeparator=" : " Draggable="True" AutoFocus="True" AutoHeight="True"
				Hidden="true">
				<Items>
					<ext:TextField ID="Duzenle_ID" Hidden="true" runat="server" />
					<ext:TextField ID="Duzenle_EskiKullaniciAdi" Hidden="true" runat="server" />
					<ext:Panel ID="Panel1" runat="server" Layout="FormLayout" Padding="5" LabelSeparator=" : ">
						<Content>
							<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Duzenle_TextFieldAdiSoyadi" MaxLength="150" MaxLengthText="Maksimum karakter sınırını aştınız."
								runat="server" FieldLabel="Adı Soyadı" BlankText="Lütfen kullanıcı adını ve soyadını yazınız."
								AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
							<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Duzenle_TextFieldKullaniciAdi" MaxLength="150" MaxLengthText="Maksimum karakter sınırını aştınız."
								runat="server" FieldLabel="Kullanıcı Adı" BlankText="Lütfen kullanıcı adını yazınız."
								AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
						</Content>
					</ext:Panel>
					<ext:Panel ID="Panel2" runat="server" Layout="FormLayout" Padding="5" StyleSpec="margin-top:5px" LabelSeparator=" : ">
						<Content>
							<ext:Checkbox ID="Duzenle_Checbox" runat="server" FieldLabel="Şifre Değiştir">
								<Listeners>
									<Check Fn="SifreDegistir" />
								</Listeners>
							</ext:Checkbox>
							<ext:TextField ID="Duzenle_TextFieldSifre" runat="server" FieldLabel="Şifre" BlankText="Lütfen bir şifre belirtin."
								AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" InputType="Password" Disabled="true" />
						</Content>
					</ext:Panel>
					<ext:Panel ID="Panel3" runat="server" Layout="FormLayout" Padding="5" StyleSpec="margin-top:5px" LabelSeparator=" : ">
						<Content>
							<ext:ComboBox ID="Duzenle_ComboBoxOnay" runat="server" FieldLabel="Onay" Editable="false"
								Selectable="true">
								<Items>
									<ext:ListItem Text="EVET" Value="1" />
									<ext:ListItem Text="HAYIR" Value="0" />
								</Items>
							</ext:ComboBox>
						</Content>
					</ext:Panel>
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
		</Items>
	</ext:Viewport>
	</form>
</body>
</html>
