using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySQLDataModel;
using System.Web.Routing;

public partial class _default : System.Web.UI.Page
{
    #region Int
    public int DilID; 
    #endregion

    #region String
    public string Detay { get; set; } 
    #endregion

    #region List
    public List<string> Keywords = new List<string>();
    public List<string> Etiketler = new List<string>();
    public List<string> Markalar = new List<string>();
    public List<string> UrunKodlari = new List<string>();
    public List<string> UrunAdlari = new List<string>(); 
    #endregion

    #region Dictionary
    public Dictionary<int, string> Kategoriler = new Dictionary<int, string>(); 
    #endregion

    #region Class
    public static class SiralamaIsleri
    {
        #region String
        public static string Kolon { get; set; }
        public static string Direktif { get; set; } 
        #endregion

        #region Void
        public static void HadiSirala()
        {
            if (Class.Fonksiyonlar.Genel.StringTemizle(HttpContext.Current.Request.QueryString["k"]) != null)
            {
                Kolon = Class.Fonksiyonlar.Genel.StringTemizle(HttpContext.Current.Request.QueryString["k"]);
            }

            if (Class.Fonksiyonlar.Genel.StringTemizle(HttpContext.Current.Request.QueryString["d"]) != null)
            {
                Direktif = Class.Fonksiyonlar.Genel.StringTemizle(HttpContext.Current.Request.QueryString["d"]).ToUpper();
            }
        } 
        #endregion
    } 
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

        #region Description Metatag
        Class.Fonksiyonlar.UserKontrol.HeaderText("sitil", "description", "<meta http-equiv=\"Description\" content=\"" + Class.Fonksiyonlar.Firma.Description() + "\" />");
        #endregion

        #region Ürün Listeleme
        Listele(); 
        #endregion

        #region Kategorileri Al
        Kategoriler = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Kategoriler(DilID, 0); 
        #endregion

        #region Kategorileri Bas
        Class.Fonksiyonlar.Uygulama.Sag.Icerik.Kategoriler(Kategoriler);
        #endregion

        #region Markalari Al
        Markalar = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Markalar();
        #endregion

        #region Markalari Bas
        Class.Fonksiyonlar.Uygulama.Sag.Icerik.Markalar(Markalar);
        #endregion

        #region Etiketleri Al
        Etiketler = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Etiketler(DilID); 
        #endregion

        #region Etiketleri Bas
        Class.Fonksiyonlar.Uygulama.Sag.Icerik.Etiketler(Etiketler);
        #endregion

        #region Keywords Bas
        KeywordsBas(); 
        #endregion

        #region Sıralama Yap
        SiralamaIsleri.HadiSirala(); 
        #endregion

        #region Diğer Değişkenleri Yükle (Başlık vs. gibi)
        DigerYukle(); 
        #endregion

        #region Tanımlamalar ve Atamalar (Sorting için HyperLink ve Image)

        HyperLink link1 = (HyperLink)Page.FindControl("HyperLink1");
        HyperLink link2 = (HyperLink)Page.FindControl("HyperLink2");
        Image imaj1 = (Image)Page.FindControl("Image1");
        Image imaj2 = (Image)Page.FindControl("Image2");

        string sayfa = Request.QueryString["s"];

        if (sayfa == null)
        {
            sayfa = "1";
        }

        #endregion Tanımlamalar

        #region Sayfa Yolu
        string Yol = Class.Fonksiyonlar.Genel.MevcutSayfa().Split('?')[0];
        #endregion

        #region Ada Göre Sırala

        if (SiralamaIsleri.Kolon == "a" && SiralamaIsleri.Direktif == "D")
        {
            imaj1.ImageUrl = "~/images/arrow-bottom.png";
            link1.ToolTip = "Ürün adına göre artan olarak sırala";
            link1.NavigateUrl =  Yol + "?k=a&d=A&s=" + sayfa;
        }
        else if (SiralamaIsleri.Kolon == "a" && SiralamaIsleri.Direktif == "A")
        {
            imaj1.ImageUrl = "~/images/arrow-top.png";
            link1.ToolTip = "Ürün adına göre azalan olarak sırala";
            link1.NavigateUrl = Yol + "?k=a&d=D&s=" + sayfa;
        }
        else
        {
            imaj1.ImageUrl = "~/images/blank.gif";
            link1.ToolTip = "Ürün adına göre azalan olarak sırala";
            link1.NavigateUrl = Yol + "?k=a&d=D&s=" + sayfa;
        }

