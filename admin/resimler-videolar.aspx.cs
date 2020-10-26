using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Objects.DataClasses;
using System.IO;
using System.Linq;
using System.Linq.Dynamic;
using System.Text;
using System.Web;
using Ext.Net;
using LinqToCache;
using MySQLDataModel;

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
				ResourceManager1.RegisterIcon(Icon.Film);
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

	protected IEnumerable OlmayanResimleriGetir()
	{
		List<string> Resimler = new List<string>(Class.Fonksiyonlar.Genel.ResimleriListele(Class.Degiskenler.Site.Yollar.Urun).ToList().ConvertAll(d => d.ToString().Replace(Class.Degiskenler.Site.Yollar.Urun, "")).ToList());

		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			var SQL1 = (from p in SME.tbl_dosyalar
						where p.tip == (int)Class.Sabitler.Dosya.Resim
						select p.ad).Distinct().ToList();

			var SQL2 = Resimler.Where(s => !SQL1.Contains(s.ToString())).Select(s => new
			{
				resim = s
			});

			return SQL2.AsEnumerable();
		}
	}

	protected void StoreDoldurOlmayanResimler(Store StoreAdi)
	{
		StoreAdi.DataSource = OlmayanResimleriGetir();
		StoreAdi.DataBind();
	}

	protected void HataMesaji(string hata)
	{
		Class.Fonksiyonlar.ExtJS.MesajKutusu(Icon.Error, MessageBox.Icon.ERROR, "İşlem başarısız", hata);
	}

	[DirectMethod]
	public string Ekle_NodeYukle(string NodeID)
	{
		int INodeID = int.Parse(NodeID);
		TreeNodeCollection TNC = new TreeNodeCollection();

		if (!string.IsNullOrEmpty(NodeID))
		{
			using (BaglantiCumlesi SME = new BaglantiCumlesi())
			{
				int KatTip = int.Parse(Ekle_ComboBoxTip.SelectedItem.Value);

				if (KatTip==(int)Class.Sabitler.Dosya.Resim)
				{
					Ekle_TreePanelKategoriler.Title = "";
					Ekle_TreePanelKategoriler.Title = "Resim Grupları";
				}
				else if (KatTip == (int)Class.Sabitler.Dosya.Video)
				{
					Ekle_TreePanelKategoriler.Title = "";
					Ekle_TreePanelKategoriler.Title = "Video Grupları";
				}

				var SQL = (from p in SME.tbl_dosyalar_kategori
						   where p.kategori_id == INodeID && p.tip == KatTip
						   select
							new
							{
								p.ad,
								p.kategori_id,
								p.id,
								alt_kategori_sayisi = SME.tbl_dosyalar_kategori.Where(k => k.kategori_id == p.id).Count()
							});

				foreach (var i in SQL)
				{
					if (i.alt_kategori_sayisi > 0)
					{
						AsyncTreeNode ATN = new AsyncTreeNode();
						ATN.Text = i.ad;
						ATN.NodeID = i.id.ToString();
						ATN.Expanded = true;
						ATN.Checked = ThreeStateBool.False;
						TNC.Add(ATN);
					}
					else
					{
						TreeNode TN = new TreeNode();
						TN.Text = i.ad;
						TN.NodeID = i.id.ToString();
						TN.Expanded = true;
						TN.Leaf = true;
						TN.Checked = ThreeStateBool.False;
						TNC.Add(TN);
					}
				}
			}
		}

		return TNC.ToJson();
	}

	[DirectMethod]
	public void Ekle_KategoriDegistir()
	{
		Ekle_TreePanelKategoriler.ReloadAsyncNode("0", null);
	}

	[DirectMethod]
	public string Duzenle_NodeYukle(string NodeID)
	{
		int INodeID = int.Parse(NodeID);
		TreeNodeCollection TNC = new TreeNodeCollection();

		if (!string.IsNullOrEmpty(NodeID))
		{
			using (BaglantiCumlesi SME = new BaglantiCumlesi())
			{
				int DosyaID = int.Parse(Duzenle_ID.Text.Trim());
				int KatTip = int.Parse(Duzenle_Tip.Text.Trim());

				if (KatTip == (int)Class.Sabitler.Dosya.Resim)
				{
					Duzenle_TreePanelKategoriler.Title = "";
					Duzenle_TreePanelKategoriler.Title = "Resim Grupları";
				}
				else if (KatTip == (int)Class.Sabitler.Dosya.Video)
				{
					Duzenle_TreePanelKategoriler.Title = "";
					Duzenle_TreePanelKategoriler.Title = "Video Grupları";
				}

				var SQL = (from p in SME.tbl_dosyalar_kategori
						   where p.kategori_id == INodeID && p.tip == KatTip
						   select
							new
							{
								p.ad,
								p.kategori_id,
								p.id,
								alt_kategori_sayisi = SME.tbl_dosyalar_kategori.Where(k => k.kategori_id == p.id).Count()
							});

				foreach (var i in SQL)
				{
					if (i.alt_kategori_sayisi > 0)
					{
						AsyncTreeNode ATN = new AsyncTreeNode();
						ATN.Text = i.ad;
						ATN.NodeID = i.id.ToString();
						ATN.Expanded = true;

						if (KategoriKontrol(DosyaID,i.id))
						{
							ATN.Checked = ThreeStateBool.True;
						}
						else
						{
							ATN.Checked = ThreeStateBool.False;
						}

						TNC.Add(ATN);
					}
					else
					{
						TreeNode TN = new TreeNode();
						TN.Text = i.ad;
						TN.NodeID = i.id.ToString();
						TN.Expanded = true;
						TN.Leaf = true;

						if (KategoriKontrol(DosyaID, i.id))
						{
							TN.Checked = ThreeStateBool.True;
						}
						else
						{
							TN.Checked = ThreeStateBool.False;
						}

						TNC.Add(TN);
					}
				}
			}
		}

		return TNC.ToJson();
	}

	[DirectMethod]
	public void Duzenle_KategoriDegistir()
	{
		Duzenle_TreePanelKategoriler.ReloadAsyncNode("0", null);
	}

	protected string Kategoriler(int ResimID)
	{
		StringBuilder SB = new StringBuilder();

		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			var SQL = (from p in SME.tbl_dosyalar_kategoriler
					   where p.dosya_id == ResimID
					   select new
					   {
						   kat = (p.kategori_id != null ? SME.tbl_dosyalar_kategori.Where(k => k.id == p.kategori_id).Select(k => k.ad).FirstOrDefault() : null)
					   });

			foreach (var i in SQL)
			{
				SB.Append(i.kat);
				SB.Append("<br/>");
			}
		}

		if (SB.Length > 1)
		{
			return SB.ToString().Substring(0, SB.ToString().Length - 5);
		}
		else
		{
			return null;
		}
	}

	protected bool KategoriKontrol(int ResimID, int KategoriID)
	{
		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			int VarMi = (from p in SME.tbl_dosyalar_kategoriler
					   where p.dosya_id == ResimID && p.kategori_id == KategoriID
					   select p.id).Count();

			if (VarMi > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}

	protected List<int> KategorilerList(int ResimID)
	{
		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			return (from p in SME.tbl_dosyalar_kategoriler
					where p.dosya_id == ResimID
					select p.kategori_id).Cast<int>().ToList();
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
				var SQL1 = (from p in SME.tbl_dosyalar
							select new
							{
								p.aciklama,
								p.id,
								p.ad,
								p.url,
								p.tarih_ek,
								p.tarih_gun,
								p.admin_id_ek,
								p.admin_id_gun,
								p.onay,
								p.tip
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
					p.aciklama,
					p.id,
					p.ad,
					p.url,
					p.tarih_ek,
					p.tarih_gun,
					p.admin_id_ek,
					p.admin_id_gun,
					tip = (p.tip == 1 ? "VIDEO" : "RESIM"),
					kategoriler = Kategoriler(p.id),
					ekleyen = (p.admin_id_ek != null ? SME.tbl_adminler.Where(k => k.id == p.admin_id_ek).Select(x => "(" + x.kullanici_adi + ") " + x.ad_soyad).FirstOrDefault() : null),
					guncelleyen = (p.admin_id_gun != null ? SME.tbl_adminler.Where(k => k.id == p.admin_id_gun).Select(x => "(" + x.kullanici_adi + ") " + x.ad_soyad).FirstOrDefault() : null),
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
		StoreDoldurOlmayanResimler(StoreResimler1);

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

			int tip = int.Parse(Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_ComboBoxTip.Value.ToString().Trim()));

			#region Resmi Kaydet
			tbl_dosyalar ta1 = new tbl_dosyalar();
			ta1.tip = tip;

			if (tip == 0)
			{
				ta1.ad = Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_ComboBoxResim.Value.ToString().Trim());
			}
			else if (tip == 1)
			{
				ta1.ad = Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_TextFieldAdi.Text.Trim());
				ta1.url = Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_TextFieldUrl.Text.ToString().Trim());
			}

			if (Ekle_TextAreaAciklama.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_TextAreaAciklama.Text.Trim())))
				{
					ta1.aciklama = Class.Fonksiyonlar.Genel.SQLTemizle(Ekle_TextAreaAciklama.Text.Trim());
				}
				else
				{
					ta1.aciklama = null;
				}
			}

			ta1.admin_id_ek = Class.Fonksiyonlar.Admin.Genel.AdminID();
			ta1.onay = OnayBool;
			SME.AddTotbl_dosyalar(ta1);
			SME.SaveChanges();

			#region Admin İşlem Log
			Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta1)).EntityKey.EntitySetName.ToString(), ta1.id, (int)Class.Sabitler.AdminLog.Islemler.Insert);
			#endregion 
			#endregion

			foreach(var i in Ekle_TreePanelKategoriler.CheckedNodes)
			{
				#region Dosyayı Eklenen Kategoriye Ata
				tbl_dosyalar_kategoriler ta2 = new tbl_dosyalar_kategoriler();
				ta2.dosya_id = ta1.id;
				ta2.kategori_id = int.Parse(Class.Fonksiyonlar.Genel.SQLTemizle(i.NodeID));
				ta2.admin_id_ek = Class.Fonksiyonlar.Admin.Genel.AdminID();
				SME.AddTotbl_dosyalar_kategoriler(ta2);
				SME.SaveChanges();

				#region Admin İşlem Log
				Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta2)).EntityKey.EntitySetName.ToString(), ta2.id, (int)Class.Sabitler.AdminLog.Islemler.Insert);
				#endregion
				#endregion
			}
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

		using (BaglantiCumlesi SME = new BaglantiCumlesi())
		{
			var SQL2 = (from p in SME.tbl_dosyalar
						where p.id == ID
						select new
						{
							p.ad,
							p.tip,
							p.id,
							p.url,
							p.onay,
							p.aciklama
						});

			if (SQL2.Count() > 0)
			{
				int tip = SQL2.Select(x => x.tip).FirstOrDefault();

				Duzenle_Tip.Text = tip.ToString();

				if (tip == 0)
				{
					Duzenle_TextFieldResim.Text = SQL2.Select(x => x.ad).FirstOrDefault();
				}
				else if (tip == 1)
				{
					Duzenle_TextFieldAdi.Text = SQL2.Select(x => x.ad).FirstOrDefault();
					Duzenle_TextFieldUrl.Text = SQL2.Select(x => x.url).FirstOrDefault();
				}

				string Kat = Kategoriler(SQL2.Select(x => x.id).FirstOrDefault());

				if (!string.IsNullOrEmpty(Kat))
				{
					Kat = Kat.Replace("<br/>", ",");
					Duzenle_DropDownFieldKategoriler.SetValue(Kat);
				}
				else
				{
					Duzenle_DropDownFieldKategoriler.Clear();
					Duzenle_DropDownFieldKategoriler.SetValue("");
				}

				Duzenle_TextAreaAciklama.Text = SQL2.Select(x => x.aciklama).FirstOrDefault();
				Duzenle_ComboBoxOnay.SelectedItem.Value = Class.Fonksiyonlar.Genel.Cevirmeler.BoolToInteger(SQL2.Select(x => x.onay).FirstOrDefault());

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
			int tip = int.Parse(Duzenle_Tip.Text.Trim());

			tbl_dosyalar ta1 = (from p in SME.tbl_dosyalar where p.id == PID select p).FirstOrDefault();

			if (tip == 0)
			{
				ta1.url = null;
			}
			else if (tip == 1)
			{
				ta1.ad = Class.Fonksiyonlar.Genel.SQLTemizle(Duzenle_TextFieldAdi.Text.Trim());
				ta1.url = Class.Fonksiyonlar.Genel.SQLTemizle(Duzenle_TextFieldUrl.Text.ToString().Trim());
			}

			if (Duzenle_TextAreaAciklama.Text != null)
			{
				if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(Duzenle_TextAreaAciklama.Text.Trim())))
				{
					ta1.aciklama = Class.Fonksiyonlar.Genel.SQLTemizle(Duzenle_TextAreaAciklama.Text.Trim());
				}
				else
				{
					ta1.aciklama = null;
				}
			}

			ta1.onay = OnayBool;
			ta1.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();
			SME.SaveChanges();

			#region Admin İşlem Log
			Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta1)).EntityKey.EntitySetName.ToString(), PID, (int)Class.Sabitler.AdminLog.Islemler.Update);
			#endregion

			if (Duzenle_TreePanelKategoriler.CheckedNodes != null)
			{
				#region Eski Kayıtları Sil
				List<int> ListKategoriler = KategorilerList(ta1.id);

				if (ListKategoriler.Count > 0)
				{
					foreach (var j in ListKategoriler)
					{
						tbl_dosyalar_kategoriler tta2 = (from p in SME.tbl_dosyalar_kategoriler where p.kategori_id == j && p.dosya_id == ta1.id select p).FirstOrDefault();
						SME.DeleteObject(tta2);

						#region Admin İşlem Log
						Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(tta2)).EntityKey.EntitySetName.ToString(), j, (int)Class.Sabitler.AdminLog.Islemler.Delete);
						#endregion

						SME.SaveChanges();
					}
				}
				#endregion

				#region Yenileri Kaydet
				foreach (var i in Duzenle_TreePanelKategoriler.CheckedNodes)
				{
					if (!KategoriKontrol(ta1.id, int.Parse(Class.Fonksiyonlar.Genel.SQLTemizle(i.NodeID))))
					{
						#region Dosyayı Eklenen Kategoriye Ata
						tbl_dosyalar_kategoriler ta2 = new tbl_dosyalar_kategoriler();
						ta2.dosya_id = ta1.id;
						ta2.kategori_id = int.Parse(Class.Fonksiyonlar.Genel.SQLTemizle(i.NodeID));
						ta2.admin_id_ek = Class.Fonksiyonlar.Admin.Genel.AdminID();
						SME.AddTotbl_dosyalar_kategoriler(ta2);
						SME.SaveChanges();

						#region Admin İşlem Log
						Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta2)).EntityKey.EntitySetName.ToString(), ta2.id, (int)Class.Sabitler.AdminLog.Islemler.Insert);
						#endregion
						#endregion
					}
				} 
				#endregion
			}
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
					tbl_dosyalar ta = (from p in SME.tbl_dosyalar where p.id == PID select p).FirstOrDefault();
					SME.DeleteObject(ta);

					#region Admin İşlem Log
					Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), PID, (int)Class.Sabitler.AdminLog.Islemler.Delete);
					#endregion

					SME.SaveChanges();
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
					tbl_dosyalar ta = (from p in SME.tbl_dosyalar where p.id == PID select p).FirstOrDefault();
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
						tbl_dosyalar ta = (from p in SME.tbl_dosyalar where p.id == PID select p).FirstOrDefault();

						if (ta.onay)
						{
							ta.onay = false;
							ta.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();
							SME.SaveChanges();

							#region Admin İşlem Log
							Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ta.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
							#endregion
						}
					}
				}
			}
		}
		else
		{
			using (BaglantiCumlesi SME = new BaglantiCumlesi())
			{
				tbl_dosyalar ta = (from p in SME.tbl_dosyalar where p.id == ID select p).FirstOrDefault();

				if (ta.onay)
				{
					ta.onay = false;
					ta.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();
					SME.SaveChanges();

					#region Admin İşlem Log
					Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ta.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
					#endregion
				}
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
						tbl_dosyalar ta = (from p in SME.tbl_dosyalar where p.id == PID select p).FirstOrDefault();

						if (!ta.onay)
						{
							ta.onay = true;
							ta.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();
							SME.SaveChanges();

							#region Admin İşlem Log
							Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), PID, (int)Class.Sabitler.AdminLog.Islemler.Update);
							#endregion
						}
					}
				}
			}
		}
		else
		{
			using (BaglantiCumlesi SME = new BaglantiCumlesi())
			{
				tbl_dosyalar ta = (from p in SME.tbl_dosyalar where p.id == ID select p).FirstOrDefault();

				if (!ta.onay)
				{
					ta.onay = true;
					ta.admin_id_gun = Class.Fonksiyonlar.Admin.Genel.AdminID();
					SME.SaveChanges();

					#region Admin İşlem Log
					Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta)).EntityKey.EntitySetName.ToString(), ta.id, (int)Class.Sabitler.AdminLog.Islemler.Update);
					#endregion
				}
			}
		}

		RSM.ClearSelections();
		Store1.DataBind();
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
								ta2.ad = Class.Fonksiyonlar.Genel.SQLTemizle(GelenDosya.FileName);
								ta2.admin_id_ek = Class.Fonksiyonlar.Admin.Genel.AdminID();
								ta2.onay = false;
								SME.AddTotbl_dosyalar(ta2);
								SME.SaveChanges();

								#region Admin İşlem Log
								Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta2)).EntityKey.EntitySetName.ToString(), ta2.id, (int)Class.Sabitler.AdminLog.Islemler.Insert);
								#endregion
								#endregion

								#region Dosyayı Eklenen Kategoriye Ata
								tbl_dosyalar_kategoriler ta3 = new tbl_dosyalar_kategoriler();
								ta3.dosya_id = ta2.id;
								ta3.kategori_id = KategoriID;
								ta3.admin_id_ek = Class.Fonksiyonlar.Admin.Genel.AdminID();
								SME.AddTotbl_dosyalar_kategoriler(ta3);
								SME.SaveChanges();

								#region Admin İşlem Log
								Class.Fonksiyonlar.Admin.Log.Islemler(Class.Fonksiyonlar.Admin.Genel.AdminID(), ((EntityObject)(ta3)).EntityKey.EntitySetName.ToString(), ta3.id, (int)Class.Sabitler.AdminLog.Islemler.Insert);
								#endregion
								#endregion
							}

							WindowResimYukle.Hide();
							RSM.ClearSelections();
							Store1.DataBind();
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