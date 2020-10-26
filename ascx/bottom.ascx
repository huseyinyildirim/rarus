<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {         
        using (MySQLDataModel.BaglantiCumlesi SME = new MySQLDataModel.BaglantiCumlesi())
        {
            int DilID = Class.Fonksiyonlar.Dil.ID();

            #region Sol Resimler
            var SQL1 = (from p in SME.tbl_ikonlar
                        where p.dil_id == DilID && p.onay == true && p.yer == (int)Class.Sabitler.Hiza.Yer.Alt
                        select p);

            if (SQL1.Count() > 0)
            {
                b1.ImageUrl = "../images/other/" + (SQL1).Where(x => x.konum == (int)Class.Sabitler.Hiza.Konum.Sol).Select(x => x.ikon).FirstOrDefault();
                b1.Attributes.Add("alt", (SQL1).Where(x => x.konum == (int)Class.Sabitler.Hiza.Konum.Sol).Select(x => x.alt).FirstOrDefault());

                b2.ImageUrl = "../images/other/" + (SQL1).Where(x => x.konum == (int)Class.Sabitler.Hiza.Konum.Sag).Select(x => x.ikon).FirstOrDefault();
                b2.Attributes.Add("alt", (SQL1).Where(x => x.konum == (int)Class.Sabitler.Hiza.Konum.Sag).Select(x => x.alt).FirstOrDefault());
            }
            else
            {
                b1.Visible = false;
                b2.Visible = false;
            } 
            #endregion

            #region Alt Menü
            var SQL2 = (from p in SME.tbl_menuler
                        where p.dil_id == DilID && p.onay == true
                        orderby p.sira ascending
                        select p);


            listele.DataSource = SQL2;
            listele.DataBind(); 
            #endregion

            #region Copyright Kısmı
            var SQL3 = (from p in SME.tbl_bottomlar
                        where p.dil_id == DilID && p.onay == true
                        select new
                        {
                            p.baslik,
                            p.text
                        });

            if (SQL3.Count() > 0)
            {
                Lit1.Text = "<h4>" + SQL3.Select(x => x.baslik).FirstOrDefault() + "</h4>";
                Lit2.Text = "<p>" + SQL3.Select(x => x.text).FirstOrDefault() + "</p>";
            } 
            #endregion
        }
    }
</script>
<!--ALT-->
<div id="bottom">
    <div id="mbottom">
        <div id="mbleft">
            <asp:Image runat="server" ID="b1" />
            <asp:Image runat="server" ID="b2" />
        </div>
        <div id="mright">
        <!--COPYRIGHT-->
            <asp:Literal ID="Lit1" runat="server" />
            <asp:Literal ID="Lit2" runat="server" />
            <!--COPYRIGHT-->
            <!-- ALT MENU-->
            <div id="altmenu">
                <asp:Repeater ID="listele" runat="server">
                    <HeaderTemplate>
                        <ul>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li><a href="/<%# DataBinder.Eval(Container.DataItem, "url") %>">
                            <%# DataBinder.Eval(Container.DataItem, "ad").ToString().ToLower() %></a></li>
                    </ItemTemplate>
                    <FooterTemplate>
                        </ul>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
             <!--ALT MENU-->
            <!--SOSYAL MEDYA-->
            <div id="socialmedia">
            <ul>
            <li><a href="#"><img id="SocialMediaIcon1" src="/images/icon/rss.png" alt="" class="arr"/></a></li>
            <%
                #region Mail
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Firma.Mail()))
                {
                    Response.Write("<li><a href=\"mailto:" + Class.Fonksiyonlar.Firma.Mail() + "\"><img id=\"SocialMediaIcon2\" src=\"/images/icon/email.png\" alt=\"\" class=\"arr\"/></a></li>");
                } 
                #endregion

                #region Flicker
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Firma.Diger.SosyalAglar.Flickr()))
                {
                    Response.Write("<li><a target=\"_blank\" href=\"http://www.flickr.com/photos/" + Class.Fonksiyonlar.Firma.Diger.SosyalAglar.Flickr() + "\"><img id=\"SocialMediaIcon3\" src=\"/images/icon/flickr.png\" alt=\"\" class=\"arr\"/></a></li>");
                }
                #endregion

                #region Youtube
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Firma.Diger.SosyalAglar.Youtube()))
                {
                    Response.Write("<li><a target=\"_blank\" href=\"http://www.youtube.com/user/" + Class.Fonksiyonlar.Firma.Diger.SosyalAglar.Youtube() + "\"><img id=\"SocialMediaIcon4\" src=\"/images/icon/youtube.png\" alt=\"\" class=\"arr\"/></a></li>");
                }
                #endregion

                #region Vimeo
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Firma.Diger.SosyalAglar.Vimeo()))
                {
                    Response.Write("<li><a target=\"_blank\" href=\"http://www.vimeo.com/" + Class.Fonksiyonlar.Firma.Diger.SosyalAglar.Vimeo() + "\"><img id=\"SocialMediaIcon5\" src=\"/images/icon/vimeo.png\" alt=\"\" class=\"arr\"/></a></li>");
                }
                #endregion
                
                #region Facebook
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Firma.Diger.SosyalAglar.Facebook()))
                {
                    Response.Write("<li><a target=\"_blank\" href=\"http://www.facebook.com/" + Class.Fonksiyonlar.Firma.Diger.SosyalAglar.Facebook() + "\"><img id=\"SocialMediaIcon6\" src=\"/images/icon/facebook.png\" alt=\"\" class=\"arr\"/></a></li>");
                } 
                #endregion

                #region Google Plus
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Firma.Diger.SosyalAglar.GooglePlus()))
                {
                    Response.Write("<li><a target=\"_blank\" href=\"https://plus.google.com/" + Class.Fonksiyonlar.Firma.Diger.SosyalAglar.GooglePlus() + "\"><img id=\"SocialMediaIcon7\" src=\"/images/icon/google_plus.png\" alt=\"\" class=\"arr\"/></a></li>");
                }
                #endregion

                #region Twitter
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Firma.Diger.SosyalAglar.Twitter()))
                {
                    Response.Write("<li><a target=\"_blank\" href=\"http://www.twitter.com/" + Class.Fonksiyonlar.Firma.Diger.SosyalAglar.Twitter() + "\"><img id=\"SocialMediaIcon8\" src=\"/images/icon/twitter.png\" alt=\"\" class=\"arr\"/></a></li>");
                } 
                #endregion
%>
            </ul>
            </div>
            <!--SOSYAL MEDYA-->
        </div>
    </div>
</div>
<!--ALT-->

<script type="text/javascript">Cufon.now();</script>
