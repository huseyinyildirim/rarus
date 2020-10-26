using System;
using System.Linq;
using System.Text;
using MySQLDataModel;
using System.Web.Routing;

public partial class about : System.Web.UI.Page
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
		DilID = Class.Fonksiyonlar.Dil.ID();

		#region Description Metatag
		Class.Fonksiyonlar.UserKontrol.HeaderText("sitil", "description", "<meta http-equiv=\"Description\" content=\"" + Class.Fonksiyonlar.Firma.Description() + "\" />");
		#endregion

		#region Başlık Sol

		#region Sol Başlık Visibility
		Class.Fonksiyonlar.UserKontrol.ElemanGizle(0, "basliklar", "baslik_sol", true);
		#endregion

		Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sol", "<h1><img id=\"arrow1\" src=\"/images/arrow.png\" alt=\"\" class=\"arr\"/> " + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 25) + "</h1>");

		#endregion

		#region Başlık Sağ

		#region Sağ Başlık Visibility
		Class.Fonksiyonlar.UserKontrol.ElemanGizle(0, "basliklar", "baslik_sag", true);
		#endregion

		#region Başlık Text
		StringBuilder SB = new StringBuilder();
		SB.Append("<!--SAG BASLIK-->\r\n");
		SB.Append("<div id=\"basr\"><h1><img id=\"mail1\" src=\"/images/icon/group.png\" alt=\"\" class=\"icon\"/> " + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 24) + "</h1></div>\r\n");
		SB.Append("<!--SAG BASLIK-->\r\n");
		#endregion

		Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sag", SB.ToString());

		#endregion

		h1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 25);
		p.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 26);

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
}