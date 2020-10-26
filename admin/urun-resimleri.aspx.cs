using System;
using System.Collections;
using System.IO;
using System.Linq;
using System.Web;
using Ext.Net;
using MySQLDataModel;
using System.Data.Objects.DataClasses;

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
				Label2.Html = "İlgili resimler " + "<b><u>" + Class.Degiskenler.Site.Yollar.Urun + "</u></b>" + " klasöründen gösterilmektedir.";
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
		return Class.Fonksiyonlar.Genel.ResimleriListele(Class.Degiskenler.Site.Yollar.Urun)
			.Select(s => new
		{
			resim = s.Replace(Class.Degiskenler.Site.Yollar.Urun, ""),
			yol = s
		}).Select((p, k) => new
			{
				id = k + 1,
				size = new FileInfo(p.yol).Length,
				name = p.resim.Replace(".jpg", "").Replace(".gif", "").Replace(".png", "").Replace(".bmp", "").Replace("_", " "),
				url = "ashx/image.ashx?n=U&i=" + p.resim + "&w=80&h=80&k=t",
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
					string ResimAdi = yol.Replace(Class.Degiskenler.Site.Yollar.Urun, "");

					#region Resmi Veritabanindan Sil
					using (BaglantiCumlesi SME = new BaglantiCumlesi())
					{
						tbl_dosyalar ta = (from p in SME.tbl_dosyalar where p.ad == ResimAdi select p).FirstOrDefault();

						#region Resim Varsa DB Den Siliyoruz
						if (ta != null)
						{
							int ResimID = ta.id;
							SME.DeleteObject(ta);

							#region Admin İşlem Log
							Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ResimID, (int)Class.Sabitler.AdminLog.Islemler.Delete);
							#endregion

							SME.SaveChanges();
						} 
						#endregion
					} 
					#endregion

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
					if (!File.Exists(Class.Degiskenler.Site.Yollar.Urun + GelenDosya.FileName))
					{
						try
						{
							byte[] B = new byte[boyut];
							GelenDosya.InputStream.Read(B, 0, boyut);

							Class.Fonksiyonlar.Genel.DosyaKaydet(B, Class.Degiskenler.Site.Yollar.Urun + GelenDosya.FileName);

							using (BaglantiCumlesi SME = new BaglantiCumlesi())
							{
								string YeniKategori = DateTime.Now.Date.ToString().Substring(0, 10);
								int KategoriID;

								var SQL = (from p in SME.tbl_dosyalar_kategori
										   where p.ad == YeniKategori
										   select
										   new
										   {
											   p.id,
											   p.ad
										   });

								if (SQL.Count() > 0)
								{
									KategoriID = SQL.Select(x => x.id).FirstOrDefault();
								}
								else
								{
									#region Kategori Oluştur
									tbl_dosyalar_kategori ta1 = new tbl_dosyalar_kategori();
									ta1.ad = YeniKategori;
									ta1.admin_id_ek = Class.Fonksiyonlar.Admin.Genel.AdminID();
									SME.AddTotbl_dosyalar_kategori(ta1);
									SME.SaveChanges();

									#region Admin İşlem Log
									Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta1)).EntityKey.EntitySetName.ToString(), ta1.id, (int)Class.Sabitler.AdminLog.Islemler.Insert);
									#endregion

									KategoriID = ta1.id;
									#endregion
								}

								#region Dosya Kaydet
								tbl_dosyalar ta2 = new tbl_dosyalar();
								ta2.tip = (int)Class.Sabitler.Dosya.Resim;
								//ta2.kategori_id = KategoriID;
								ta2.ad = Class.Fonksiyonlar.Genel.SQLTemizle(GelenDosya.FileName);
								ta2.admin_id_ek = Class.Fonksiyonlar.Admin.Genel.AdminID();
								ta2.onay = false;
								SME.AddTotbl_dosyalar(ta2);
								SME.SaveChanges();

								#region Admin İşlem Log
								Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta2)).EntityKey.EntitySetName.ToString(), ta2.id, (int)Class.Sabitler.AdminLog.Islemler.Insert);
								#endregion 
								#endregion
							}

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