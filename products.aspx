<%@ Page Language="C#" AutoEventWireup="true" CodeFile="products.aspx.cs" Inherits="products"
	EnableEventValidation="False" ValidateRequest="false" %>

<%--<%@OutputCache Duration="300" Location="Client" VaryByParam="none" %> --%>
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
<script type="text/javascript" src="/js/default.js"></script>
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
						<!--SIRALAMA-->
						<div id="sorting">
							<div id="sortbor">
							</div>
							<table summary="sorting">
								<tbody>
									<tr>
										<td width="50%" align="center">
											<asp:hyperlink runat="server" id="Hyperlink1"></asp:hyperlink>
											<asp:image runat="server" id="Image1" alt="" />
										</td>
										<td width="50%" align="center">
											<asp:hyperlink runat="server" id="Hyperlink2"></asp:hyperlink>
											<asp:image runat="server" id="Image2" alt="" />
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!--SIRALAMA-->
						<asp:listview runat="server" id="listeleme" onsorting="listeleme_Sorting">

<ItemTemplate>
<!--URUN-->
						<div class="product">
							<div class="prdct">
								<div class="pro">
								<div class="pim" id="pim<%#Eval("id")%>">
								<a href="/<%=Class.Fonksiyonlar.Genel.OzelAyar("URL")%>-product/<%#Eval("id")%>-<%#Class.Fonksiyonlar.Genel.KarakterTemizle((string)Eval("marka"),true)%>-<%#Class.Fonksiyonlar.Genel.KarakterTemizle((string)Eval("ad"),true)%>">
									<img id="pimg<%#Eval("id")%>" src="/ashx/product-image.ashx?i=<%#Eval("resim_id")%>&amp;w=190&amp;h=190&amp;k=t" alt="<%#Eval("ad")%>" class="pimg" />
									</a>
									</div>
									<%--<div class="h3">
										<h3><%#Eval("kod")%></h3>
									</div>--%>
									<%#Class.Fonksiyonlar.Uygulama.KodYaz(((string)Eval("kod"))) %>
								</div>
								<div class="ptext">
									<h2><%#Eval("ad")%></h2>
									<p><%#Eval("on_aciklama")%></p>
								</div>
								<div class="phref" id="phref<%#Eval("id")%>">
								<a href="/<%=Class.Fonksiyonlar.Genel.OzelAyar("URL")%>-product/<%#Eval("id")%>-<%#Class.Fonksiyonlar.Genel.KarakterTemizle((string)Eval("marka"),true)%>-<%#Class.Fonksiyonlar.Genel.KarakterTemizle((string)Eval("ad"),true)%>"><img id="mag<%#Eval("id")%>" src="/images/icon/magnifier.png" alt="" class="icon"/><%=Detay%></a>
								</div>
							</div>
						</div>
						<!--URUN-->
</ItemTemplate>

</asp:listview>
						<div id="sayfalama" runat="server">
							<asp:datapager id="sayfalamasp" runat="server" pagedcontrolid="listeleme" pagesize="5"
								querystringfield="s">
<Fields>
<asp:NumericPagerField NextPageText="»" PreviousPageText="«" ButtonCount="10" />
</Fields>
</asp:datapager>
						</div>
					</div>
					<!--SOL-->
					<!--SAG-->
					<div id="cright">
					<include:arama ID="arama" runat="server" />
						<include:kategori ID="kategori" runat="server" />
						<include:marka ID="marka" runat="server" />
						<include:etiket ID="etiket" runat="server" />
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