<%@ Page Language="C#"%>

<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        int DilID = Class.Fonksiyonlar.Dil.ID();

        Response.Clear();
        Response.ContentType = "text/xml";

        using (System.Xml.XmlTextWriter XTW = new System.Xml.XmlTextWriter(Response.OutputStream, Encoding.UTF8))
        {
            using (MySQLDataModel.BaglantiCumlesi SME = new MySQLDataModel.BaglantiCumlesi())
            {
                //SELECT s.dil_id,d.dil,s.sabitler_id,s.text,t.sayfa FROM tbl_textler s, tbl_sbt_sabit t, tbl_diller d WHERE t.xml=1 AND s.sabitler_id=t.id AND s.dil_id=d.id

                var SQL = (from s in SME.tbl_textler
                           from t in SME.tbl_sbt_sabit
                           from d in SME.tbl_diller
                           from k in SME.tbl_sbt_ulke
                           where t.xml == true && s.sabitler_id == t.id && s.dil_id == DilID && s.onay == true && s.dil_id==d.id && d.ulke_id == k.id
                           orderby s.sabitler_id ascending
                           select new
                           {
                               kisaltma = (k.dil_kisaltma == null ? k.kisaltma : k.dil_kisaltma),
                               s.sabitler_id,
                               s.text,
                               t.sayfa
                           });

                try
                {
                    XTW.WriteStartDocument();

                    XTW.WriteWhitespace("\n");
                    XTW.WriteWhitespace("\n");
                    XTW.WriteStartElement("texts");
                    XTW.WriteWhitespace("\n");

                    foreach (var i in SQL)
                    {
                        XTW.WriteWhitespace("\n");
                        XTW.WriteStartElement(i.sayfa, i.sabitler_id.ToString());

                        XTW.WriteWhitespace("\n");
                        {
                            XTW.WriteElementString("dil", i.kisaltma);
                            XTW.WriteWhitespace("\n");
                            XTW.WriteElementString("id", i.sabitler_id.ToString());
                            XTW.WriteWhitespace("\n");
                            XTW.WriteElementString("text", i.text);
                            XTW.WriteWhitespace("\n");
                            XTW.WriteElementString("sayfa", i.sayfa);
                        }

                        XTW.WriteWhitespace("\n");
                        XTW.WriteEndElement();
                        XTW.WriteWhitespace("\n");
                    }

                    XTW.WriteWhitespace("\n");
                    XTW.WriteEndElement();

                    XTW.WriteEndDocument();
                }
                catch
                {
                }
            }
        }

        Response.End();
    }
</script>