        #endregion Ada Göre Sırala

        #region Koda Göre Sırala

        if (SiralamaIsleri.Kolon == "k" && SiralamaIsleri.Direktif == "D")
        {
            imaj2.ImageUrl = "~/images/arrow-top.png";
            link2.ToolTip = "Ürün koduna göre artan olarak sırala";
            link2.NavigateUrl = Yol + "?k=k&d=A&s=" + sayfa;
        }
        else if (SiralamaIsleri.Kolon == "k" && SiralamaIsleri.Direktif == "A")
        {
            imaj2.ImageUrl = "~/images/arrow-bottom.png";
            link2.ToolTip = "Ürün koduna göre azalan olarak sırala";
            link2.NavigateUrl = Yol + "?k=k&d=D&s=" + sayfa;
        }
        else
        {
            imaj2.ImageUrl = "~/images/blank.gif";
            link2.ToolTip = "Ürün koduna göre azalan olarak sırala";
            link2.NavigateUrl = Yol + "?k=k&d=D&s=" + sayfa;
        }

        #endregion Koda Göre Sırala

        KodScriptEkle();
    }

    private void KodScriptEkle()
    {
        if (((Route)(RouteData.Route))!=null)
        {
            string kod = Class.Fonksiyonlar.Uygulama.KodScriptYaz(DilID, ((Route)(RouteData.Route)).Url);

            if (!string.IsNullOrEmpty(kod))
            {
                litkod.Text = kod;
            }
        }
    }

    private void DigerYukle()
    {
        Hyperlink1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 1);
        Hyperlink2.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 2);
        Detay = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 3);
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

        #region Ürün Kodlarını Keywordse Ekle
        Keywords.AddRange(UrunKodlari);
        #endregion

        #region Ürün Adlarını Keywordse Ekle
        Keywords.AddRange(UrunAdlari);
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

    protected void Listele()
    {
        using (BaglantiCumlesi SME = new BaglantiCumlesi())
        {
            #region SQL String
            string marka = Class.Fonksiyonlar.Firma.Marka().ToLower();
            var SQL = from p in SME.tbl_urunler
                       where p.dil_id == DilID && p.onay == true && p.anasayfa == true
                      let LKod = SME.tbl_kodlar.Where(k => k.id == p.kod_id).Select(x => x.kod).FirstOrDefault()
                      select new
                      {
                          ad = p.ad,
                          p.aciklama,
                          p.id,
                          p.on_aciklama,
                          p.resim_id,
                          kod = (LKod != null ? LKod : null),
                          marka = (LKod != null ? LKod : marka)
                      };
            #endregion

            #region Ürün Sayfa Sayısından Küçükse
            if (SQL.AsEnumerable().Count() < sayfalamasp.PageSize)
            {
                sayfalama.Visible = false;
            } 
            #endregion

            #region Siralama İşlemleri
            if (SiralamaIsleri.Direktif != null)
            {
                if (SiralamaIsleri.Direktif == "D")
                {
                    if (SiralamaIsleri.Kolon != null)
                    {
                        if (SiralamaIsleri.Kolon == "a")
                        {
                            SQL = SQL.OrderBy(n => n.ad).OrderByDescending(n => n.ad);
                        }
                        else if (SiralamaIsleri.Kolon == "k")
                        {
                            SQL = SQL.OrderBy(n => n.kod).OrderByDescending(n => n.kod);
                        }
                    }
                }
                else if (SiralamaIsleri.Direktif == "A")
                {
                    if (SiralamaIsleri.Kolon != null)
                    {
                        if (SiralamaIsleri.Kolon == "a")
                        {
                            SQL = SQL.OrderBy(n => n.ad);
                        }
                        else if (SiralamaIsleri.Kolon == "k")
                        {
                            SQL = SQL.OrderBy(n => n.kod);
                        }
                    }
                }
            } 
            #endregion

            #region Ürün Kodlarını Listeye At
            UrunKodlari = SQL.Where(x => x.kod != null).Select(x => x.kod).ToList();
            #endregion

            #region Ürün Adlarını Listeye At
            UrunAdlari = SQL.AsEnumerable().Select(x => x.ad).ToList();
            #endregion

            #region DataBind
            listeleme.DataSource = SQL;
            listeleme.DataBind(); 
            #endregion
        }
    }

    protected void listeleme_Sorting(object sender, System.Web.UI.WebControls.ListViewSortEventArgs e)
    {
        Listele();
    }
}