using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using MySQLDataModel;
using System.Web.UI.WebControls;

public partial class product : System.Web.UI.Page
{
    #region Int
    public int UrunID;
    public int DilID;
    public int KategoriID { get; set; }
    #endregion

    #region String
    public string Baslik;
    public string RBaslik { get; set; }
    #endregion

    #region List
    public List<string> Keywords = new List<string>();
    public List<string> Etiketler = new List<string>();
    public List<string> Markalar = new List<string>();
    #endregion

    #region Dictionary
    public Dictionary<int, string> Kategoriler = new Dictionary<int, string>();
    public Dictionary<int, string> Resimler = new Dictionary<int, string>();
    public Dictionary<int, string> Videolar = new Dictionary<int, string>();
    #endregion

    #region Class
    public Objeler.Tanimlar.Urun U { get; set; }
    #endregion

    #region VIEWSTATE Serializer

    private ViewStateSerializer.ViewStateSerializer _persister = null;
    protected override PageStatePersister PageStatePersister
    {
        get
        {
            if (_persister == null)
            {
                _persister = new ViewStateSerializer.ViewStateSerializer(Page, ViewStateSerializer.ViewStateSerializer.SecurityLevel.Low, false);
                //_persister.CompressPage(); // optional (compress all output HTML page) if have problems, comment it
            }
            return _persister;
        }
    }
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        #region Dil ID
        DilID = Class.Fonksiyonlar.Dil.ID(); 
        #endregion

        #region JS ile CSS Ayar
        //Class.Fonksiyonlar.JavaScript.Ekle("$(function () {if ($('#cleft').height() < $('#cright').height()){$('#cleft').css({'min-height' : $('#cright').height()+50})};});\r\n");
        #endregion

