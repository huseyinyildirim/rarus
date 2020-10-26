<%@ WebHandler Language="C#" Class="Header_Image" %>
using System;
using System.Web;

public class Header_Image : IHttpHandler
{
    public void ProcessRequest(HttpContext HC)
    {
        HttpResponse HR = HC.Response;

        int w = 1;
        int h = 1;
        bool k = false;
        string r = null;
        string y = null;
        string n = null;

        if (HC.Request.QueryString["i"] != null)
        {
            if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.StringTemizle(HC.Request.QueryString["i"])))
            {
                r = Class.Fonksiyonlar.Genel.StringTemizle(HC.Request.QueryString["i"]);
            }
        }

        if (HC.Request.QueryString["n"] != null)
        {
            if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.StringTemizle(HC.Request.QueryString["n"])))
            {
                n = Class.Fonksiyonlar.Genel.StringTemizle(HC.Request.QueryString["n"]);
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

        switch (n)
        {
            case "B" :
                y = Class.Degiskenler.Site.Yollar.Bayrak + r;
                break;

            case "U":
                y = Class.Degiskenler.Site.Yollar.Urun + r;
                break;

            case "H":
                y = Class.Degiskenler.Site.Yollar.Header + r;
                break;

            case "D":
                y = Class.Degiskenler.Site.Yollar.Diger + r;
                break;
                
            default :
                y = Class.Degiskenler.Site.Yollar.Resim + "blank.gif";
                break;
        }

        if (!System.IO.File.Exists(y))
        {
            y = Class.Degiskenler.Site.Yollar.Resim + "blank.gif";
        }

        try
        {
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
        catch (Exception ex)
        {
            HC.Response.Write(ex.Message);
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