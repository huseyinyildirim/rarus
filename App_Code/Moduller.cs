using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;

namespace Moduller
{
	public class BordersizResim : Image
	{
		public override Unit BorderWidth
		{
			get
			{
				if (base.BorderWidth.IsEmpty)
				{
					return Unit.Pixel(0);
				}
				else
				{
					return base.BorderWidth;
				}
			}
			set
			{
				base.BorderWidth = value;
			}
		}
	}

	public class GuvenliCookie : IHttpModule
	{
		public void Dispose() { }

		public void Init(HttpApplication HA)
		{
			HA.BeginRequest += new EventHandler(context_BeginRequest);
		}

		private void context_BeginRequest(object sender, EventArgs e)
		{
			HttpContext.Current.Response.AddHeader("p3p", "CP=\"IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT\"");
		}
	}

	public class DomainYonlendir : IHttpModule
	{
		string HTTPGiris = Class.Fonksiyonlar.Firma.Domain();
		string WWWGiris = "www." + Class.Fonksiyonlar.Firma.Domain();

		public void Init(HttpApplication app)
		{
			app.BeginRequest += new EventHandler(app_BeginRequest);
		}

		protected void app_BeginRequest(object sender, EventArgs e)
		{
			HttpApplication app = sender as HttpApplication;
			Uri currentUri = app.Request.Url;

			if (currentUri.Host == HTTPGiris)
			{
				Uri redirectToUri = new Uri(new Uri("http://" + WWWGiris), currentUri.PathAndQuery);

				RedirectPermanently(app.Response, redirectToUri.ToString());
			}
		}

		public static void RedirectPermanently(HttpResponse res, string location)
		{
			res.Status = "301 Moved Permanently";
			res.AddHeader("Location", location);
			res.Flush();
			res.End();
		}

		public void Dispose()
		{
		}
	}

	public class WhiteSpaceKaldir : IHttpModule
	{
		void IHttpModule.Dispose()
		{
		}

		void IHttpModule.Init(HttpApplication context)
		{
			context.BeginRequest += new EventHandler(context_BeginRequest);
		}

		void context_BeginRequest(object sender, EventArgs e)
		{
			HttpApplication app = sender as HttpApplication;

			if (app.Request.RawUrl.IndexOf("/admin/") != -1)
			{
				if (app.Request.RawUrl.Contains(".aspx"))
				{
					app.Response.Filter = new WhitespaceFilter(app.Response.Filter);
				}
			}
		}

		private class WhitespaceFilter : Stream
		{
			public WhitespaceFilter(Stream sink)
			{
				_sink = sink;
			}

			private Stream _sink;
			private static Regex reg = new Regex(@"(?<=[^])\t{2,}|(?<=[>])\s{2,}(?=[<])|(?<=[>])\s{2,11}(?=[<])|(?=[\n])\s{2,}");

			#region Properites

			public override bool CanRead
			{
				get { return true; }
			}

			public override bool CanSeek
			{
				get { return true; }
			}

			public override bool CanWrite
			{
				get { return true; }
			}

			public override void Flush()
			{
				_sink.Flush();
			}

			public override long Length
			{
				get { return 0; }
			}

			private long _position;
			public override long Position
			{
				get { return _position; }
				set { _position = value; }
			}

			#endregion

			#region Methods

			public override int Read(byte[] buffer, int offset, int count)
			{
				return _sink.Read(buffer, offset, count);
			}

			public override long Seek(long offset, SeekOrigin origin)
			{
				return _sink.Seek(offset, origin);
			}

			public override void SetLength(long value)
			{
				_sink.SetLength(value);
			}

			public override void Close()
			{
				_sink.Close();
			}

			public override void Write(byte[] buffer, int offset, int count)
			{
				byte[] data = new byte[count];
				Buffer.BlockCopy(buffer, offset, data, 0, count);
				string html = System.Text.Encoding.Default.GetString(buffer);

				html = reg.Replace(html, "\n");

				byte[] outdata = System.Text.Encoding.Default.GetBytes(html);
				_sink.Write(outdata, 0, outdata.GetLength(0));
			}

			#endregion

		}
	}

	public class RootYonlendir : IHttpModule
	{
		public void Init(HttpApplication app)
		{
			if (bool.Parse(Class.Fonksiyonlar.Genel.OzelAyar("RootYonlendir")))
			{
				app.BeginRequest += new EventHandler(app_BeginRequest);	
			}
		}

		protected void app_BeginRequest(object sender, EventArgs e)
		{
			HttpApplication app = sender as HttpApplication;
			Uri currentUri = app.Request.Url;

			if (currentUri.PathAndQuery == "/" && currentUri.LocalPath == "/" && currentUri.Segments[0] == "/")
			{
				RedirectPermanently(app.Response, "/" + Class.Fonksiyonlar.Genel.OzelAyar("URL"));
			}
		}

		public static void RedirectPermanently(HttpResponse res, string location)
		{
			res.Status = "301 Moved Permanently";
			res.AddHeader("Location", location);
			res.Flush();
			res.End();
		}

		public void Dispose()
		{
		}
	}
}