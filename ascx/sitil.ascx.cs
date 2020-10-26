using System;
using System.Linq;
using System.Text;

public partial class sitil : System.Web.UI.UserControl
{
	protected void Page_Load(object sender, EventArgs e)
	{

		//Response.CacheControl = "no-cache";
		//Response.AddHeader("Pragma", "no-cache");
		//Response.Expires = -1;

		//Response.Cache.SetCacheability(HttpCacheability.NoCache);
		//Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1));
		//Response.Cache.SetNoStore();

		/*
		Response.Cache.SetExpires(DateTime.Now.AddHours(1));
		Response.Cache.SetCacheability(HttpCacheability.ServerAndPrivate);
		Response.Cache.SetValidUntilExpires(true);
		Response.Cache.SetSlidingExpiration(true);
		*/

		int DilID = Class.Fonksiyonlar.Dil.ID();

		var SQL = (from p in Objeler.Listeler.Diller
				   where p.ID == DilID && p.Onay == true
				   select new
				   {
					   p.Kodlama,
					   p.Kisaltma
				   });

		ContentType.Text = "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=" + SQL.Select(x => x.Kodlama).FirstOrDefault() + "\" />";
		Charset.Text = "<meta http-equiv=\"Charset\" content=\"" + SQL.Select(x => x.Kodlama).FirstOrDefault() + "\" />";
		ContentLanguage.Text = "<meta http-equiv=\"Content-Language\" content=\"" + SQL.Select(x => x.Kisaltma).FirstOrDefault() + "\" />";

		#region Google Analytics
		string GA = Class.Fonksiyonlar.Firma.Diger.Google.Analytics();
		if (!string.IsNullOrEmpty(GA))
		{
			StringBuilder SB = new StringBuilder();
			SB.Append("\r\n<!--Google Analytics-->\r\n");
			SB.Append(GA);
			SB.Append("\r\n<!--Google Analytics-->\r\n");

			GoogleAnalytics.Text = SB.ToString();
			GoogleAnalytics.Visible = true;
		}
		#endregion

		#region Google Doğrulama Kodu
		string GD = Class.Fonksiyonlar.Firma.Diger.Google.DogrulamaKodu();
		if (!string.IsNullOrEmpty(GD))
		{
			GoogleDogrulamaKodu.Text = GD;
			GoogleDogrulamaKodu.Visible = true;
		}
		#endregion
	}
}