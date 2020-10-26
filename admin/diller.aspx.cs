﻿using System;
using System.Collections;
using System.Collections.ObjectModel;
using System.Data.Objects.DataClasses;
using System.Linq;
using System.Linq.Dynamic;
using System.Text;
using Ext.Net;
using LinqToCache;
using MySQLDataModel;
using System.Web;

public partial class yonetim_Kullanici : System.Web.UI.Page
{
	RowSelectionModel RSM;
	string SayfaAdi { get; set; }
	bool CacheOlayi { get; set; }

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
			#region JS İçin İkon Yolu
			Class.Fonksiyonlar.JavaScript.Ekle("var IkonYolu = \"" + Class.Degiskenler.Site.Yollar.Bayrak.Replace(@"\", "\\\\") + "\";");
			#endregion

			#region Sayfa Adını Al
			SayfaAdi = Request.Url.LocalPath.Split('/')[Request.Url.LocalPath.Split('/').Count() - 1].Replace(Request.CurrentExecutionFilePathExtension, "");
			#endregion

			#region Row Selection Modeli
			RSM = GridPanel1.SelectionModel.Primary as RowSelectionModel;
			#endregion

			#region Icon Register Olayı
			if (!IsPostBack)
			{
				ResourceManager1.RegisterIcon(Icon.Cancel);
				ResourceManager1.RegisterIcon(Icon.Information);
				ResourceManager1.RegisterIcon(Icon.Error);
			}
			#endregion

			#region Veri Cacheden Mi Gelecek?
			if (Request.QueryString["cache"] != null)
			{
				if (Request.QueryString["cache"].ToString().Trim() == "ok")
				{
					CacheOlayi = true;
				}
			} 
			#endregion
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

	protected IEnumerable BayraklariGetir()
	{
		return (from p in Class.Fonksiyonlar.Genel.ResimleriListele(Class.Degiskenler.Site.Yollar.Bayrak)
				select new { ad = p.Replace(Class.Degiskenler.Site.Yollar.Bayrak, "") }).AsEnumerable();
	}

	[DirectMethod]
	public void IISRESET()
	{
		try
		{
			HttpRuntime.UnloadAppDomain();
			Response.Redirect(Class.Fonksiyonlar.Genel.MevcutSayfa());
		}
		catch (Exception ex)
		{
			HataMesaji("Bir iç hata oluştu.<br/>" + ex.Message);
		}
	}

	protected void StoreDoldurUlke(Store StoreAdi)
	{
		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			var SQL1 = (from p in SME.tbl_sbt_ulke
						where p.id != 999
						select new
						{
							p.id,
							ad = (p.dil_kisaltma == null ? p.kisaltma : p.dil_kisaltma) + " - " + p.ad
						}).OrderBy(p => p.ad);

			StoreAdi.DataSource = SQL1;
			StoreAdi.DataBind();
		}
	}

	#endregion

	#region Genel Fonksiyonlar

