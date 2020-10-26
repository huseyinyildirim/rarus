<%@ Page Language="C#" AutoEventWireup="true" CodeFile="urun-kategorileri.aspx.cs" Inherits="yonetim_Kullanici"
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
	<style type="text/css">
		.complete .x-tree-node-anchor span {
			text-decoration : line-through;
			color : #777;
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
		var OnayTemplate = '<span style="color:{0};font-weight:{1}">{2}</span>';

		var OnayRenk = function (v) {
			return String.format(OnayTemplate, (v == "HAYIR") ? "red" : "black", (v == "HAYIR") ? "bold" : "normal", v);
		};

		var AnaGrupTemplate = '<span style="color:{0};font-weight:{1}">{2}</span>';

		var AnaGrupRenk = function (v) {
			return String.format(AnaGrupTemplate, (v == "EVET") ? "red" : "black", (v == "EVET") ? "bold" : "normal", v);
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
		};

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

		var WindowSiralamaClear = function () {
			for (var i = 0; i <= WindowSiralama.items.items.length; i++) {
				if (WindowSiralama.items.items[i].xtype == "textfield") {
					WindowSiralama.items.items[i].clear();
				}
			}
		}

		var DuzenleKontrol = function () {
			if (Duzenle_ComboBoxDil.getSelectedIndex() == -1) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir dil seçin.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
			else if (!Duzenle_TextFieldKategori.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen zorunlu tüm alanları doldurun.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

		var KaydetKontrol = function () {
			if (Ekle_ComboBoxDil.getSelectedIndex() == -1) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen bir dil seçin.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
			else if (!Ekle_TextFieldKategori.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen zorunlu tüm alanları doldurun.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

		var DilDegistir = function () {
			Ext.net.DirectMethods.DilDegistir();
		}

		var GridKomutlari = function (cmd, record) {
			switch (cmd) {

				case "Siralama":
					Ext.net.DirectMethods.SiralamaEkraniGetir(record.data.id);
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
							url: "isleme-ait-kayitlar.aspx?tablo_adi=tbl_kategoriler&kayit_id=" + record.data.id,
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

		function NodeYukle(node) {
			Ext.net.DirectMethods.NodeYukle(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

		var NodeSurukle = function (tree, node, oldParent, newParent, index) {
			Ext.net.DirectMethods.NodeSurukle(node.id, newParent.id, {
				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}
	</script>
	<form id="form1" runat="server">
	<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Gray" Locale="tr-TR"
		GZip="true" />
	<ext:Viewport ID="Viewport1" runat="server" Layout="FitLayout" StyleSpec="background-color:#F0F0F0">
		<Items>
			<ext:Window ID="Window1" runat="server" Maximized="true" Title="Ürün Kategorileri"
				Layout="FitLayout" Icon="PackageLink" Closable="false" Minimizable="false" MinHeight="480"
				MinWidth="640">
				<Items>
					<ext:BorderLayout ID="BorderLayout1" runat="server">
						<West Collapsible="true" MinWidth="200" Split="true">
							<ext:TreePanel Shadow="None" ID="TreePanel1" runat="server" Width="200" MinWidth="200" Title="Kategoriler"
								Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true" Animate="true"
								EnableDD="true" ActiveEditor="TreePanelEditor" ContainerScroll="true" RootVisible="False"
								Selectable="true">
								<Root>
									<ext:AsyncTreeNode NodeID="0" Text="Kategoriler" Icon="ColorSwatch" Expanded="true" />
								</Root>
								<Listeners>
									<BeforeLoad Fn="NodeYukle" />
									<MoveNode Fn="NodeSurukle" />
									<CheckChange Handler="node.getUI()[checked ? 'addClass' : 'removeClass']('complete')" />
								</Listeners>
								<Editors>
									<ext:TreeEditor ID="TreePanelEditor" runat="server" Shadow="None">
										<Field>
											<ext:TextField ID="TreePanelTextField" runat="server" />
										</Field>
										<Alignment TargetAnchor="BottomLeft" ElementAnchor="TopLeft" />
										<DirectEvents>
											<Complete OnEvent="NodeDegistir">
												<ExtraParams>
													<ext:Parameter Name="value" Value="value" Mode="Raw" />
													<ext:Parameter Name="id" Value="#{TreePanel1}.getSelectedNodes().nodeID" Mode="Raw" />
												</ExtraParams>
											</Complete>
										</DirectEvents>
									</ext:TreeEditor>
								</Editors>
								<BottomBar>
									<ext:Toolbar ID="TreePanelToolBar" runat="server">
										<Items>
											<ext:Button ID="TreePanelButton" runat="server" Text="Seçilen Kategorileri Sil" Icon="Delete"
												StandOut="true">
												<DirectEvents>
													<Click OnEvent="NodeSil">
														<Confirmation ConfirmRequest="true" Message="İşlemi onaylıyor musunuz?" Title="Onay" />
														<EventMask ShowMask="true" MinDelay="500" Msg="Seçilen kategoriler siliniyor..." />
													</Click>
												</DirectEvents>
											</ext:Button>
										</Items>
									</ext:Toolbar>
								</BottomBar>
							</ext:TreePanel>
						</West>
						<Center>
							<ext:GridPanel ID="GridPanel1" runat="server" ColumnLines="true" SortType="AsUCString" AutoExpandColumn="ad"
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
													<ext:RecordField Name="dil_id" Type="Int" />
													<ext:RecordField Name="dil" />
													<ext:RecordField Name="kategori_tip" />
													<ext:RecordField Name="kategori_id" />
													<ext:RecordField Name="ad" />
													<ext:RecordField Name="ust_kategori" />
													<ext:RecordField Name="ziyaret" />
													<ext:RecordField Name="sira" />
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
								<ColumnModel ID="ColumnModel1" runat="server">
									<Columns>
										<ext:RowNumbererColumn MenuDisabled="true" ColumnID="check" Resizable="false" Editable="false"
											Width="55" />
										<ext:Column DataIndex="id" Header="ID" />
										<ext:Column DataIndex="dil_id" Header="Dil ID" Hidden="true" />
										<ext:Column DataIndex="dil" Header="Dil" MenuDisabled="true" Sortable="false" />
										<ext:Column DataIndex="kategori_tip" Header="Ana Kategori">
										<Renderer Fn="AnaGrupRenk" />
										</ext:Column>
										<ext:Column DataIndex="kategori_id" Header="Üst Kategori ID" Hidden="true" />
										<ext:Column DataIndex="ad" Header="Kategori" />
										<ext:Column DataIndex="ust_kategori" Header="Üst Kategori" MenuDisabled="true" Sortable="false" />
										<ext:Column DataIndex="ziyaret" Header="Ziyaret" MenuDisabled="true" Sortable="false" Width="55" />
										<ext:Column DataIndex="sira" Header="Sıra" Width="40" />
										<ext:Column DataIndex="ekleyen" Header="Ekleyen" />
										<ext:DateColumn DataIndex="tarih_ek" Header="Kayıt Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
											Width="125" />
										<ext:Column DataIndex="guncelleyen" Header="Güncelleyen" />
										<ext:DateColumn DataIndex="tarih_gun" Header="Güncelleme Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
											Width="125" />
										<ext:Column DataIndex="onay" Header="Onay" Align="Center" Width="60">
											<Renderer Fn="OnayRenk" />
										</ext:Column>
										<ext:CommandColumn Header="Sıra" Align="Center" Width="35" MenuDisabled="true" Resizable="false"
											ButtonAlign="Center">
											<Commands>
												<ext:GridCommand Icon="Outline" CommandName="Siralama">
													<ToolTip Text="Seçilen kaydın sırasını ayarla." />
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
											<ext:StringFilter DataIndex="kategori" />
											<ext:StringFilter DataIndex="sira" />
											<ext:NumericFilter DataIndex="kategori_id" />
											<ext:StringFilter DataIndex="ust_kategori" />
											<ext:StringFilter DataIndex="ekleyen" />
											<ext:StringFilter DataIndex="guncelleyen" />
											<ext:DateFilter DataIndex="tarih_ek">
												<DatePickerOptions runat="server" TodayText="Now" />
											</ext:DateFilter>
											<ext:DateFilter DataIndex="tarih_gun">
												<DatePickerOptions runat="server" TodayText="Now" />
											</ext:DateFilter>
											<ext:ListFilter DataIndex="onay" Options="EVET,HAYIR" />
											<ext:ListFilter DataIndex="kategori_tip" Options="EVET,HAYIR" />
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
						</Center>
					</ext:BorderLayout>
				</Items>
			</ext:Window>
			<ext:Window ID="WindowEkle" runat="server" Modal="false" Resizable="True" Height="500"
				Icon="Add" Title="Ekle" Width="640" Padding="5" Layout="FormLayout" ButtonAlign="Center"
				Shadow="Frame" LabelSeparator=" : " Draggable="True" AutoFocus="True" AutoHeight="True"
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
					</ext:ComboBox>
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Ekle_TextFieldKategori" MaxLength="255" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Kategori" BlankText="Lütfen kategori adını yazın."
						AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
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
					</ext:ComboBox>
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Duzenle_TextFieldKategori" MaxLength="255" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Kategori" BlankText="Lütfen kategori adını yazın."
						AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
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
			<ext:Window ID="WindowSiralama" runat="server" Modal="true" Resizable="True" Height="500"
				Icon="NoteEdit" Title="Sıralamayı Düzenle" Width="640" Padding="5" Layout="FormLayout"
				ButtonAlign="Center" Shadow="Frame" LabelSeparator=" : " Draggable="True" AutoFocus="True"
				AutoHeight="True" Hidden="true">
				<Items>
					<ext:TextField ID="Duzenle_DilID" Hidden="true" runat="server" />
					<ext:TextField ID="Duzenle_ID2" Hidden="true" runat="server" />
					<ext:TextField ID="Duzenle_Sira" MaskRe="[0-9]" MaxLength="9" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Sıra" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
				</Items>
				<Buttons>
					<ext:Button ID="Button5" runat="server" Text="Güncelle" Icon="Accept" Type="Submit">
						<DirectEvents>
							<Click OnEvent="SiralamaGuncelle">
								<EventMask ShowMask="true" Msg="Güncelleniyor..." MinDelay="500" />
							</Click>
						</DirectEvents>
					</ext:Button>
				</Buttons>
				<Listeners>
					<Hide Handler="WindowSiralamaClear()" />
				</Listeners>
			</ext:Window>
		</Items>
	</ext:Viewport>
	</form>
</body>
</html>
