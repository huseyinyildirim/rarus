using System;
using System.Linq;
using Ext.Net;
using MySQLDataModel;

public partial class yonetim_panel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        #region Oturum Kontrol
        if (!Class.Fonksiyonlar.Admin.Genel.SessionKontrol())
        {
            #region Oturum Yoksa Postala
            Response.Redirect("default.aspx?rnd=" + (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) + "&s=" + Class.Fonksiyonlar.Genel.MevcutSayfa());
            return;
            #endregion
        }
        else
        {
            #region Firma Logosu
            ImageButton1.ImageUrl = "images/logo.png";
            ImageButton1.AutoPostBack = true;
            ImageButton1.PostBackUrl = "panel.aspx?rnd=" + (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond);
            #endregion

            DateTime Giris;

            #region Son Giriş Zamanı Al
            using (BaglantiCumlesi SME = new BaglantiCumlesi())
            {
                int PID = Class.Fonksiyonlar.Admin.Genel.AdminID();
                var SQL = (from p in SME.tbl_giris_cikislar
                           where p.admin_id == PID
                           orderby p.tarih descending
                           select p.tarih).Skip(2).Take(1);

                Giris = SQL.Select(x => x.Value).FirstOrDefault();
            }
            #endregion

            #region Son Giriş Zamanından Beri Geçen Zamanı Hesapla
            DateTime Simdi = DateTime.Now;

            string sonuc = null;

            double gun = (Simdi - Giris).TotalDays;
            double saat = (Simdi.Hour - Giris.Hour);
            double dakika = (Simdi.Minute - Giris.Minute);

            if ((int)gun >= 1)
            {
                sonuc = sonuc + ((int)gun).ToString() + " gün ";
            }

            if ((int)saat >= 1)
            {
                sonuc = sonuc + ((int)saat).ToString() + " saat ";
            }

            sonuc = sonuc + ((int)dakika).ToString() + " dak. önce ";
            #endregion

            #region Son Giriş Bilgileri
            LinkButton1.Text = "Bir Önceki Giriş Zamanı : " + Giris.ToString() + " - " + sonuc;
            #endregion

            #region Hoşgeldin Olayı
            Label1.Text = "Hoşgeldin  Sn. (" + Class.Fonksiyonlar.Admin.Kullanici.Cagir.KullaniciAdi(Class.Fonksiyonlar.Admin.Genel.AdminID()) + ") " + Class.Fonksiyonlar.Admin.Kullanici.Cagir.AdSoyad(Class.Fonksiyonlar.Admin.Genel.AdminID());
            #endregion

            #region Status Bar
            if (!Class.Fonksiyonlar.Admin.Kullanici.Kontroller.Root(Class.Fonksiyonlar.Admin.Genel.AdminID()))
            {
                StatusBar1.Visible = false;
            }
            else
            {
                Label1.Visible = false;

                var SQL = (from p in Objeler.Listeler.Admin
                           where p.SessionID == Session.SessionID
                           select new { p.Tarih }).FirstOrDefault().Tarih;

                StatusBar1.Text = SQL.ToString();
                BottomLabel.Text = BottomLabel.Text + " - (" + Class.Fonksiyonlar.Admin.Kullanici.Cagir.KullaniciAdi(Class.Fonksiyonlar.Admin.Genel.AdminID()) + ") " + Class.Fonksiyonlar.Admin.Kullanici.Cagir.AdSoyad(Class.Fonksiyonlar.Admin.Genel.AdminID());
            } 
            #endregion
        }
        #endregion

        #region Icon Register Olayı
        if (!IsPostBack)
        {
            ResourceManager1.RegisterIcon(Icon.Cup);
            ResourceManager1.RegisterIcon(Icon.Table);
        }
        #endregion
    }

    #region Boş VIEWSTATE
    protected override void SavePageStateToPersistenceMedium(object viewState)
    {
    }

    protected override object LoadPageStateFromPersistenceMedium()
    {
        return null;
    }
    #endregion

    [DirectMethod]
    public void CikisYap()
    {
        Viewport1.Hide();

        #region Admin Logla
        Class.Fonksiyonlar.Admin.Log.Oturum(Class.Fonksiyonlar.Admin.Genel.AdminID(), (int)Class.Sabitler.AdminLog.Oturum.Cikis, (int)Class.Sabitler.KullaniciTip.Admin);
        #endregion

        #region Admin Session Sil
        Application.Lock();
        int index = -1;
        index = Objeler.Listeler.Admin.FindIndex(delegate(Objeler.Tanimlar.Admin p)
        {
            return (p.SessionID == Session.SessionID);
        });
        if (index != -1)
        {
            Objeler.Listeler.Admin.RemoveAt(index);
        }
        Application.UnLock();
        #endregion

        Class.Fonksiyonlar.ExtJS.YukleyerekYonlendir("default.aspx?rnd=" + (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond), "Çıkış yapılıyor...");
    }

    protected void OnlineDurumlari(object sender, DirectEventArgs e)
    {
        #region Online Kullanıcılar
        LinkButton2.Text = "Online Kullanıcı : " + Objeler.Listeler.Dil.Count;
        #endregion

        #region Online Yöneticiler
        LinkButton3.Text = "Online Yönetici : " + Objeler.Listeler.Admin.Count;
        #endregion
    }
}