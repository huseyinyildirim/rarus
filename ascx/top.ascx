<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        int DilID = Class.Fonksiyonlar.Dil.ID();

        s1.InnerText = Class.Fonksiyonlar.Uygulama.SabitlerText(DilID, 16);
        
        using (MySQLDataModel.BaglantiCumlesi SME = new MySQLDataModel.BaglantiCumlesi())
        {        
            var SQL = (from p in SME.tbl_menuler
                       where p.dil_id == DilID && p.onay == true
                       orderby p.sira ascending
                       select p);

            listele.DataSource = SQL;
            listele.DataBind();
        }
    }
</script>
<!--TOP-->
<div id="top">
    <div id="topm">
        <div id="topmain">
            <div id="logo">
                <a href="/">
                    <img src="/images/logo.png" alt="" />
                    <span id="s1" runat="server"></span> </a>
            </div>
            <!--MENU-->
            <div id="menu">
                <asp:Repeater ID="listele" runat="server">
                    <HeaderTemplate>
                        <ul>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li><a href="/<%# DataBinder.Eval(Container.DataItem, "url") %>">
                            <%# DataBinder.Eval(Container.DataItem, "ad") %></a></li>
                    </ItemTemplate>
                    <FooterTemplate>
                        </ul>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
            <!--MENU-->
        </div>
    </div>
</div>
<!--TOP-->