	protected void Veriler(int Baslangic, int Bitis, string s, string Kolon, string AscDesc, out IList Sonuc1, out IList Sonuc2)
	{
		#region Çalışan Hali
		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			try
			{
				#region Kolon Sorting Ayarı
				string KolonAdi = null;
				switch (Kolon)
				{
					#region Admin
					case "ekleyen":
						Kolon = "admin_id_ek";
						KolonAdi = Kolon;
						break;
					#endregion

					#region İşlem
					case "guncelleyen":
						Kolon = "admin_id_gun";
						KolonAdi = Kolon;
						break;
					#endregion
				}
				#endregion

				#region İlk SQL - SONUÇ 1

				#region İlk (Ham) SQL
				var SQL1 = (from p in SME.tbl_diller
							select new
							{
								p.ulke_id,
								p.id,
								p.dil,
								p.kodlama,
								p.ikon,
								p.sira,
								p.tarih_ek,
								p.tarih_gun,
								p.admin_id_ek,
								p.admin_id_gun,
								p.ana_dil,
								p.onay
							});
				#endregion

				#region SQL i Cache 'e Atma
				//CachedQueryOptions CQO = new CachedQueryOptions();
				var SQL2 = (CacheOlayi ? SQL1.AsCached(SayfaAdi).AsQueryable().OrderBy(Kolon + " " + AscDesc).ToList() : SQL1.AsQueryable().OrderBy(Kolon + " " + AscDesc).ToList());
				#endregion

				#region Sonuç 1
				Sonuc1 = SQL2;
				#endregion

				#endregion

				#region İlk SQL in Ccount ı Sıfırdan Büyükse Filtreleme Yap
				if (SQL2.Count() > 0)
				{
					#region Filtreleme
					if (!string.IsNullOrEmpty(s))
					{
						FilterConditions FC = new FilterConditions(s);

						foreach (FilterCondition FCO in FC.Conditions)
						{
							Comparison C = FCO.Comparison;
							FilterType FT = FCO.FilterType;

							#region Kolon Adı Boşsa Değer Ver
							if (string.IsNullOrEmpty(KolonAdi))
							{
								KolonAdi = FCO.Name;
							}
							#endregion

							#region Gelen Değerler
							object value;
							#endregion

							switch (FCO.FilterType)
							{
								#region Filtre Tipi Bool İse
								case FilterType.Boolean:
									value = FCO.ValueAsBoolean;
									break;
								#endregion

								#region Filtre Tipi Date İse
								case FilterType.Date:
									value = FCO.ValueAsDate;
									break;
								#endregion

								#region Filtre Tipi Liste İse
								case FilterType.List:
									value = FCO.ValuesList;
									break;
								#endregion

								#region Filtre Tipi Nümerik İse
								case FilterType.Numeric:
									if (SQL2.Count() > 0 && (SQL2[0].GetType().GetProperty(KolonAdi).PropertyType == typeof(int) || SQL2[0].GetType().GetProperty(KolonAdi).PropertyType == typeof(Int16) || SQL2[0].GetType().GetProperty(KolonAdi).PropertyType == typeof(Int32) || SQL2[0].GetType().GetProperty(KolonAdi).PropertyType == typeof(Int64) || SQL2[0].GetType().GetProperty(KolonAdi).PropertyType == typeof(Nullable<int>) || SQL2[0].GetType().GetProperty(KolonAdi).PropertyType == typeof(Nullable<Int16>) || SQL2[0].GetType().GetProperty(KolonAdi).PropertyType == typeof(Nullable<Int32>) || SQL2[0].GetType().GetProperty(KolonAdi).PropertyType == typeof(Nullable<Int64>)))
									{
										value = FCO.ValueAsInt;
									}
									else
									{
										value = FCO.ValueAsDouble;
									}
									break;
								#endregion

								#region Filtre Tipi String İse
								case FilterType.String:
									value = FCO.Value;
									break;
								#endregion

								#region Switch Default
								default:
									throw new ArgumentOutOfRangeException();
								#endregion
							}

							SQL2.RemoveAll(item =>
							{
								object o = item.GetType().GetProperty(KolonAdi).GetValue(item, null);
								IComparable IC = o as IComparable;

								switch (C)
								{
									case Comparison.Eq:

										switch (FT)
										{
											#region Filtre Tipi Liste İse
											case FilterType.List:
												return !(value as ReadOnlyCollection<string>).Contains(o.ToString());
											#endregion

											#region Filtre Tipi String İse
											case FilterType.String:
												return !o.ToString().StartsWith(value.ToString());
											#endregion

											#region Switch Default
											default:
												return !IC.Equals(value);
											#endregion
										}

									case Comparison.Gt:
										return IC.CompareTo(value) < 1;

									case Comparison.Lt:
										return IC.CompareTo(value) > -1;

									#region Switch Default
									default:
										throw new ArgumentOutOfRangeException();
									#endregion
								}
							});
						}
					}
					#endregion
				}
				#endregion

				#region SQL İçeriğini Değiştirme
				var SQL3 = SQL2.Skip(Baslangic).Take(Bitis).Select(p => new
				{
					p.id,
					p.ulke_id,
					p.dil,
					p.kodlama,
					p.ikon,
					p.sira,
					p.tarih_ek,
					p.tarih_gun,
					p.admin_id_ek,
					p.admin_id_gun,
					ekleyen = (p.admin_id_ek != null ? SME.tbl_adminler.Where(k => k.id == p.admin_id_ek).Select(x => "(" + x.kullanici_adi + ") " + x.ad_soyad).FirstOrDefault() : null),
					guncelleyen = (p.admin_id_gun != null ? SME.tbl_adminler.Where(k => k.id == p.admin_id_gun).Select(x => "(" + x.kullanici_adi + ") " + x.ad_soyad).FirstOrDefault() : null), 
					ikon2 = Class.Degiskenler.Site.Yollar.Bayrak + p.ikon,
					ulke = SME.tbl_sbt_ulke.Where(k => k.id == p.ulke_id).Select(x => x.ad).FirstOrDefault(),
					ana_dil = (p.ana_dil ? "EVET" : "HAYIR"),
					onay = (p.onay ? "EVET" : "HAYIR")
				}).AsEnumerable().Cast<object>().ToList();
				#endregion

				#region Sonuç 2
				Sonuc2 = SQL3;
				#endregion
			}
			catch
			{
				#region Boş Değer Döndür
				Sonuc1 = null;
				Sonuc2 = null;
				#endregion
			}
		}

