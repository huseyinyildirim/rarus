using System;
using System.Data.Objects.DataClasses;
using System.Linq;
using Ext.Net;
using MySQLDataModel;

public partial class yonetim_Kullanici : System.Web.UI.Page
{
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
			//Veriler();
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

	protected void Veriler(object sender, DirectEventArgs e)
	{
		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			var SQL = (from p in SME.tbl_sbt_firma
					   where p.id == 1
					   select p);

			#region Firma Bilgileri
			TextAreaUnvan.Text = SQL.Select(x => x.unvan).FirstOrDefault();
			TextFieldFirma.Text = SQL.Select(x => x.firma).FirstOrDefault();
			TextFieldMarka.Text = SQL.Select(x => x.marka).FirstOrDefault();
			TextFieldDomain.Text = SQL.Select(x => x.domain).FirstOrDefault();
			TextFieldMail.Text = SQL.Select(x => x.mail).FirstOrDefault();
			TextAreaDescription.Text = SQL.Select(x => x.description).FirstOrDefault();
			TextAreaTitle.Text = SQL.Select(x => x.title).FirstOrDefault(); 
			#endregion

			#region Google Analytics
			TextAreaGoogleAnalytics.Html = SQL.Select(x => x.google_analytics).FirstOrDefault();
			#endregion

			#region Google Doğrulama Kodu
			TextAreaGoogleDogrulamaKodu.Text = SQL.Select(x => x.google_dogrulama_kodu).FirstOrDefault();
			#endregion

			#region Sosyal Ağlar
			TextFieldFlickr_ID.Text = SQL.Select(x => x.flickr).FirstOrDefault();

			TextFieldYoutube_ID.Text = SQL.Select(x => x.youtube).FirstOrDefault();
			TextFieldVimeo_ID.Text = SQL.Select(x => x.vimeo).FirstOrDefault();

			TextFieldFacebook_ID.Text = SQL.Select(x => x.facebook).FirstOrDefault();
			TextFieldGooglePlus_ID.Text = SQL.Select(x => x.google_plus).FirstOrDefault();

			TextFieldTwitter_ID.Text = SQL.Select(x => x.twitter).FirstOrDefault(); 
			#endregion
		}
	}

	protected void Guncelle(object sender, DirectEventArgs e)
	{
		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			tbl_sbt_firma ta = (from p in SME.tbl_sbt_firma where p.id == 1 select p).FirstOrDefault();

			if (TextAreaUnvan.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextAreaUnvan.Text.Trim())))
				{
					ta.unvan = Class.Fonksiyonlar.Genel.SQLTemizle(TextAreaUnvan.Text.Trim());
				}
			}

			if (TextFieldFirma.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldFirma.Text.Trim())))
				{
					ta.firma = Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldFirma.Text.Trim());
				}
			}

			if (TextFieldMarka.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldMarka.Text.Trim())))
				{
					ta.marka = Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldMarka.Text.Trim());
				}
			}

			if (TextFieldDomain.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldDomain.Text.Trim())))
				{
					ta.domain = Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldDomain.Text.Trim());
				}
			}

			if (TextFieldMail.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldMail.Text.Trim())))
				{
					ta.mail = Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldMail.Text.Trim());
				}
			}

			if (TextAreaDescription.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextAreaDescription.Text.Trim())))
				{
					ta.description = Class.Fonksiyonlar.Genel.SQLTemizle(TextAreaDescription.Text.Trim());
				}
			}

			if (TextAreaTitle.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextAreaTitle.Text.Trim())))
				{
					ta.title = Class.Fonksiyonlar.Genel.SQLTemizle(TextAreaTitle.Text.Trim());
				}
			}

			if (TextAreaGoogleAnalytics.Text != null)
			{
				if (!string.IsNullOrEmpty(TextAreaGoogleAnalytics.Text.Trim()))
				{
					ta.google_analytics = TextAreaGoogleAnalytics.Text.Trim().Replace(@"'", "\'");
				}
				else
				{
					ta.google_analytics = null;
				}
			}

			if (TextAreaGoogleDogrulamaKodu.Text != null)
			{
				if (!string.IsNullOrEmpty(TextAreaGoogleDogrulamaKodu.Text.Trim()))
				{
					ta.google_dogrulama_kodu = TextAreaGoogleDogrulamaKodu.Text.Trim().Replace(@"'", "\'");
				}
				else
				{
					ta.google_dogrulama_kodu = null;
				}
			}

			if (TextFieldFlickr_ID.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldFlickr_ID.Text.Trim())))
				{
					ta.flickr = Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldFlickr_ID.Text.Trim());
				}
				else
				{
					ta.flickr = null;
				}
			}

			if (TextFieldYoutube_ID.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldYoutube_ID.Text.Trim())))
				{
					ta.youtube = Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldYoutube_ID.Text.Trim());
				}
				else
				{
					ta.youtube = null;
				}
			}

			if (TextFieldVimeo_ID.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldVimeo_ID.Text.Trim())))
				{
					ta.vimeo = Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldVimeo_ID.Text.Trim());
				}
				else
				{
					ta.vimeo = null;
				}
			}

			if (TextFieldFacebook_ID.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldFacebook_ID.Text.Trim())))
				{
					ta.facebook = Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldFacebook_ID.Text.Trim());
				}
				else
				{
					ta.facebook = null;
				}
			}

			if (TextFieldGooglePlus_ID.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldGooglePlus_ID.Text.Trim())))
				{
					ta.google_plus = Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldGooglePlus_ID.Text.Trim());
				}
				else
				{
					ta.google_plus = null;
				}
			}

			if (TextFieldTwitter_ID.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldTwitter_ID.Text.Trim())))
				{
					ta.twitter = Class.Fonksiyonlar.Genel.SQLTemizle(TextFieldTwitter_ID.Text.Trim());
				}
				else
				{
					ta.twitter = null;
				}
			}

			ta.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();
			SME.SaveChanges();

			#region Admin İşlem Log
			Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ta.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
			#endregion

			Response.Redirect(Class.Fonksiyonlar.Genel.MevcutSayfa());
		}
	}
}