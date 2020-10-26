<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        var SQL = (from p in Objeler.Listeler.Diller
                   where p.Onay == true
                   orderby p.Sira ascending
                   select p);

        if (SQL.Count() > 1)
        {
            listele.DataSource = SQL;
            listele.DataBind();
        }
    }

    protected void LB_Click(object sender, EventArgs e)
    {
        if (((System.Web.UI.WebControls.LinkButton)(sender)).CommandArgument != null)
        {
            int YeniDilID = Convert.ToInt16(((System.Web.UI.WebControls.LinkButton)(sender)).CommandArgument);
            var SQL = (from p in Objeler.Listeler.Diller
                       where p.Onay == true && p.ID == YeniDilID
                       select new {p.ID });
            
            #region Dil
            Application.Lock();

            #region Dil Sil
            int index = -1;
            index = Objeler.Listeler.Dil.FindIndex(delegate(Objeler.Tanimlar.Dil p)
            {
                return (p.SessionID == Session.SessionID);
            });
            if (index != -1)
            {
                Objeler.Listeler.Dil.RemoveAt(index);
            } 
            #endregion

            #region Dil Ekle
            if (!Class.Fonksiyonlar.Dil.SessionKontrol())
            {
                Objeler.Tanimlar.Dil D = new Objeler.Tanimlar.Dil();
                D.DilID = SQL.Select(x => x.ID).FirstOrDefault();
                D.SessionID = Session.SessionID;
                D.Tarih = DateTime.Now;
                D.IP = Request.ServerVariables["REMOTE_ADDR"];
                Objeler.Listeler.Dil.Add(D);
            }
            #endregion

            Application.UnLock();
            #endregion

            Response.Redirect(Class.Fonksiyonlar.Genel.MevcutSayfa());
        }
    }
</script>
<!--DILLER-->
<div id="htop">
    <asp:Repeater ID="listele" runat="server">
        <HeaderTemplate>
            <ul>
        </HeaderTemplate>
        <ItemTemplate>
            <li>
            <asp:LinkButton runat="server" ID="LB" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "id") %>' onclick="LB_Click">
                <img src="/images/flag/<%# DataBinder.Eval(Container.DataItem, "ikon") %>" alt="<%# DataBinder.Eval(Container.DataItem, "dil") %>" /><%# DataBinder.Eval(Container.DataItem, "kisaltma") %>
                </asp:LinkButton>
                </li>
        </ItemTemplate>
        <SeparatorTemplate>
            <li>
                <img src="/images/lang.png" alt="" /></li>
        </SeparatorTemplate>
        <FooterTemplate>
            </ul>
        </FooterTemplate>
    </asp:Repeater>
</div>
<!--DILLER-->