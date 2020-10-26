<%@ Page Language="C#" AutoEventWireup="true" CodeFile="about.aspx.cs" Inherits="about"
	EnableViewState="False" ViewStateMode="Disabled" EnableEventValidation="False" ValidateRequest="false" %>

<%--<%@OutputCache Duration="300" Location="Client" VaryByParam="none" %> --%>
<%@ Register Src="ascx/sitil.ascx" TagPrefix="include" TagName="sitil" %>
<%@ Register Src="ascx/top.ascx" TagPrefix="include" TagName="top" %>
<%@ Register Src="ascx/bottom.ascx" TagPrefix="include" TagName="bottom" %>
<%@ Register Src="ascx/diller.ascx" TagPrefix="include" TagName="diller" %>
<%@ Register Src="ascx/lribbon.ascx" TagPrefix="include" TagName="lribbon" %>
<%@ Register Src="ascx/rribbon.ascx" TagPrefix="include" TagName="rribbon" %>
<%@ Register Src="ascx/header.ascx" TagPrefix="include" TagName="header" %>
<%@ Register Src="ascx/basliklar.ascx" TagPrefix="include" TagName="basliklar" %>
<include:sitil ID="sitil" runat="server" />
<!--SCRIPTS-->
<script type="text/javascript" src="/js/main.js"></script>
<script type="text/javascript" src="/js/about.js"></script>
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
							<!--HAKKINDA RESIM-->
							<div id="about">
								<div id="aboutdiv" class="loading">
								</div>
							</div>
							<!--HAKKINDA RESIM-->
							<p>
								<asp:literal id="p" runat="server"></asp:literal>
							</p>
						</div>
					</div>
					<!--SOL-->
					<!--SAG-->
					<div id="cright">
						<!--KOD-->
						<asp:Literal ID="litkod" runat="server" />
						<!--KOD-->
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