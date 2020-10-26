<%@ Page Language="C#" AutoEventWireup="true" CodeFile="resim-gruplari.aspx.cs"
	Inherits="yonetim_Kullanici" EnableViewState="False" ViewStateMode="Disabled"
	EnableEventValidation="False" ValidateRequest="false" %>

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

		var WindowEkleClear = function () {
			for (var i = 0; i <= WindowEkle.items.items.length; i++) {
				if (WindowEkle.items.items[i].xtype == "textfield") {
					WindowEkle.items.items[i].clear();
				}
			}
		}

		var WindowDuzenleClear = function () {
			for (var i = 0; i <= WindowDuzenle.items.items.length; i++) {
				if (WindowDuzenle.items.items[i].xtype == "textfield") {
					WindowDuzenle.items.items[i].clear();
				}
			}
		}

		var DuzenleKontrol = function () {
			if (!Duzenle_TextFieldKategori.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'Lütfen zorunlu tüm alanları doldurun.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

		var KaydetKontrol = function () {
			if (!Ekle_TextFieldKategori.validate()) {
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
							url: "isleme-ait-kayitlar.aspx?tablo_adi=tbl_dosyalar_kategori&kayit_id=" + record.data.id,
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
			<ext:Window ID="Window1" runat="server" Maximized="true" Title="Resim Grupları"
				Layout="FitLayout" Icon="PhotoLink" Closable="false" Minimizable="false"
				MinHeight="480" MinWidth="640">
				<Items>
					<ext:BorderLayout ID="BorderLayout1" runat="server">
						<West Collapsible="true" MinWidth="200" Split="true">
							<ext:TreePanel Shadow="None" ID="TreePanel1" runat="server" MinWidth="200" Width="200" Title="Gruplar"
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
											<ext:Button ID="TreePanelButton" runat="server" Text="Seçilen Grupları Sil" Icon="Delete"
												StandOut="true">
												<DirectEvents>
													<Click OnEvent="NodeSil">
														<Confirmation ConfirmRequest="true" Message="İşlemi onaylıyor musunuz?" Title="Onay" />
														<EventMask ShowMask="true" MinDelay="500" Msg="Seçilen gruplar siliniyor..." />
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
													<ext:RecordField Name="kategori_tip" />
													<ext:RecordField Name="kategori_id" />
													<ext:RecordField Name="ad" />
													<ext:RecordField Name="ust_kategori" />
													<ext:RecordField Name="aciklama" />
													<ext:RecordField Name="ekleyen" />
													<ext:RecordField Name="tarih_ek" Type="Date" />
													<ext:RecordField Name="guncelleyen" />
													<ext:RecordField Name="tarih_gun" Type="Date" />
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
										<ext:Column DataIndex="kategori_tip" Header="Ana Grup">
										<Renderer Fn="AnaGrupRenk" />
										</ext:Column>
										<ext:Column DataIndex="kategori_id" Header="Üst Grup ID" Hidden="true" />
										<ext:Column DataIndex="ad" Header="Grup" />
										<ext:Column DataIndex="ust_kategori" Header="Üst Grup" MenuDisabled="true" Sortable="false" />
										<ext:Column DataIndex="aciklama" Header="Açıklama" />
										<ext:Column DataIndex="ekleyen" Header="Ekleyen" />
										<ext:DateColumn DataIndex="tarih_ek" Header="Kayıt Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
											Width="125" />
										<ext:Column DataIndex="guncelleyen" Header="Güncelleyen" />
										<ext:DateColumn DataIndex="tarih_gun" Header="Güncelleme Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
											Width="125" />
										<ext:CommandColumn Header="İşlemler" Align="Center" Width="55" MenuDisabled="true"
											Resizable="false" ButtonAlign="Center">
											<Commands>
												<ext:GridCommand Icon="NoteEdit" CommandName="Duzenle">
													<ToolTip Text="Seçilen kaydı düzenle." />
												</ext:GridCommand>
												<ext:CommandSeparator />
											</Commands>
											<Commands>
												<ext:GridCommand Icon="Delete" CommandName="Sil">
													<ToolTip Text="Seçilen kaydı sil." />
												</ext:GridCommand>
											</Commands>
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
											<ext:StringFilter DataIndex="aciklama" />
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
						</Center>
					</ext:BorderLayout>
				</Items>
			</ext:Window>
			<ext:Window ID="WindowEkle" runat="server" Modal="false" Resizable="True" Height="500"
				Icon="Add" Title="Ekle" Width="640" Padding="5" Layout="FormLayout" ButtonAlign="Center"
				Shadow="Frame" LabelSeparator=" : " Draggable="True" AutoFocus="True" AutoHeight="True"
				Hidden="true">
				<Items>
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Ekle_TextFieldKategori" MaxLength="255" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Grup" BlankText="Lütfen grup adını yazın."
						AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
						<ext:TextArea ID="Ekle_TextAreaAciklama" MaxLength="500" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Açıklama" BlankText="Lütfen bir başlık yazın." AnchorHorizontal="100%"/>
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
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="Duzenle_TextFieldKategori" MaxLength="255" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Grup" BlankText="Lütfen grup adını yazın."
						AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
						<ext:TextArea ID="Duzenle_TextAreaAciklama" MaxLength="500" MaxLengthText="Maksimum karakter sınırını aştınız."
						runat="server" FieldLabel="Açıklama" BlankText="Lütfen bir başlık yazın." AnchorHorizontal="100%"/>
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
