<%@ WebHandler Language="C#" Class="Product_Image" %>
using System;
using System.Web;
using System.Linq;

public class Product_Image : IHttpHandler
{
    public void ProcessRequest(HttpContext HC)
    {
        HttpResponse HR = HC.Response;

        int w = 1;
        int h = 1;
        bool k = false;
        string r = null;
        string y = null;

        if (HC.Request.QueryString["i"] != null)
        {
            if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["i"])))
            {
                if (Class.Fonksiyonlar.Genel.Kontroller.Numerik(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["i"])))
                {
                    using (MySQLDataModel.BaglantiCumlesi SME = new MySQLDataModel.BaglantiCumlesi())
                    {
                       int ResimID = Convert.ToInt16(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["i"]));
                        
                        var SQL = (from p in SME.tbl_dosyalar
                                    where p.id == ResimID && p.onay == true && p.tip == (int)Class.Sabitler.Dosya.Resim
                                    select p);
                        
                        if (SQL.Count() > 0)
                        {
                            r = SQL.Select(x => x.ad).FirstOrDefault();      
                        }
                        else
                        {
                            r = "..\blank.gif";
                        }
                    }
                }
            }
        }

        if (HC.Request.QueryString["w"] != null)
        {
            if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["w"])))
            {
                if (Class.Fonksiyonlar.Genel.Kontroller.Numerik(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["w"])))
                {
                    if (Convert.ToInt16(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["w"])) < 3000)
                    {
                        w = Convert.ToInt16(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["w"]));
                    }
                }
            }
        }

        if (HC.Request.QueryString["h"] != null)
        {
            if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["h"])))
            {
                if (Class.Fonksiyonlar.Genel.Kontroller.Numerik(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["h"])))
                {
                    if (Convert.ToInt16(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["h"])) < 3000)
                    {
                        h = Convert.ToInt16(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["h"]));
                    }
                }
            }
        }

        if (HC.Request.QueryString["k"] != null)
        {
            if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["k"])))
            {
                if (Class.Fonksiyonlar.Genel.SQLTemizle(HC.Request.QueryString["k"]) == "t")
                {
                    k = true;
                }
            }
        }

        y = Class.Degiskenler.Site.Yollar.Urun + r;

        if (!System.IO.File.Exists(y))
        {
            y = Class.Degiskenler.Site.Yollar.Resim + "blank.gif";
        }

        using (System.Drawing.Image I = System.Drawing.Image.FromFile(y))
        {
            if (I.RawFormat.Equals(System.Drawing.Imaging.ImageFormat.Jpeg))
            {
                HR.ContentType = "image/jpeg";
            }
            else if (I.RawFormat.Equals(System.Drawing.Imaging.ImageFormat.Bmp))
            {
                HR.ContentType = "image/bmp";
            }
            else if (I.RawFormat.Equals(System.Drawing.Imaging.ImageFormat.Gif))
            {
                HR.ContentType = "image/gif";
            }
            else if (I.RawFormat.Equals(System.Drawing.Imaging.ImageFormat.Png))
            {
                HR.ContentType = "image/png";
            }

            Class.Fonksiyonlar.ResimIslemleri.Getir(I, w, h, System.Drawing.Color.White, k, 90, 72);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}