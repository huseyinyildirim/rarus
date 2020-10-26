<%@ Page Language="C#" AutoEventWireup="true" CodeFile="site-ziyaretleri.aspx.cs" Inherits="yonetim_Kullanici"
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
		Ext.data.Connection.override({
			timeout: 300000
		});

		Ext.Ajax.timeout = 300000;

		var ExportYap = function () {
			Ext.net.Mask.show();
			Ext.net.Mask.hide.defer(500);
		};

		var TipTemplate = '<span style="color:{0}">{1}</span>';

		var TipRenk = function (v) {

			/*
			0 ÜRÜN
			1 KATEGORİ
			2 ETİKET
			3 MARKA
			*/

			if (v != null) {
				switch (v) {
					case "ÜRÜN":
						return String.format(TipTemplate, "#E040E0", v);
						break;

					case "KATEGORİ":
						return String.format(TipTemplate, "#F14570", v);
						break;

					case "ETİKET":
						return String.format(TipTemplate, "#FFA049", v);
						break;

					case "MARKA":
						return String.format(TipTemplate, "#40E08B", v);
						break;
				}
			}
		};

		var GridKomutlari = function (cmd, record) {
			switch (cmd) {

				case "TumBilgiler":

					var win2 = new Ext.Window({
						id: 'WindowT' + record.data.id,
						iconCls: "icon-usermagnify",
						title: 'Tüm Ziyaret Bilgileri Gösterim Penceresi - ' + record.data.id,
						closable: false,
						width: 840,
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
							url: "ziyaret-bilgi.aspx?tablo_adi=tbl_ziyaretler&kayit_id=" + record.data.id,
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
			}
		}
	</script>
	<form id="form1" runat="server">
	<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Gray" Locale="tr-TR"
		GZip="true" />
	<ext:Viewport ID="Viewport1" runat="server" Layout="FitLayout" StyleSpec="background-color:#F0F0F0">
		<Items>
			<ext:Window ID="Window1" runat="server" Maximized="true" Title="Site Ziyaretleri" Layout="FitLayout"
				Icon="TableSort" Closable="false" Minimizable="false" MinHeight="480" MinWidth="640">
				<Items>
					<ext:GridPanel ID="GridPanel1" runat="server" ColumnLines="true" SortType="AsUCString" AutoExpandColumn="urun"
						OnBeforeClientInit="GridPanelYuklenmedenOnce" AnchorHorizontal="100%" Region="Center" AutoScroll="true" MonitorResize="true" TrackMouseOver="true">
						<Store>
							<ext:Store ID="Store1" runat="server" OnRefreshData="KayitlariYenile"
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
											<ext:RecordField Name="tip" Type="Int"/>
											<ext:RecordField Name="tips" />
											<ext:RecordField Name="urun_id" Type="Int" />
											<ext:RecordField Name="urun_dil" />
											<ext:RecordField Name="urun" />
											<ext:RecordField Name="kategori_id" Type="Int" />
											<ext:RecordField Name="kategori_dil" />
											<ext:RecordField Name="kategori" />
											<ext:RecordField Name="etiket_id" Type="Int" />
											<ext:RecordField Name="etiket_dil" />
											<ext:RecordField Name="etiket" />
											<ext:RecordField Name="marka_id" Type="Int" />
											<ext:RecordField Name="marka" />
											<ext:RecordField Name="tarih" />
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
								<ext:Column DataIndex="tip" Header="Ziyaret Tipi ID" Hidden="true" />
								<ext:Column DataIndex="tips" Header="Ziyaret Tipi">
								<Renderer Fn="TipRenk" />
								</ext:Column>
								<ext:Column DataIndex="urun_id" Header="Ürün ID" Hidden="true"/>
								<ext:Column DataIndex="urun_dil" Header="Ürün Dil" MenuDisabled="true" Sortable="false"/>
								<ext:Column DataIndex="urun" Header="Ürün" MenuDisabled="true" Sortable="false"/>
								<ext:Column DataIndex="kategori_id" Header="Kategori ID" Hidden="true"/>
								<ext:Column DataIndex="kategori_dil" Header="Kategori Dil" MenuDisabled="true" Sortable="false"/>
								<ext:Column DataIndex="kategori" Header="Kategori" MenuDisabled="true" Sortable="false"/>
								<ext:Column DataIndex="etiket_id" Header="Etiket ID" Hidden="true"/>
								<ext:Column DataIndex="etiket_dil" Header="Etiket Dil" MenuDisabled="true" Sortable="false"/>
								<ext:Column DataIndex="etiket" Header="Etiket" MenuDisabled="true" Sortable="false"/>
								<ext:Column DataIndex="marka_id" Header="Marka ID" Hidden="true"/>
								<ext:Column DataIndex="marka" Header="Marka" MenuDisabled="true" Sortable="false"/>
								<ext:DateColumn DataIndex="tarih" Header="Tarih" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
											Width="125" />
											<ext:CommandColumn Header="TB" Align="Center" Width="28" MenuDisabled="true" Resizable="false"
									ButtonAlign="Center" Hidden="true" Hideable="false">
									<Commands>
										<ext:GridCommand Icon="UserMagnify" CommandName="TumBilgiler">
											<ToolTip Text="Diğer bilgileri göster" />
										</ext:GridCommand>
									</Commands>
								</ext:CommandColumn>
							</Columns>
						</ColumnModel>
						<Plugins>
							<ext:GridFilters runat="server" ID="GridFilters1" Local="true">
								<Filters>
									<ext:NumericFilter DataIndex="id" />
									<ext:NumericFilter DataIndex="urun_id" />
									<ext:NumericFilter DataIndex="kategori_id" />
									<ext:NumericFilter DataIndex="etiket_id" />
									<ext:NumericFilter DataIndex="marka_id" />
									<ext:NumericFilter DataIndex="tip" />
									<ext:DateFilter DataIndex="tarih">
												<DatePickerOptions runat="server" TodayText="Now" />
											</ext:DateFilter>
								</Filters>
							</ext:GridFilters>
						</Plugins>
						<SelectionModel>
							<ext:RowSelectionModel ID="RowSelectionModel" runat="server" />
						</SelectionModel>
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
		</Items>
	</ext:Viewport>
	</form>
</body>
</html>
