<%@ Page Language="C#" AutoEventWireup="true" CodeFile="iletisimden-gelen-mailler.aspx.cs"
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
		var OkunmaTemplate = '<span style="color:{0};font-weight:{1}">{2}</span>';

		var OkunmaRenk = function (v) {
			return String.format(OkunmaTemplate, (v == "HAYIR") ? "red" : "black", (v == "HAYIR") ? "bold" : "normal", v);
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
			switch (record.data.okundu) {
				case "EVET":
					toolbar.items.get(2).setDisabled(true);
					toolbar.items.get(2).setTooltip("İlgili kaydın durumu nedeniyle bu buton devre dışı bırakılmıştır.");
					break;
			}
		};

		var GridKomutlari = function (cmd, record) {
			switch (cmd) {
				case "Okundu":
					Ext.Msg.confirm('Uyarı', 'Seçilen kaydı okundu olarak işaretle?', function (btn) {
						if (btn == "yes") {
							Ext.net.DirectMethods.Oku(record.data.id);
						}
					});
					break;

				case "Oku":
					Ext.net.DirectMethods.OkumaEkraniGetir(record.data.id);
					break;
			}
		}
	</script>
	<form id="form1" runat="server">
	<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Gray" Locale="tr-TR"
		GZip="true" />
	<ext:Viewport ID="Viewport1" runat="server" Layout="FitLayout" StyleSpec="background-color:#F0F0F0">
		<Items>
			<ext:Window ID="Window1" runat="server" Maximized="true" Title="İletişimden Gelen Mailler"
				Layout="FitLayout" Icon="EmailOpen" Closable="false" Minimizable="false" MinHeight="480"
				MinWidth="640">
				<Items>
					<ext:GridPanel ID="GridPanel1" runat="server" ColumnLines="true" SortType="AsUCString"
						AutoExpandColumn="ad_soyad" OnBeforeClientInit="GridPanelYuklenmedenOnce" AnchorHorizontal="100%"
						Region="Center" AutoScroll="true" MonitorResize="true" TrackMouseOver="true">
						<Store>
							<ext:Store ID="Store1" runat="server" OnRefreshData="KayitlariYenile" RemoteSort="true">
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
											<ext:RecordField Name="mail" />
											<ext:RecordField Name="okundu" />
											<ext:RecordField Name="tarih" Type="Date" />
											<ext:RecordField Name="guncelleyen" />
											<ext:RecordField Name="tarih_gun" Type="Date" />
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
								<ext:Column DataIndex="ad_soyad" Header="Ad Soyad" />
								<ext:Column DataIndex="mail" Header="Mail Adresi" />
								<ext:Column DataIndex="okundu" Header="Okunma" Align="Center" Width="60">
									<Renderer Fn="OkunmaRenk" />
								</ext:Column>
								<ext:DateColumn DataIndex="tarih" Header="Kayıt Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
									Width="125" />
								<ext:Column DataIndex="guncelleyen" Header="Okuyan" />
								<ext:DateColumn DataIndex="tarih_gun" Header="Okunma Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
									Width="125" />
								<ext:CommandColumn Header="İşlemler" Align="Center" Width="55" MenuDisabled="true"
									Resizable="false" ButtonAlign="Center">
									<Commands>
										<ext:GridCommand Icon="EmailMagnify" CommandName="Oku">
											<ToolTip Text="Seçilen maili oku." />
										</ext:GridCommand>
										<ext:CommandSeparator />
									</Commands>
									<Commands>
										<ext:GridCommand Icon="EmailStar" CommandName="Okundu">
											<ToolTip Text="Seçilen kaydı okundu olarak işaretle." />
										</ext:GridCommand>
									</Commands>
									<PrepareToolbar Fn="DugmelerinDurumu" />
								</ext:CommandColumn>
							</Columns>
						</ColumnModel>
						<Plugins>
							<ext:GridFilters runat="server" ID="GridFilters1" Local="true">
								<Filters>
									<ext:NumericFilter DataIndex="id" />
									<ext:StringFilter DataIndex="ad_soyad" />
									<ext:StringFilter DataIndex="mail" />
									<ext:DateFilter DataIndex="tarih">
										<DatePickerOptions runat="server" TodayText="Now" />
									</ext:DateFilter>
									<ext:DateFilter DataIndex="tarih_gun">
										<DatePickerOptions runat="server" TodayText="Now" />
									</ext:DateFilter>
									<ext:ListFilter DataIndex="okundu" Options="EVET,HAYIR" />
								</Filters>
							</ext:GridFilters>
						</Plugins>
						<SelectionModel>
							<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server" />
						</SelectionModel>
						<Buttons>
							<ext:Button runat="server" ID="Button1" Text="Okundu" Icon="EmailStar">
								<DirectEvents>
									<Click OnEvent="SecilenleriOku">
										<Confirmation ConfirmRequest="true" Message="İşlemi onaylıyor musunuz?" Title="Onay" />
										<EventMask ShowMask="true" MinDelay="500" Msg="Yükleniyor..." />
									</Click>
								</DirectEvents>
							</ext:Button>
						</Buttons>
						<LoadMask ShowMask="true" Msg="Yükleniyor..." />
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
			<ext:Window ID="WindowOku" runat="server" Modal="false" Resizable="True" Height="500"
				Icon="EmailMagnify" Title="Mail Oku" Width="640" Padding="5" Layout="FormLayout"
				ButtonAlign="Right" Shadow="None" LabelSeparator=" : " Draggable="True" AutoFocus="True"
				AutoHeight="True" Hidden="true">
				<Items>
					<ext:Panel ID="Panel0" runat="server" Title="Durum" FormGroup="true" Layout="FormLayout"
						Padding="5" StyleSpec="margin-bottom:5px;background:#fff;border:1px solid #C3DAF9"
						LabelSeparator=" : " AnchorHorizontal="99%">
						<Content>
							<ext:Label ID="Label_Durum" runat="server" FieldLabel="Durum" AnchorHorizontal="100%" />
						</Content>
					</ext:Panel>
					<ext:Panel ID="Panel1" runat="server" Title="Mail Bilgileri" FormGroup="true" Layout="FormLayout"
						Padding="5" StyleSpec="margin-bottom:5px;background:#fff;border:1px solid #C3DAF9"
						LabelSeparator=" : " AnchorHorizontal="99%">
						<Content>
							<ext:Label ID="Label_AdSoyad" runat="server" FieldLabel="Ad Soyad" AnchorHorizontal="100%" />
							<ext:Label ID="Label_Mail" runat="server" FieldLabel="Mail Adresi" AnchorHorizontal="100%" />
							<ext:Label ID="Label_Telefon" runat="server" FieldLabel="Telefon" AnchorHorizontal="100%" />
							<ext:Label ID="Label_Gorusler" runat="server" FieldLabel="Görüşler" AnchorHorizontal="100%" />
							<ext:Label ID="Label_Tarih" runat="server" FieldLabel="Tarih" AnchorHorizontal="100%" />
						</Content>
					</ext:Panel>
					<ext:Panel ID="Panel2" runat="server" Title="Okunma Bilgileri" FormGroup="true" Layout="FormLayout"
						Padding="5" StyleSpec="background:#fff;border:1px solid #C3DAF9" LabelSeparator=" : "
						AnchorHorizontal="99%">
						<Content>
							<ext:Label ID="Label_Okuyan" runat="server" FieldLabel="Okuyan" AnchorHorizontal="100%" />
							<ext:Label ID="Label_OkunmaTarih" runat="server" FieldLabel="Okunma Tarih" AnchorHorizontal="100%" />
						</Content>
					</ext:Panel>
				</Items>
				<Buttons>
					<ext:Button ID="Kapat" runat="server" Text="Kapat" Icon="Cancel">
						<Listeners>
							<Click Handler="WindowOku.hide();" />
						</Listeners>
					</ext:Button>
				</Buttons>
			</ext:Window>
		</Items>
	</ext:Viewport>
	</form>
</body>
</html>
