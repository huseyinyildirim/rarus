<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        using (MySQLDataModel.BaglantiCumlesi SME = new MySQLDataModel.BaglantiCumlesi())
        {
            int DilID = Class.Fonksiyonlar.Dil.ID();
            
            var SQL = (from p in SME.tbl_ikonlar
                       where p.dil_id == DilID && p.onay == true && p.yer == (int)Class.Sabitler.Hiza.Yer.Ust
                       select p);

            if (SQL.Count() > 0)
            {
                image.ImageUrl = "../images/other/" + (SQL).Where(x => x.konum == (int)Class.Sabitler.Hiza.Konum.Sag).Select(x => x.ikon).FirstOrDefault();
                image.Attributes.Add("alt", (SQL).Where(x => x.konum == (int)Class.Sabitler.Hiza.Konum.Sag).Select(x => x.alt).FirstOrDefault());
            }
            else
            {
               image.Visible = false;
            }
        }
    }
</script>
<!--SAG RIBBON-->
<div id="rribbon">
    <asp:Image runat="server" ID="image" />
</div>
<!--SAG RIBBON-->