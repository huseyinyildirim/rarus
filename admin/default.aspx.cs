using System;
using Ext.Net;

public partial class yonetim_default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //Response.Write(Class.Fonksiyonlar.Genel.Sifrele("q"));

        #region Oturum Varsa Panele Yönlendir
        if (Class.Fonksiyonlar.Admin.Genel.SessionKontrol())
        {
            Response.Redirect("panel.aspx?rnd=" + (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond));
            return;
        } 
        #endregion

        #region Icon Register Olayı
        if (!IsPostBack)
        {
            ResourceManager1.RegisterIcon(Icon.Cup);
            ResourceManager1.RegisterIcon(Icon.Error);
        }
        #endregion

        #region Tarayıcı IE ise Uyarı Ver
        if (!IsPostBack)
        {
            if (Request.Browser.Browser == "IE")
            {
                Notification.Show(new NotificationConfig
                {
                    Icon = Ext.Net.Icon.Error,
                    Title = "Tarayıcı Uyarısı",
                    Width = 300,
                    Height = 160,
                    BodyStyle = "background:#fff",
                    BringToFront = true,

                    AlignCfg = new NotificationAlignConfig
                    {
                        ElementAnchor = AnchorPoint.TopRight,
                        TargetAnchor = AnchorPoint.TopRight,
                        OffsetX = -20,
                        OffsetY = 20
                    },

                    ShowFx = new SlideIn { Anchor = AnchorPoint.TopRight, Options = new FxConfig { Easing = Easing.BounceIn } },
                    HideFx = new Ghost { Anchor = AnchorPoint.TopRight, Options = new FxConfig { Duration = 3600 } },
                    Html = "<p style=\"padding:5px;text-align:left\">Sayın yönetici; <br/><br/>Yönetici panelinin en iyi şekilde görüntülenebilmesi, daha hızlı bir biçimde gezilebilmesi ve işlemlerinizi sorunsuz bir biçimde gerçekleştirebilmeniz için <a target=\"_blank\" href=\"http://www.mozilla-europe.org/tr\"><b>Mozilla Firefox</b></a>, <a target=\"_blank\" href=\"http://www.opera.com/download\"><b>Opera</b></a>, <a target=\"_blank\" href=\"http://www.google.com/chrome/index.html?hl=tr\"><b>Chrome</b></a>, <a target=\"_blank\" href=\"http://www.apple.com/safari\"><b>Safari</b></a> tarayıcılarından herhangi birini kullanmanızı tavsiye etmekteyiz.<br/><br/>Anlayışınız için teşekkür ederiz.</p>"
                });
            }
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

    #region Genel Fonksiyonlar

    protected void GirisYap(object sender, DirectEventArgs e)
    {
        KullaniciAdiKontrol();
    }

    #endregion

    #region Benim Yazdıklarım

    protected void KullaniciAdiKontrol()
    {
        if (Class.Fonksiyonlar.Admin.Kullanici.Kontroller.KullaniciAdi(Class.Fonksiyonlar.Genel.SQLTemizle(txtUsername.Text.Trim())))
        {
            OnayKontrol();
        }
        else
        {
            #region Admin Hata Log
            Class.Fonksiyonlar.Admin.Log.Hatalar(null, Class.Fonksiyonlar.Genel.SQLTemizle(txtUsername.Text.Trim()), (int)Class.Sabitler.AdminLog.Hatalar.KullaniciYok, (int)Class.Sabitler.KullaniciTip.Admin); 
            #endregion

            Class.Fonksiyonlar.ExtJS.MesajKutusu(Icon.Error, MessageBox.Icon.ERROR, "Hatalı Kullanıcı Adı", "Kullanıcı adı bulunamadı.<br/>Lütfen kullanıcı adınızı kontrol ederek yeniden yazınız.");
        }
    }

    protected void OnayKontrol()
    {
        if (Class.Fonksiyonlar.Admin.Kullanici.Kontroller.Onay(Class.Fonksiyonlar.Genel.SQLTemizle(txtUsername.Text.Trim())))
        {
            SifreKontrol();  
        }
        else
        {
            #region Admin Hata Log
            Class.Fonksiyonlar.Admin.Log.Hatalar(null, Class.Fonksiyonlar.Genel.SQLTemizle(txtUsername.Text.Trim()), (int)Class.Sabitler.AdminLog.Hatalar.OnayYok, (int)Class.Sabitler.KullaniciTip.Admin);
            #endregion

            Class.Fonksiyonlar.ExtJS.MesajKutusu(Icon.Error, MessageBox.Icon.ERROR, "Aktif Olmayan Kullanıcı", "İlgili kullanıcı aktif olmadığı için giriş yapamaz!");
        }
    }

    protected void SifreKontrol()
    {
        if (Class.Fonksiyonlar.Admin.Kullanici.Kontroller.Sifre(Class.Fonksiyonlar.Genel.SQLTemizle(txtUsername.Text.Trim()), Class.Fonksiyonlar.Admin.Genel.SifreOlustur(Class.Fonksiyonlar.Genel.SQLTemizle(txtPassword.Text.Trim()))))
        {
            #region Admin Session Ver
            Application.Lock();
            if (!Class.Fonksiyonlar.Admin.Genel.SessionKontrol())
            {
                Objeler.Tanimlar.Admin D = new Objeler.Tanimlar.Admin();
                D.ID = Class.Fonksiyonlar.Admin.Kullanici.Cagir.ID(Class.Fonksiyonlar.Genel.SQLTemizle(txtUsername.Text.Trim()));
                D.Root = Class.Fonksiyonlar.Admin.Kullanici.Kontroller.Root(D.ID);
                D.SessionID = Session.SessionID;
                D.Tarih = DateTime.Now;
                D.IP = Request.ServerVariables["REMOTE_ADDR"];
                Objeler.Listeler.Admin.Add(D);
            }
            Application.UnLock(); 
            #endregion 

            #region Admin Logla
            Class.Fonksiyonlar.Admin.Log.Oturum(Class.Fonksiyonlar.Admin.Genel.AdminID(), (int)Class.Sabitler.AdminLog.Oturum.Giris, (int)Class.Sabitler.KullaniciTip.Admin);
            #endregion

            Window1.Hide();

            if (Request.QueryString["s"] != null)
            {
                Class.Fonksiyonlar.ExtJS.YukleyerekYonlendir(Request.QueryString["s"].ToString(), "Geldiğiniz sayfaya yönlendiriliyorsunuz");
            }
            else
            {
                Class.Fonksiyonlar.ExtJS.YukleyerekYonlendir("panel.aspx?rnd=" + (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond), "Kontrol paneli yükleniyor");
            }
        }
        else
        {
            #region Admin Hata Log
            Class.Fonksiyonlar.Admin.Log.Hatalar(null, Class.Fonksiyonlar.Genel.SQLTemizle(txtUsername.Text.Trim()), (int)Class.Sabitler.AdminLog.Hatalar.SifreYanlis, (int)Class.Sabitler.KullaniciTip.Admin);
            #endregion

            Class.Fonksiyonlar.ExtJS.MesajKutusu(Icon.Error, MessageBox.Icon.ERROR, "Hatalı Şifre", "Eksik veya yanlış şifre girdiniz.<br/>Lütfen şifrenizi kontrol ederek yeniden deneyiniz.");
        }
    }

    #endregion
}