using System;
using System.Linq;
using Ext.Net;
using MySQLDataModel;

public partial class yonetim_Kullanici : System.Web.UI.Page
{
	string TabloAdi { get; set; }
	int KayitID { get; set; }

	protected void Page_Load(object sender, EventArgs e)
	{
		#region JS İçin Admin Root mu Değil mi?
		Class.Fonksiyonlar.JavaScript.Ekle("var AdminRoot = function(){return " + Class.Fonksiyonlar.Admin.Kullanici.Kontroller.Root(Class.Fonksiyonlar.Admin.Genel.AdminID()).ToString().ToLower() + ";};");
		#endregion

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
			#region Tablo Adı Set
			if (Request.QueryString["tablo_adi"] != null)
			{
				TabloAdi = Request.QueryString["tablo_adi"].ToString();
			}
			#endregion

			#region Kayıt ID Set
			if (Request.QueryString["kayit_id"] != null)
			{
				KayitID = int.Parse(Request.QueryString["kayit_id"].ToString());
			}
			#endregion

			Window1.AutoScroll = true;
			Window1.LabelWidth = 160;
			Veriler();
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

	protected void TextAreaEkle(string FieldLabel,string Text)
	{
		if (!string.IsNullOrEmpty(Text))
		{
			Ext.Net.TextArea TA = new TextArea();
			TA.AnchorHorizontal = "98%";
			TA.FieldLabel = FieldLabel;
			TA.Height = 100;
			TA.ReadOnly = true;
			TA.Text = Text.Trim();
			Window1.Items.Add(TA);
		}
	}

	protected void TextFieldEkle(string FieldLabel, string Text)
	{
		if (!string.IsNullOrEmpty(Text))
		{
			Ext.Net.TextField TF = new TextField();
			TF.AnchorHorizontal = "98%";
			TF.FieldLabel = FieldLabel;
			TF.ReadOnly = true;
			TF.Text = Text.Trim();
			Window1.Items.Add(TF);
		}
	}

	protected void Veriler()
	{
		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			var SQL = (from p in SME.tbl_all_http
					   where p.tablo == TabloAdi && p.kayit_id == KayitID
					   select p);

			if (SQL.Count() > 0)
			{
				try
				{
					TextFieldEkle("id", SQL.Select(x => x.id).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("tablo_adi ", SQL.Select(x => x.tablo).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("kayit_id ", SQL.Select(x => x.kayit_id).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("tarih ", SQL.Select(x => x.tarih).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("ALL_HTTP ", SQL.Select(x => x.ALL_HTTP).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("ALL_RAW ", SQL.Select(x => x.ALL_RAW).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("APPL_MD_PATH ", SQL.Select(x => x.APPL_MD_PATH).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("APPL_PHYSICAL_PATH ", SQL.Select(x => x.APPL_PHYSICAL_PATH).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("AUTH_TYPE ", SQL.Select(x => x.AUTH_TYPE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("AUTH_USER ", SQL.Select(x => x.AUTH_USER).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("AUTH_PASSWORD ", SQL.Select(x => x.AUTH_PASSWORD).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("LOGON_USER ", SQL.Select(x => x.LOGON_USER).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("REMOTE_USER ", SQL.Select(x => x.REMOTE_USER).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("CERT_COOKIE ", SQL.Select(x => x.CERT_COOKIE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("CERT_FLAGS ", SQL.Select(x => x.CERT_FLAGS).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("CERT_ISSUER ", SQL.Select(x => x.CERT_ISSUER).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("CERT_KEYSIZE ", SQL.Select(x => x.CERT_KEYSIZE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("CERT_SECRETKEYSIZE ", SQL.Select(x => x.CERT_SECRETKEYSIZE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("CERT_SERIALNUMBER ", SQL.Select(x => x.CERT_SERIALNUMBER).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("CERT_SERVER_ISSUER ", SQL.Select(x => x.CERT_SERVER_ISSUER).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("CERT_SERVER_SUBJECT ", SQL.Select(x => x.CERT_SERVER_SUBJECT).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("CERT_SUBJECT ", SQL.Select(x => x.CERT_SUBJECT).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("CONTENT_LENGTH ", SQL.Select(x => x.CONTENT_LENGTH).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("CONTENT_TYPE ", SQL.Select(x => x.CONTENT_TYPE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("GATEWAY_INTERFACE ", SQL.Select(x => x.GATEWAY_INTERFACE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("HTTPS ", SQL.Select(x => x.HTTPS).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("HTTPS_KEYSIZE ", SQL.Select(x => x.HTTPS_KEYSIZE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("HTTPS_SECRETKEYSIZE ", SQL.Select(x => x.HTTPS_SECRETKEYSIZE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("HTTPS_SERVER_ISSUER ", SQL.Select(x => x.HTTPS_SERVER_ISSUER).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextAreaEkle("HTTPS_SERVER_SUBJECT ", SQL.Select(x => x.HTTPS_SERVER_SUBJECT).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("INSTANCE_ID ", SQL.Select(x => x.INSTANCE_ID).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("INSTANCE_META_PATH ", SQL.Select(x => x.INSTANCE_META_PATH).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("LOCAL_ADDR ", SQL.Select(x => x.LOCAL_ADDR).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("PATH_INFO ", SQL.Select(x => x.PATH_INFO).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("PATH_TRANSLATED ", SQL.Select(x => x.PATH_TRANSLATED).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("QUERY_STRING ", SQL.Select(x => x.QUERY_STRING).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("REMOTE_ADDR ", SQL.Select(x => x.REMOTE_ADDR).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("REMOTE_HOST ", SQL.Select(x => x.REMOTE_HOST).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("REMOTE_PORT ", SQL.Select(x => x.REMOTE_PORT).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("REQUEST_METHOD ", SQL.Select(x => x.REQUEST_METHOD).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("SCRIPT_NAME ", SQL.Select(x => x.SCRIPT_NAME).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("SERVER_NAME ", SQL.Select(x => x.SERVER_NAME).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("SERVER_PORT ", SQL.Select(x => x.SERVER_PORT).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("SERVER_PORT_SECURE ", SQL.Select(x => x.SERVER_PORT_SECURE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("SERVER_PROTOCOL ", SQL.Select(x => x.SERVER_PROTOCOL).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("SERVER_SOFTWARE ", SQL.Select(x => x.SERVER_SOFTWARE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("URL ", SQL.Select(x => x.URL).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("HTTP_CONNECTION ", SQL.Select(x => x.HTTP_CONNECTION).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("HTTP_ACCEPT ", SQL.Select(x => x.HTTP_ACCEPT).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("HTTP_ACCEPT_CHARSET ", SQL.Select(x => x.HTTP_ACCEPT_CHARSET).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("HTTP_ACCEPT_ENCODING ", SQL.Select(x => x.HTTP_ACCEPT_ENCODING).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("HTTP_ACCEPT_LANGUAGE ", SQL.Select(x => x.HTTP_ACCEPT_LANGUAGE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("HTTP_COOKIE ", SQL.Select(x => x.HTTP_COOKIE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("HTTP_HOST ", SQL.Select(x => x.HTTP_HOST).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("HTTP_USER_AGENT", SQL.Select(x => x.HTTP_USER_AGENT).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("ÜLKE", SQL.Select(x => x.ULKE).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("ÜLKE KODU", SQL.Select(x => x.ULKE_KOD).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("ŞEHİR", SQL.Select(x => x.IL).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("ENLEM", SQL.Select(x => x.LAT).FirstOrDefault().ToString());
				}
				catch
				{
				}
				try
				{
					TextFieldEkle("BOYLAM", SQL.Select(x => x.LON).FirstOrDefault().ToString());
				}
				catch
				{
				}
			}
			else
			{
				string win = "parent.WindowT" + KayitID;
				Class.Fonksiyonlar.JavaScript.Ekle("alert('Kayıt Bulunamadı.');" + win + ".close();");
			}
		}
	}
}