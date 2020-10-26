using System;
using System.Linq;
using System.Text;
using MySQLDataModel;
using System.Web.Routing;
using System.Web;

public partial class contact : System.Web.UI.Page
{
	public int DilID;

	#region Boş VIEWSTATE
	protected override void SavePageStateToPersistenceMedium(object viewState)
	{
	}

	protected override object LoadPageStateFromPersistenceMedium()
	{
		return null;
	}
	#endregion

	protected void Page_Load(object sender, EventArgs e)
	{
		Adresler();

		DilID = Class.Fonksiyonlar.Dil.ID();

		#region Description Metatag
		Class.Fonksiyonlar.UserKontrol.HeaderText("sitil", "description", "<meta http-equiv=\"Description\" content=\"" + Class.Fonksiyonlar.Firma.Description() + "\" />");
		#endregion

		#region Başlık Sol

		#region Sol Başlık Visibility
		Class.Fonksiyonlar.UserKontrol.ElemanGizle(0, "basliklar", "baslik_sol", true);
		#endregion

		Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sol", "<h1><img id=\"arrow1\" src=\"/images/arrow.png\" alt=\"\" class=\"arr\"/> " + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 20) + "</h1>");

		#endregion

		#region Başlık Sağ

		#region Sağ Başlık Visibility
		Class.Fonksiyonlar.UserKontrol.ElemanGizle(0, "basliklar", "baslik_sag", true);
		#endregion

		#region Başlık Text
		StringBuilder SB = new StringBuilder();
		SB.Append("<!--SAG BASLIK-->\r\n");
		SB.Append("<div id=\"basr\"><h1><img id=\"mail1\" src=\"/images/icon/email.png\" alt=\"\" class=\"icon\"/> " + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 9) + "</h1></div>\r\n");
		SB.Append("<!--SAG BASLIK-->\r\n");
		#endregion

		Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sag", SB.ToString());

		#endregion

		h1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 10);
		p.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 15);
		s1.InnerText = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 11);
		s2.InnerText = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 12);
		s3.InnerText = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 13);
		s4.InnerText = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 14);
		gonder.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 18);
		h2.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 19);

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

	protected void gonder_Click(object sender, EventArgs e)
	{
		if (Page.IsValid)
		{
			try
			{
				using (BaglantiCumlesi SME = new BaglantiCumlesi())
				{
					tbl_iletisimler ta = new tbl_iletisimler();
					ta.ad_soyad = HttpUtility.HtmlEncode(Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["textname"].ToString()));
					ta.mail = HttpUtility.HtmlEncode(Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["textmail"].ToString()));
					ta.telefon = HttpUtility.HtmlEncode(Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["texttel"].ToString()));
					ta.gorusler = HttpUtility.HtmlEncode(Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["textcom"].ToString().Replace("\r\n", "<br/>" + Class.Degiskenler.Diger.vbCrLf)));
					SME.AddTotbl_iletisimler(ta);
					SME.SaveChanges();

					Class.Fonksiyonlar.Admin.Log.AllHttp("tbl_iletisimler", ta.id);

					#region Mail Bilgilerini Al
					string KullaniciAdi, Sifre, Host;
					int Port;
					Class.Fonksiyonlar.Genel.Mail.Bilgiler(out KullaniciAdi, out Sifre, out Host, out Port); 
					#endregion
					#region Mail Gönder
					Class.Fonksiyonlar.Genel.Mail.Gonder(KullaniciAdi, Sifre, Host, Port, Class.Fonksiyonlar.Firma.Mail(), null, null, Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["textmail"].ToString()), Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["textname"].ToString()), Class.Fonksiyonlar.Firma.Marka() + " - İLETİŞİM", Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["textcom"].ToString().Replace("\r\n", "<br/>")), true); 
					#endregion
				}

				textname.Text = null;
				textmail.Text = null;
				texttel.Text = null;
				textcom.Text = null;

				Class.Fonksiyonlar.JavaScript.Ekle("alert('" + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 37) + "')");
			}
			catch
			{
			}
		}
		else
		{
			textname.Text = Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["textname"].ToString());
			textmail.Text = Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["textmail"].ToString());
			texttel.Text = Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["texttel"].ToString());
			textcom.Text = Class.Fonksiyonlar.Genel.SQLTemizle(Request.Form["textcom"].ToString());

			Class.Fonksiyonlar.JavaScript.Ekle("alert('" + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 36) + "')");
		}
	}

	protected void Adresler()
	{
		string AdresL1 = "<li>\r\n<h4><img alt=\"{0}\" src=\"/images/flag/{1}\"/><span>{0}</span></h4>\r\n<p>{2}<a href=\"{3}\" target=\"_blank\"><img class=\"icon\" alt=\"\" src=\"/images/icon/map.png\"/></a></p>\r\n</li>\r\n" + Class.Degiskenler.Diger.vbCrLf;
		string AdresL2 = "<li>\r\n<h4><img alt=\"{0}\" src=\"/images/flag/{1}\"/><span>{0}</span></h4>\r\n<p>{2}</p>\r\n</li>\r\n" + Class.Degiskenler.Diger.vbCrLf;

		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			var SQL = (from p in SME.tbl_firma_adresler
					   where p.firma_id == 1 && p.onay == true
					   orderby p.sira ascending
					   select new
					   {
						   p.baslik,
						   p.ikon,
						   p.adres,
						   p.harita_url,
						   ulke = SME.tbl_sbt_ulke.Where(k => k.id == p.ulke_id).Select(x => x.ad).FirstOrDefault(),
					   });

			if (SQL.AsEnumerable().Count() > 0)
			{
				StringBuilder SB1 = new StringBuilder();
				StringBuilder SB2 = new StringBuilder();

				foreach (var i in SQL)
				{
					#region Harita URL Boş Değilse
					if (i.harita_url != null)
					{
						SB1.AppendFormat(AdresL1, i.ulke.ToUpper() + (i.baslik != null ? " " + i.baslik.ToUpper() : null), i.ikon, i.adres, (i.harita_url != null ? i.harita_url.ToLower().Replace("&", "&amp;") : null));
					} 
					#endregion
					#region Harita URL Boşsa
					else
					{
						SB1.AppendFormat(AdresL2, i.ulke.ToUpper() + (i.baslik != null ? " " + i.baslik.ToUpper() : null), i.ikon, i.adres);
					} 
					#endregion
				}

				SB2.Append("<ul id=\"adresmenu\">" + Class.Degiskenler.Diger.vbCrLf);
				SB2.Append(SB1.ToString());
				SB2.Append("</ul>");

				AdresLit.Text = SB2.ToString();
			}
		}
	}
}