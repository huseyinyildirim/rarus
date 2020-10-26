<%@ Page Language="C#" AutoEventWireup="true" CodeFile="product.aspx.cs" Inherits="product"
	EnableEventValidation="False" ValidateRequest="false" %>

<%--<%@OutputCache Duration="300" Location="Client" VaryByParam="none" %> --%>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<%@ Register Src="ascx/sitil.ascx" TagPrefix="include" TagName="sitil" %>
<%@ Register Src="ascx/top.ascx" TagPrefix="include" TagName="top" %>
<%@ Register Src="ascx/bottom.ascx" TagPrefix="include" TagName="bottom" %>
<%@ Register Src="ascx/diller.ascx" TagPrefix="include" TagName="diller" %>
<%@ Register Src="ascx/lribbon.ascx" TagPrefix="include" TagName="lribbon" %>
<%@ Register Src="ascx/rribbon.ascx" TagPrefix="include" TagName="rribbon" %>
<%@ Register Src="ascx/header.ascx" TagPrefix="include" TagName="header" %>
<%@ Register Src="ascx/rkategoriler.ascx" TagPrefix="include" TagName="kategori" %>
<%@ Register Src="ascx/rmarkalar.ascx" TagPrefix="include" TagName="marka" %>
<%@ Register Src="ascx/retiketler.ascx" TagPrefix="include" TagName="etiket" %>
<%@ Register Src="ascx/basliklar.ascx" TagPrefix="include" TagName="basliklar" %>
<%@ Register Src="ascx/rarama.ascx" TagPrefix="include" TagName="arama" %>
<include:sitil ID="sitil" runat="server" />
<!--SCRIPTS-->
<script type="text/javascript" src="/js/main.js"></script>
<script type="text/javascript" src="/js/product.js"></script>
<script type="text/javascript" src="/js/search.js"></script>
<!--SCRIPTS-->
<!--ANA DIV-->
<div id="main">
	<form id="form1" runat="server">
	<include:lribbon ID="lribbon" runat="server" />
	<include:rribbon ID="rribbon" runat="server" />
	<include:top ID="top" runat="server" />
	<include:diller ID="diller" runat="server" />
	<include:header ID="header" runat="server" />
	<div id="content">
		<div id="bot">
			<div id="cma">
			<include:basliklar ID="basliklar" runat="server" />
				<div id="cmain">
						<!--SOL-->
					<div id="cleft">
						<div id="ccom">
							<h1>
								<asp:literal id="h1" runat="server"></asp:literal>
							</h1>
						</div>
						<div id="ccont">
							<!--URUN-->
							<div id="product2">
								<div id="product2m">
									<ul>
										<li>
											<anthem:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click"></anthem:LinkButton></li>
										<li>
											<anthem:LinkButton ID="LinkButton2" runat="server" OnClick="LinkButton2_Click"></anthem:LinkButton></li>
										<li>
											<anthem:LinkButton ID="LinkButton3" runat="server" OnClick="LinkButton3_Click"></anthem:LinkButton></li>
									</ul>
									<!--LOADING-->
									<div id="aloading">
									</div>
									<!--LOADING-->
								</div>
								<!--URUN IC-->
								<div id="product2a">
									<anthem:Panel ID="Panel1" runat="server" AutoUpdateAfterCallBack="True">
										<!--URUN OZELLIKLER-->
										<%=RBaslik%>
										<div id="product2ar">
											<div id="product2ardiv" class="loading">
											</div>
										</div>
										<div class="product2aic">
											<asp:literal id="on_icerik" runat="server"></asp:literal>
										</div>
										<div class="product2aic2">
											<asp:literal id="icerik" runat="server"></asp:literal>
										</div>
										<!--URUN OZELLIKLER-->
									</anthem:Panel>
									<anthem:Panel ID="Panel2" runat="server" Visible="false" Enabled="false" AutoUpdateAfterCallBack="True">
										<!--URUN RESIMLER-->
										<div class="product2aic">
											<div id="prordiv" runat="server">
											</div>
										</div>
										<!--URUN RESIMLER-->
									</anthem:Panel>
									<anthem:Panel ID="Panel3" runat="server" Visible="false" Enabled="false" AutoUpdateAfterCallBack="True">
										<!--URUN VIDEOLAR-->
										<div class="product2aic">
											<div id="prordiv2" runat="server">
											</div>
										</div>
										<!--URUN VIDEOLAR-->
									</anthem:Panel>
								</div>
								<!--URUN IC-->
							</div>
							<!--URUN-->
						</div>
					</div>
					<!--SOL-->
					<!--SAG-->
					<div id="cright">
					<include:arama ID="arama" runat="server" />
						<include:kategori ID="kategori" runat="server" />
						<include:marka ID="marka" runat="server" />
						<include:etiket ID="etiket" runat="server" />
					</div>
					<!--SAG-->
				</div>
			</div>
		</div>
	</div>
	<include:bottom ID="bottom" runat="server" />
	</form>
</div>
<!--ANA DIV-->
</body> </html>