        #region QueryString Al
        if (RouteData.Values["UrunID"] != null)
        {
            if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["UrunID"].ToString())))
            {
                if (Class.Fonksiyonlar.Genel.Kontroller.Numerik(Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["UrunID"].ToString().Split('-')[0])))
                {
                    UrunID = Convert.ToInt16(Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["UrunID"].ToString().Split('-')[0]));

                    #region ColorBox CSS
                    Class.Fonksiyonlar.UserKontrol.ElemanGizle(0, "sitil", "colorbox", true);
                    #endregion

                    #region Ürüne Ait kategori_id, marka_id, kod, ad, on_aciklama Gibi Bilgileri Obje Olarak Al
                    U = Class.Fonksiyonlar.Uygulama.Sag.Urun.Bilgiler(UrunID);
                    #endregion

                    Basliklar();
                    UrunMenu();
                    Listele();
                }
                else
                {
                    Response.Redirect("/");
                }
            }
            else
            {
                Response.Redirect("/");
            }
        }
        else
        {
            Response.Redirect("/");
        }
        #endregion

        #region Ürün Kodunu Keywordse Ekle
        if (!string.IsNullOrEmpty(U.kod))
        {
            Keywords.Add(Class.Fonksiyonlar.Genel.KarakterTemizle(U.kod.ToLower(),false));
        }
        #endregion

        #region Ürün Adını Keywordse Ekle
        if (!string.IsNullOrEmpty(U.ad))
        {
            Keywords.Add(Class.Fonksiyonlar.Genel.KarakterTemizle(U.ad.ToLower(),false));
        }
        #endregion

        #region Description Metatag
        Class.Fonksiyonlar.UserKontrol.HeaderText("sitil", "description", "<meta http-equiv=\"Description\" content=\"" + U.on_aciklama.Replace("<br/>"," ") + "\" />");
        #endregion

        #region Kategorileri Al
        #region Objeden Kategori ID yi Setle
        KategoriID = U.kategori_id; 
        #endregion

        if (KategoriID == 0)
        {
            Kategoriler = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Kategoriler(DilID, 0);
        }
        else
        {
            Kategoriler = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Kategoriler(DilID, KategoriID);

            if (Kategoriler.Count < 1)
            {
                Kategoriler = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Kategoriler(DilID, 0);
            }
        }
        #endregion

        #region Kategorileri Bas
        Class.Fonksiyonlar.Uygulama.Sag.Icerik.Kategoriler(Kategoriler);
        #endregion

        #region Ürün Markalari Al
        Markalar = Class.Fonksiyonlar.Uygulama.Sag.Urun.Markalar(UrunID);
        #endregion

        #region Markalari Bas
        Class.Fonksiyonlar.Uygulama.Sag.Icerik.Markalar(Markalar);
        #endregion

        #region Ürün Etiketleri Al
        Etiketler = Class.Fonksiyonlar.Uygulama.Sag.Urun.Etiketler(UrunID);
        #endregion

        #region Ürün Resimler
        Resimler = Class.Fonksiyonlar.Uygulama.Sag.Urun.Resimler(UrunID);

        #region Resimler Null İse Gizle
        if (Resimler.Count < 1)
        {
            LinkButton2.Visible = false;
        }
        #endregion

        #endregion

        #region Ürün Videolar
        Videolar = Class.Fonksiyonlar.Uygulama.Sag.Urun.Videolar(UrunID);

        #region Videolar Null İse Gizle
        if (Videolar.Count < 1)
        {
            LinkButton3.Visible = false;
        }
        #endregion
        #endregion

        #region Resimler ve Videolar Yoksa 1. Butonu da Deaktif Yap
        if (!LinkButton2.Visible && !LinkButton3.Visible)
        {
            LinkButton1.Enabled = false;
            LinkButton1.Click += null;
            LinkButton1.Visible = false;
        }
        #endregion

        #region Etiketleri Bas
        Class.Fonksiyonlar.Uygulama.Sag.Icerik.Etiketler(Etiketler);
        #endregion

        #region Keywords Bas
        KeywordsBas(); 
        #endregion
    }

    private void KeywordsBas()
    {
        #region Kategorileri Keywordse Ekle
        Keywords.AddRange(new List<string>(Kategoriler.Values));
        #endregion

        #region Markaları Keywordse Ekle
        Keywords.AddRange(Markalar);
        #endregion

        #region Etiketleri Keywordse Ekle
        Keywords.AddRange(Etiketler);
        #endregion

        #region Keywordsler İçinde Aynı Kayıtlar Varsa Sil
        List<string> L = Keywords.Distinct().ToList().ConvertAll(x => Class.Fonksiyonlar.Genel.TurkceKarakter(x.ToString().ToLower())); 
        #endregion

        #region Listeden Keywordsleri Al
        StringBuilder SB2 = new StringBuilder();

        int a = 0;

        foreach (var i in L)
        {
            if (a != L.Count - 1)
            {
                SB2.Append(i + ",");
            }
            else
            {
                SB2.Append(i);
            }

            a++;
        }

        if (!string.IsNullOrEmpty(SB2.ToString()))
        {
            if (SB2.ToString().Substring(SB2.ToString().Length - 1, 1) == ",")
            {
                SB2.Append(Class.Fonksiyonlar.Firma.Title());
            }
        }
        #endregion

        #region Keywords Metatag
        Class.Fonksiyonlar.UserKontrol.HeaderText("sitil", "keywords", "<meta http-equiv=\"Keywords\" content=\"" + SB2.ToString().Replace(", ", ",").Replace(",",", ") + "\" />");
        #endregion
    }

    private void Basliklar()
    {
        #region Başlık Sol

        #region Sol Başlık Visibility
        Class.Fonksiyonlar.UserKontrol.ElemanGizle(0, "basliklar", "baslik_sol", true);
        #endregion

        #region Literal Al
        UserControl UC = (UserControl)((Page)HttpContext.Current.Handler).FindControl("basliklar");
        Literal Li = UC.FindControl("ic_kategori") as Literal;
        #endregion

        StringBuilder SB = new StringBuilder();

        Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sol", "<h1><img id=\"arrow1\" src=\"/images/arrow.png\" alt=\"\" class=\"arr\"/><a href=\"/" + Class.Fonksiyonlar.Genel.OzelAyar("URL") + "-products\">" + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 17) + "</a></h1>");

        #region Tüm Ürünler Bas
        SB.Append("<!--IC KATEGORI-->\r\n<ul>\r\n");
        SB.Append("<li><img src=\"/images/arrow.png\" alt=\"\"/> <span>" + U.ad.ToUpper() + "</span></li>");
        SB.Append("</ul>\r\n<!--IC KATEGORI-->\r\n");
        #endregion

        #region Literal Göster
        Li.Text = SB.ToString();
        Li.Visible = true;
        #endregion

        #endregion

        #region Başlık Sağ

        #region Sağ Başlık Visibility
        Class.Fonksiyonlar.UserKontrol.ElemanGizle(0, "basliklar", "baslik_sag", true);
        #endregion

        #region Başlık Text
        StringBuilder SB1 = new StringBuilder();
        SB1.Append("<!--SAG BASLIK-->\r\n");
        SB1.Append("<div id=\"basr\"><h1><img id=\"mail1\" src=\"/images/icon/lorry.png\" alt=\"\" class=\"icon\"/> " + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 17) + "</h1></div>\r\n");
        SB1.Append("<!--SAG BASLIK-->\r\n");
        #endregion

        Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sag", SB1.ToString());

        #endregion
    }

    private void UrunMenu()
    {
        LinkButton1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 21);
        LinkButton2.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 22);
        LinkButton3.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 23);
    }

    private void ResimleriBas()
    {
        if (Resimler.Count > 0)
        {
            StringBuilder SB = new StringBuilder();

            foreach (var i in Resimler)
            {
                SB.Append("<div class=\"prores\">\r\n");
                SB.Append("<a class=\"group1\" href=\"");
                SB.Append("/ashx/product-image.ashx?i=");
                SB.Append(i.Key);
                SB.Append("&amp;w=600&amp;h=440&amp;k=t");
                SB.Append("\" title=\"");
                SB.Append(Class.Fonksiyonlar.Firma.Marka() + " | " + Baslik);
                SB.Append("\">\r\n");
                SB.Append("<img src=\"/ashx/product-image.ashx?i=");
                SB.Append(i.Key);
                SB.Append("&amp;w=156&amp;h=156&amp;k=t\" alt=\"");
                SB.Append(i.Value);
                SB.Append("\"/>\r\n");
                SB.Append("</a>\r\n");
                SB.Append("</div>\r\n");
            }

            prordiv.InnerHtml = SB.ToString();
        }
    }

    private void VideolariBas()
    {
        if (Videolar.Count > 0)
        {
            StringBuilder SB = new StringBuilder();

            foreach (var i in Videolar)
            {
                SB.Append("<div class=\"prores\">\r\n");
                SB.Append("<a class=\"group1\" href=\"");
                SB.Append(i.Value);
                SB.Append("\" title=\"");
                SB.Append(Class.Fonksiyonlar.Firma.Marka() + " | " + Baslik);
                SB.Append("\">\r\n");
                SB.Append("<img src=\"/images/video.gif\" alt=\"");
                SB.Append(i.Value);
                SB.Append("\"/>\r\n");
                SB.Append("</a>\r\n");
                SB.Append("</div>\r\n");
            }

            prordiv2.InnerHtml = SB.ToString();
        }
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        Panel1.Visible = true;
        Panel2.Visible = false;
        Panel3.Visible = false;

        Panel1.Enabled = true;
        Panel2.Enabled = false;
        Panel3.Enabled = false;
    }

    protected void LinkButton2_Click(object sender, EventArgs e)
    {
        Panel1.Visible = false;
        Panel2.Visible = true;
        Panel3.Visible = false;

        Panel1.Enabled = false;
        Panel2.Enabled = true;
        Panel3.Enabled = false;

        ResimleriBas();
    }

    protected void LinkButton3_Click(object sender, EventArgs e)
    {
        Panel1.Visible = false;
        Panel2.Visible = false;
        Panel3.Visible = true;

        Panel1.Enabled = false;
        Panel2.Enabled = false;
        Panel3.Enabled = true;

        VideolariBas();
    }

    protected void Listele()
    {
        using (BaglantiCumlesi SME = new BaglantiCumlesi())
        {
            var SQL = (from p in SME.tbl_urunler
                       where p.id == UrunID && p.dil_id == DilID && p.onay == true
                       select new
                       {
                           p.aciklama,
                           p.resim_id,
                       }).ToList();

            if (SQL.Count() > 0)
            {

                #region Ürün Resmi
                StringBuilder SB = new StringBuilder();

                SB.Append("function UrunResmiYukle() {\r\n");
                SB.Append("var img = new Image();\r\n");
                SB.Append("$(img).load(function () {\r\n");
                SB.Append("//$(this).css(\"display\", \"none\"); // .hide() doesn\"t work in Safari when the element isn\"t on the DOM already\r\n");
                SB.Append("$(this).hide();\r\n");
                SB.Append("$(\"#product2ardiv\").removeClass(\"loading\").append(this);\r\n");
                SB.Append("$(this).fadeIn(\"slow\");\r\n");
                SB.Append("}).error(function () {\r\n");
                SB.Append("$(\"#product2ardiv\").removeClass(\"loading\").append(this);\r\n");
                SB.Append("$(\"#product2ardiv\").html(\"<p>Image could not be loaded!</p>\");\r\n");
                SB.Append("}).attr(\"src\",");
                SB.Append("\"" + "/ashx/product-image.ashx?i=" + SQL[0].resim_id + "&w=555&h=277&k=t" + "");
                SB.Append("\").attr(\"alt\",");
                SB.Append("\"" + U.ad + "\"");
                SB.Append(");\r\n");
                SB.Append("};");

                Class.Fonksiyonlar.JavaScript.Ekle(SB.ToString());
                #endregion

                #region Başlık
                h1.Text = U.ad;
                RBaslik = (!string.IsNullOrEmpty(U.kod) ? Class.Fonksiyonlar.Uygulama.KodYaz(U.kod) : null);
                Baslik = h1.Text.Trim();
                #endregion

                #region Ön İçerik
                on_icerik.Text = "<p>" + U.on_aciklama + "</p>";
                #endregion

                #region İçerik
                icerik.Text = SQL[0].aciklama;
                #endregion

                #region Ziyaret Ekle
                Class.Fonksiyonlar.Uygulama.ZiyaretEkle((int)Class.Sabitler.Ziyaret.URUN, UrunID);
                #endregion
            }
            else
            {
                h1.Text = "Language Error";
                on_icerik.Text = "<p>Language Error</p>";
                icerik.Text = "<p>Language Error</p>";
            }
        }
    }
}