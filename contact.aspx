<%@ Page Language="C#" AutoEventWireup="true" CodeFile="contact.aspx.cs" Inherits="contact"
	EnableViewState="False" ViewStateMode="Disabled" EnableEventValidation="False" ValidateRequest="false"%>

<%@ Register TagPrefix="recaptcha" Namespace="Recaptcha" Assembly="Recaptcha" %>
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
<script type="text/javascript" src="/js/contact.js"></script>
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
							<p>
								<asp:literal id="p" runat="server"></asp:literal>
							</p>
						</div>
						<div id="ccont">
							<div id="Div1" style="float: left">
								<label id="lblname">
									<strong id="s1" runat="server"></strong>
								</label>
								<asp:TextBox maxlength="150" id="textname" runat="server" />
								<br />
								<label id="lblmail">
									<strong id="s2" runat="server"></strong>
								</label>
								<asp:TextBox maxlength="320" id="textmail" runat="server" />
								<br />
								<label id="lbltel">
									<strong id="s3" runat="server"></strong>
								</label>
								<asp:TextBox maxlength="15" id="texttel" runat="server" />
								<br />
								<label id="lblcom">
									<strong id="s4" runat="server"></strong>
								</label>
								<asp:TextBox id="textcom" runat="server" Rows="13" TextMode="MultiLine" />
								<br />
								<br />
								<div id="recapt">
									<recaptcha:RecaptchaControl ID="recaptcha" runat="server" PublicKey="6LeaS8sSAAAAACwlNo7FC1Nku7kS1I-yL3DF4REI"
										PrivateKey="6LeaS8sSAAAAAEi3LJlUY2zKj-qqwhmVw-IjfY-A " Theme="clean" />
								</div>
								<br />
								<asp:button id="gonder" runat="server" onclick="gonder_Click" />
							</div>
						</div>
					</div>
					<!--SOL-->
					<!--SAG-->
					<div id="cright">
						<!--SAG ADRESLER-->
						<div id="rgoogle" class="rsagi">
							<h1 style="margin-top: 0">
								<asp:literal id="h2" runat="server"></asp:literal>
							</h1>
							<!--ADRESLER-->
								 <asp:Literal ID="AdresLit" runat="server"></asp:Literal>
								 <!--ADRESLER-->
						</div>
						<!--SAG ADRESLER-->
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