		#endregion
	}

	protected void KayitlariYenile(object sender, StoreRefreshDataEventArgs e)
	{
		#region Filtre Değişkeni
		string s = e.Parameters[GridFilters1.ParamPrefix];
		#endregion

		#region Kolon Sorting
		string Kolon = null;

		if (e.Sort != "Default")
		{
			Kolon = e.Sort;
		}
		#endregion

		#region Kolon Short Direction
		string AscDesc = null;

		if (!string.IsNullOrEmpty(e.Dir.ToString()))
		{
			AscDesc = e.Dir.ToString();
		}
		#endregion

		#region Sayfalama Başlangıcı
		int PS = e.Start;
		#endregion

		#region Sayfalama Limiti
		int PL = e.Limit;
		#endregion

		#region Toplam ve Liste Değişkenleri
		IList L1; //İlk Sonuç
		IList L2; //İkinci Sonuç
		#endregion

		#region Verileri Çek
		Veriler(PS, PL, s, Kolon, AscDesc, out L1, out L2);
		#endregion

		#region Toplam Kayıt Sayısı
		if (L1 != null)
		{
			e.Total = L1.Count;
		}
		#endregion

		#region Store Yükle
		if (L1 != null || L2 != null)
		{
			Store1.DataSource = L2;
			Store1.DataBind();
		}
		#endregion
	}

	public void YoneticiAdiYaz(Observable sender)
	{
		YoneticiAdi.Html = "(" + Class.Fonksiyonlar.Admin.Kullanici.Cagir.KullaniciAdi(Class.Fonksiyonlar.Admin.Genel.AdminID()) + ") " + "<b>" + Class.Fonksiyonlar.Admin.Kullanici.Cagir.AdSoyad(Class.Fonksiyonlar.Admin.Genel.AdminID()) + "</b>";
	}

	public void GridPanelYuklenmedenOnce(Observable sender)
	{
		GridPanel1.Icon = Icon.Layers;
		GridPanel1.Title = Window1.Title + " 'a ait kayıtlar listeleniyor...";
	}

	protected void ExportEt(object sender, DirectEventArgs e)
	{
		try
		{
			#region Gelen Veriyi Al ve JSON Yap
			object o = JSON.Deserialize<object>(Class.Fonksiyonlar.Genel.TurkceKarakter(e.ExtraParams["data"].ToString()));
			#endregion

			#region Tipi Al
			string tip = e.ExtraParams["format"].ToString();
			#endregion

			Class.Fonksiyonlar.Genel.Export(o, tip, SayfaAdi);
		}
		catch
		{
		}
	}

	#endregion

	#region Yeni Kayıt İşlemleri

	protected void YeniKayitEkraniGetir(object sender, EventArgs e)
	{
		StoreDoldurUlke(StoreUlke1);
		StoreBayrak1.DataSource = BayraklariGetir();
		StoreBayrak1.DataBind();

		WindowEkle.Show();
	}

	protected void YeniKayitYap(object sender, DirectEventArgs e)
	{
		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			#region Onay Boolean Çevirme
			bool OnayBool = false;
			string CO = Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_ComboBoxOnay.Value.ToString().Trim());
			if (CO == "1")
			{
				OnayBool = true;
			}
			#endregion

			tbl_diller ta = new tbl_diller();
			ta.dil = Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_TextFieldDil.Text.Trim());
			ta.kodlama = Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_TextFieldKodlama.Text.Trim());
			ta.ikon = Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_ComboBoxBayrak.Value.ToString().Trim());
			ta.ulke_id = int.Parse(Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_ComboBoxUlke.Value.ToString().Trim()));
			ta.admin_id_ek = Class.Fonksiyonlar.Admin.Genel.AdminID();

			#region SHOP İçin Gerekli Olan ve Mecburen Eklenen Alanlar
			ta.para_birimi_id = 999;
			#endregion

			ta.onay = OnayBool;
			SME.AddTotbl_diller(ta);
			SME.SaveChanges();

			#region Admin İşlem Log
			Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ta.id, (int)Class.Sabitler.AdminLog.Islemler.Insert);
			#endregion
		}

		RSM.ClearSelections();
		Store1.DataBind();

		WindowEkle.Hide();
	}

	#endregion

	#region Güncelleme İşlemleri

	[DirectMethod]
	public void GuncellemeEkraniGetir(int ID)
	{
		Duzenle_ID.Text = ID.ToString();
		StoreDoldurUlke(StoreUlke2);
		StoreBayrak2.RemoveAll();
		PanelBayrakResim2.Hide();

		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			var SQL = (from p in SME.tbl_diller
					   where p.id == ID
					   select new
					   {
						   p.dil,
						   p.kodlama,
						   p.ikon,
						   p.ulke_id,
						   p.onay
					   });

			if (SQL.Count() > 0)
			{
				Duzenle_EskiBayrak.Text = SQL.Select(x => x.ikon).FirstOrDefault();
				Duzenle_TextFieldDil.Text = SQL.Select(x => x.dil).FirstOrDefault();
				Duzenle_ComboBoxUlke.SelectedItem.Value = SQL.Select(x => x.ulke_id).FirstOrDefault().ToString();
				Duzenle_TextFieldKodlama.Text = SQL.Select(x => x.kodlama).FirstOrDefault();

				StoreBayrak2.DataSource = BayraklariGetir();
				StoreBayrak2.DataBind();

				StringBuilder SB = new StringBuilder();

				SB.Append("<div id=\"BayrakResimDiv3\" style=\"float:right;padding:5px\"><span style=\"vertical-align:middle\">");
				SB.Append(SQL.Select(x => x.ikon.Replace(".png", "").Replace(".jpg", "").Replace(".gif", "").Replace("_", " ").ToUpper()).FirstOrDefault());
				SB.Append("</span> <img style=\"vertical-align:middle\" alt=\"");
				SB.Append(SQL.Select(x => x.ikon.Replace(".png", "").Replace(".jpg", "").Replace(".gif", "").Replace("_", " ").ToUpper()).FirstOrDefault());
				SB.Append("\" src=\"../images/flag/");
				SB.Append(SQL.Select(x => x.ikon).FirstOrDefault());
				SB.Append("\"></div>");

				PanelBayrakResim3.Html = SB.ToString();
				PanelBayrakResim3.Show();

				Duzenle_ComboBoxOnay.SelectedItem.Value = Class.Fonksiyonlar.Genel.Cevirmeler.BoolToInteger(SQL.Select(x => x.onay).FirstOrDefault());

				WindowDuzenle.Title = ID + " numaralı kaydı güncelle...";
			}
		}

		WindowDuzenle.Show();
	}

	protected void GuncellemeYap(object sender, DirectEventArgs e)
	{
		#region Onay Boolean Çevirme
		bool OnayBool = false;
		string CO = Class.Fonksiyonlar.Genel.SQLTemizle(Duzenle_ComboBoxOnay.Value.ToString().Trim());
		if (CO == "1")
		{
			OnayBool = true;
		}
		#endregion

		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			int PID = int.Parse(Duzenle_ID.Text.Trim());
			tbl_diller ta = (from p in SME.tbl_diller where p.id == PID select p).FirstOrDefault();
			ta.dil = Class.Fonksiyonlar.Genel.SQLTemizle(Duzenle_TextFieldDil.Text.Trim());
			ta.kodlama = Class.Fonksiyonlar.Genel.SQLTemizle(Duzenle_TextFieldKodlama.Text.Trim());
			ta.ulke_id = int.Parse(Class.Fonksiyonlar.Genel.SQLTemizle(Duzenle_ComboBoxUlke.Value.ToString().Trim()));

			if (!string.IsNullOrEmpty(Duzenle_ComboBoxBayrak.SelectedItem.Value))
			{
				ta.ikon = Class.Fonksiyonlar.Genel.SQLTemizle(Duzenle_ComboBoxBayrak.SelectedItem.Value.ToString());
			}

			if (!ta.ana_dil)
			{
				ta.onay = OnayBool;
			}

			ta.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();
			SME.SaveChanges();

			#region Admin İşlem Log
			Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ta.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
			#endregion
		}

		RSM.ClearSelections();
		Store1.DataBind();

		WindowDuzenle.Hide();
	}

	#endregion

	#region Silme İşlemleri

	#region Alt Bardaki Butondan Gelenler

	protected void SecilenleriSil(object sender, EventArgs e)
	{
		if (RSM.SelectedRows.Count > 0)
		{
			for (int i = 0; i < RSM.SelectedRows.Count; i++)
			{
				using (BaglantiCumlesi SME = new BaglantiCumlesi())
				{
					int PID = int.Parse(RSM.SelectedRows[i].RecordID);
					tbl_diller ta = (from p in SME.tbl_diller where p.id == PID select p).FirstOrDefault();

					if (!ta.ana_dil)
					{
						SME.DeleteObject(ta);

						#region Admin İşlem Log
						Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), PID, (int)Class.Sabitler.AdminLog.Islemler.Delete);
						#endregion

						SME.SaveChanges();
					}
				}
			}
		}

		RSM.ClearSelections();
		Store1.DataBind();
	}

	#endregion

	protected void KayitSil(object sender, EventArgs e)
	{
		if (((Ext.Net.AfterRecordDeletedEventArgs)(e)).Keys["id"].ToString() != null)
		{
			if (((Ext.Net.AfterRecordDeletedEventArgs)(e)).Keys["id"].ToString().Trim() != "")
			{
				using (BaglantiCumlesi SME = new BaglantiCumlesi())
				{
					int PID = int.Parse(((Ext.Net.AfterRecordDeletedEventArgs)(e)).Keys["id"].ToString().Trim());
					tbl_diller ta = (from p in SME.tbl_diller where p.id == PID select p).FirstOrDefault();

					if (!ta.ana_dil)
					{
						SME.DeleteObject(ta);

						#region Admin İşlem Log
						Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), PID, (int)Class.Sabitler.AdminLog.Islemler.Delete);
						#endregion

						SME.SaveChanges();
					}
				}

			}

			Store1.DataBind();
		}
	}

	#endregion

	#region Onay İşlemleri

	#region Alt Bardaki Butondan Gelenler

	protected void SecilenleriOnayla(object sender, EventArgs e)
	{
		OnayVer(-1);
	}

	protected void SecilenleriOnaysizYap(object sender, EventArgs e)
	{
		OnayKaldir(-1);
	}

	#endregion

	[DirectMethod]
	public void OnayKaldir(int ID)
	{
		if (ID == -1)
		{
			if (RSM.SelectedRows.Count > 0)
			{
				for (int i = 0; i < RSM.SelectedRows.Count; i++)
				{
					using (BaglantiCumlesi SME = new BaglantiCumlesi())
					{
						int PID = int.Parse(RSM.SelectedRows[i].RecordID);
						tbl_diller ta = (from p in SME.tbl_diller where p.id == PID select p).FirstOrDefault();

						if (ta.onay)
						{
							ta.onay = false;
						}

						ta.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();

						if (!ta.ana_dil)
						{
							SME.SaveChanges();
						}

						#region Admin İşlem Log
						Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ta.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
						#endregion
					}
				}
			}
		}
		else
		{
			using (BaglantiCumlesi SME = new BaglantiCumlesi())
			{
				tbl_diller ta = (from p in SME.tbl_diller where p.id == ID select p).FirstOrDefault();

				if (ta.onay)
				{
					ta.onay = false;
				}

				ta.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();

				if (!ta.ana_dil)
				{
					SME.SaveChanges();
				}

				#region Admin İşlem Log
				Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ta.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
				#endregion
			}
		}

		RSM.ClearSelections();
		Store1.DataBind();
	}

	[DirectMethod]
	public void OnayVer(int ID)
	{
		if (ID == -1)
		{
			if (RSM.SelectedRows.Count > 0)
			{
				for (int i = 0; i < RSM.SelectedRows.Count; i++)
				{
					using (BaglantiCumlesi SME = new BaglantiCumlesi())
					{
						int PID = int.Parse(RSM.SelectedRows[i].RecordID);
						tbl_diller ta = (from p in SME.tbl_diller where p.id == PID select p).FirstOrDefault();

						if (!ta.onay)
						{
							ta.onay = true;
						}

						ta.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();

						if (!ta.ana_dil)
						{
							SME.SaveChanges();
						}

						#region Admin İşlem Log
						Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ta.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
						#endregion
					}
				}
			}
		}
		else
		{
			using (BaglantiCumlesi SME = new BaglantiCumlesi())
			{
				tbl_diller ta = (from p in SME.tbl_diller where p.id == ID select p).FirstOrDefault();

				if (!ta.onay)
				{
					ta.onay = true;
				}

				ta.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();

				if (!ta.ana_dil)
				{
					SME.SaveChanges();
				}

				#region Admin İşlem Log
				Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ta.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
				#endregion
			}
		}

		RSM.ClearSelections();
		Store1.DataBind();
	}

	#endregion

	#region Siralama İşlemleri

	[DirectMethod]
	public void SiralamaEkraniGetir(int ID)
	{
		Duzenle_ID2.Text = ID.ToString();

		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			var SQL = (from p in SME.tbl_diller
					   where p.id == ID
					   select new
					   {
						   p.sira
					   });

			if (SQL.Count() > 0)
			{
				Duzenle_Sira.Text = SQL.Select(x => x.sira).FirstOrDefault().ToString();
			}
		}

		WindowSiralama.Title = ID + " numaralı kaydı güncelle...";
		WindowSiralama.Show();
	}

	protected void SiralamaGuncelle(object sender, DirectEventArgs e)
	{
		string EskiSira = Duzenle_Sira.Text.Trim();
		int PID = int.Parse(Duzenle_ID2.Text.Trim());
		int YeniSira = 0;

		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			if (!string.IsNullOrEmpty(EskiSira))
			{
				if (EskiSira != "0")
				{
					YeniSira = int.Parse(Duzenle_Sira.Text.Trim());
				}
			}

			if (YeniSira != 0)
			{
				var SQL = (from p in SME.tbl_diller
						   where p.sira == YeniSira
						   select new
						   {
							   p.sira
						   });

				if (SQL.Count() > 0)
				{
					tbl_diller td1 = (from p in SME.tbl_diller where p.sira == YeniSira select p).FirstOrDefault();
					td1.sira = 0;
					td1.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();

					#region Admin İşlem Log
					Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(td1)).EntityKey.EntitySetName.ToString(), td1.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
					#endregion

					Class.Fonksiyonlar.ExtJS.MesajKutusu(Icon.Information, MessageBox.Icon.INFO, "Aynı Kayıt", "Vermek istediğiniz sıra numarası başka bir kayda (" + td1.id + " - " + td1.dil + ") aitti ve eski kaydın sırası da 0 olarak değiştirildi.");
				}

				tbl_diller td2 = (from p in SME.tbl_diller where p.id == PID select p).FirstOrDefault();
				td2.sira = YeniSira;
				td2.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();

				#region Admin İşlem Log
				Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(td2)).EntityKey.EntitySetName.ToString(), td2.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
				#endregion
			}
			else
			{
				tbl_diller td3 = (from p in SME.tbl_diller where p.id == PID select p).FirstOrDefault();
				td3.sira = 0;
				td3.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();

				#region Admin İşlem Log
				Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(td3)).EntityKey.EntitySetName.ToString(), td3.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
				#endregion
			}

			SME.SaveChanges();
		}

		RSM.ClearSelections();
		Store1.DataBind();

		WindowSiralama.Hide();
	}

	#endregion
}