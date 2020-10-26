using System;
using System.Collections;
using System.IO;
using System.Linq;
using System.Web;
using Ext.Net;

public partial class yonetim_dosyalar2 : System.Web.UI.Page
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
			#region Verileri Listeleme
			if (!X.IsAjaxRequest)
			{
				VerileriGetir();
				Label2.Html = "İlgili resimler " + "<b><u>" + Class.Degiskenler.Site.Yollar.Bayrak + "</u></b>" + " klasöründen gösterilmektedir.";
			}
			#endregion
		}
		#endregion

		#region Icon Register Olayı
		if (!IsPostBack)
		{
			ResourceManager1.RegisterIcon(Icon.Error);
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

	#region Benim Yazdıklarım

	protected void HataMesaji(string hata)
	{
		Class.Fonksiyonlar.ExtJS.MesajKutusu(Icon.Error, MessageBox.Icon.ERROR, "İşlem başarısız", hata);
	}

	protected IEnumerable ResimleriGetir()
	{
		return Class.Fonksiyonlar.Genel.ResimleriListele(Class.Degiskenler.Site.Yollar.Bayrak)
			.Select(s => new
		{
			resim = s.Replace(Class.Degiskenler.Site.Yollar.Bayrak, ""),
			yol = s
		}).Select((p, k) => new
			{
				id = k + 1,
				size = new FileInfo(p.yol).Length,
				name = p.resim.Replace(".jpg", "").Replace(".gif", "").Replace(".png", "").Replace(".bmp", "").Replace("_", " "),
				url = "ashx/image.ashx?n=B&i=" + p.resim + "&w=80&h=80&k=t",
				p.yol,
				p.resim,
			}).AsEnumerable();
	}

	#endregion

	#region Genel Fonksiyonlar

	protected void VerileriGetir()
	{
		Store1.DataSource = ResimleriGetir();
		Store1.DataBind();
	}

	protected void KayitlariYenile(object sender, StoreRefreshDataEventArgs e)
	{
		VerileriGetir();
	}

	public void YoneticiAdiYaz(Observable sender)
	{
		YoneticiAdi.Html = "(" + Class.Fonksiyonlar.Admin.Kullanici.Cagir.KullaniciAdi(Class.Fonksiyonlar.Admin.Genel.AdminID()) + ") " + "<b>" + Class.Fonksiyonlar.Admin.Kullanici.Cagir.AdSoyad(Class.Fonksiyonlar.Admin.Genel.AdminID()) + "</b>";
	} 

	#endregion

	#region Silme İşlemleri

	protected void SecilenleriSil(object sender, DirectEventArgs e)
	{
		if (ImageView.SelectedRecordID != "")
		{
			try
			{
				foreach (SelectedRow row in ImageView.SelectedRows)
				{
					var SQL = ResimleriGetir().Cast<object>().ToList();
					string yol = SQL[int.Parse(row.RecordID) - 1].ToString().Trim().Substring(SQL[int.Parse(row.RecordID) - 1].ToString().Trim().IndexOf(", yol = "), SQL[int.Parse(row.RecordID) - 1].ToString().Trim().IndexOf(", resim = ") - SQL[int.Parse(row.RecordID) - 1].ToString().Trim().IndexOf(", yol = ")).Replace(", yol = ", "");
					File.Delete(yol);
				}
			}
			catch
			{
				ImageView.SelectedRows.Clear();
				ImageView.UpdateSelection();
				VerileriGetir();
			}

			ImageView.SelectedRows.Clear();
			ImageView.UpdateSelection();
			VerileriGetir();
		}
		else
		{
			ImageView.SelectedRows.Clear();
			ImageView.UpdateSelection();
		}
	} 

	#endregion

	#region Seçim Temizleme

	protected void SecimiTemizle(object sender, DirectEventArgs e)
	{
		ImageView.SelectedRows.Clear();
		ImageView.UpdateSelection();
	} 

	#endregion

	#region Dosya Yükleme İşlemleri

	protected void DosyaYuklemeEkraniGetir(object sender, EventArgs e)
	{
		WindowResimYukle.Show();
	}

	public void DosyaGonderClick(object sender, DirectEventArgs e)
	{
		if (gonderilecek_dosya.PostedFile.FileName.Trim() != "")
		{
			DosyaGonder();
		}
		else
		{
			HataMesaji("İlgili dosya yüklenemedi!<br/>Lütfen yeniden deneyiniz.");
			return;
		}
	}

	protected void DosyaGonder()
	{
		HttpPostedFile GelenDosya = gonderilecek_dosya.PostedFile;
		string uzanti = GelenDosya.FileName.Split(new Char[] { '.' })[GelenDosya.FileName.Split(new Char[] { '.' }).Length - 1];
		//string dosya_adi = GelenDosya.FileName.Substring(0, GelenDosya.FileName.Length - uzanti.Length - 1);
		//string mime_type = GelenDosya.ContentType;
		int boyut = GelenDosya.ContentLength;

		if (boyut > 1)
		{
			if (uzanti == "jpg" || uzanti == "gif" || uzanti == "bmp" || uzanti == "png")
			{
				if (boyut < 2201600)
				{
					if (!File.Exists(Class.Degiskenler.Site.Yollar.Bayrak + GelenDosya.FileName))
					{
						try
						{
							byte[] B = new byte[boyut];
							GelenDosya.InputStream.Read(B, 0, boyut);
							Class.Fonksiyonlar.Genel.DosyaKaydet(B, Class.Degiskenler.Site.Yollar.Bayrak + GelenDosya.FileName);
							WindowResimYukle.Hide();
							VerileriGetir();
						}
						catch (Exception ex)
						{
							HataMesaji("Bir iç hata oluştu.<br/>" + ex.Message);
							return;
						}
					}
					else
					{
						HataMesaji("Bu isimde bir dosya zaten var!<br/>Lütfen ilgili dosyanın adını değiştirerek yeniden deneyiniz.");
						return;
					}
				}
				else
				{
					HataMesaji("Dosya boyutu 2 MB den fazla olamaz.<br/>Lütfen yeniden deneyiniz.");
					return;
				}
			}
			else
			{
				HataMesaji("Yalnızca jpg, gif, bmp, png gibi resim dosyalarını yükleyebilirsiniz.<br/>Lütfen yeniden deneyiniz.");
				return;
			}
		}
		else
		{
			HataMesaji("İlgili dosya yüklenemedi!<br/>Lütfen yeniden deneyiniz.");
			return;
		}
	}

	#endregion
}