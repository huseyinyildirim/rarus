<%@ Application Language="C#" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">

	public static void RegisterRoutes(RouteCollection routes)
	{
		//http://www.yazilimdevi.com/yazilimdevi/Makaleler-938-asp-net-4-0-url-routing.aspx
		routes.MapPageRoute("product", Class.Fonksiyonlar.Genel.OzelAyar("URL") + "-product/{UrunID}-{UrunKod}-{Urun}", "~/product.aspx");
		routes.MapPageRoute("tag", "tag/{Tag}", "~/products.aspx");
		routes.MapPageRoute("brand", "brand/{Brand}", "~/products.aspx");
		routes.MapPageRoute("categori", "categori/{CategoriID}-{Categori}", "~/products.aspx");
		routes.MapPageRoute("search", "search/{Kelime}", "~/search.aspx");
	}
	
	void Application_Start(object sender, EventArgs e)
	{
		#region Route Edilen Sayfalar
		Application.Lock();
		RegisterRoutes(RouteTable.Routes);
		Application.UnLock();
		#endregion

		#region Route Edilen Sayfalar
		Application.Lock();
		RouteTable.Routes.Add("default", new Route(Class.Fonksiyonlar.Genel.OzelAyar("URL"), new PageRouteHandler("~/default.aspx")));
		RouteTable.Routes.Add("products", new Route(Class.Fonksiyonlar.Genel.OzelAyar("URL") + "-products", new PageRouteHandler("~/products.aspx")));
		RouteTable.Routes.Add("about", new Route("about-" + Class.Fonksiyonlar.Genel.OzelAyar("URL"), new PageRouteHandler("~/about.aspx")));
		RouteTable.Routes.Add("contact", new Route("contact-" + Class.Fonksiyonlar.Genel.OzelAyar("URL"), new PageRouteHandler("~/contact.aspx")));
		Application.UnLock();
		#endregion

		
		#region Diller
		Application.Lock();
		using (MySQLDataModel.BaglantiCumlesi SME = new MySQLDataModel.BaglantiCumlesi())
		{
			Objeler.Listeler.Diller.Clear();

			var SQL = (from p in SME.tbl_diller
					   from k in SME.tbl_sbt_ulke
					   where p.ulke_id == k.id
					   select new
					   {
						   p.dil,
						   p.id,
						   p.ikon,
						   p.kodlama,
						   p.sira,
						   p.onay,
						   p.ana_dil,
						   kisaltma = (k.dil_kisaltma == null ? k.kisaltma : k.dil_kisaltma)
					   });

			foreach (var i in SQL)
			{
				Objeler.Tanimlar.Diller D = new Objeler.Tanimlar.Diller();

				D.Dil = i.dil;
				D.ID = i.id;
				D.Kisaltma = i.kisaltma;
				D.Ikon = i.ikon;
				D.Kodlama = i.kodlama;
				D.Sira = i.sira;
				D.Onay = i.onay;
				D.AnaDil = i.ana_dil;

				Objeler.Listeler.Diller.Add(D);
			}
		}
		Application.UnLock();
		#endregion
	}
	
	void Application_End(object sender, EventArgs e) 
	{
		//  Code that runs on application shutdown

	}

	void Application_Error(object sender, EventArgs e)
  {
	  #region Hata Durumunda
	  if (bool.Parse(Class.Fonksiyonlar.Genel.OzelAyar("HataModu")))
	  {
		  Exception E = Server.GetLastError();
		  Response.Clear();

		  HttpException HE = E as HttpException;

		  if (HE != null)
		  {
			  int action = -1;

			  switch (HE.GetHttpCode())
			  {
				  case 404:
					  action = 404;
					  break;

				  case 500:
					  action = 500;
					  break;

				  default:
					  action = 0;
					  break;
			  }

			  Server.ClearError();
			  Response.Redirect(String.Format("~/?error={0}-{1}", action, Class.Fonksiyonlar.Genel.KarakterTemizle(E.Message,true)));
		  }
	  }
	  #endregion
  }

	void Session_Start(object sender, EventArgs e) 
	{
		#region Session Süresi
		Session.Timeout = 1440; 
		#endregion
			
		#region Dil
		Application.Lock();
		if (!Class.Fonksiyonlar.Dil.SessionKontrol())
		{
			var SQL = (from p in Objeler.Listeler.Diller
					   where p.AnaDil == true && p.Onay == true
					   select new { p.ID});
				
			Objeler.Tanimlar.Dil D = new Objeler.Tanimlar.Dil();
			D.DilID = SQL.Select(x => x.ID).FirstOrDefault();
			D.SessionID = Session.SessionID;
			D.Tarih = DateTime.Now;
			D.IP = Request.ServerVariables["REMOTE_ADDR"];
			Objeler.Listeler.Dil.Add(D);

			//Class.Fonksiyonlar.Admin.Log.AllHttp(Session.SessionID.ToString(), 0);  
		}
		Application.UnLock(); 
		#endregion
	}

	void Session_End(object sender, EventArgs e) 
	{
		// Code that runs when a session ends. 
		// Note: The Session_End event is raised only when the sessionstate mode
		// is set to InProc in the Web.config file. If session mode is set to StateServer 
		// or SQLServer, the event is not raised.
	}
	   
</script>
