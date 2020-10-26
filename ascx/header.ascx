<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
 
    protected void Page_Load(object sender, EventArgs e)
    {
        using (MySQLDataModel.BaglantiCumlesi SME = new MySQLDataModel.BaglantiCumlesi())
        {
            int DilID = Class.Fonksiyonlar.Dil.ID();
            var R = new Random();

            var SQL = (from p in SME.tbl_headerlar
                       where p.dil_id == DilID && p.onay == true
                       select new { p.baslik, p.text, p.resim }).AsEnumerable().OrderBy(x => R.Next()).Take(1);

            foreach (var i in SQL)
            {
             StringBuilder SB = new StringBuilder();

             SB.Append("$(function () {\r\n");
             SB.Append("var img = new Image();\r\n");
             SB.Append("$(img).load(function () {\r\n");
             SB.Append("//$(this).css(\"display\", \"none\"); // .hide() doesn\"t work in Safari when the element isn\"t on the DOM already\r\n");
             SB.Append("$(this).hide();\r\n");
             SB.Append("$(\"#himg\").removeClass(\"loading\").append(this);\r\n");
             SB.Append("$(this).fadeIn(\"slow\");\r\n");
             SB.Append("}).error(function () {\r\n");
             SB.Append("$(\"#himg\").removeClass(\"loading\").append(this);\r\n");
             SB.Append("$(\"#himg\").html(\"<p>Image could not be loaded!</p>\");\r\n");
             SB.Append("}).attr(\"src\",");
             SB.Append("\"" + "/ashx/header-image.ashx?i=" + i.resim + "&w=421&h=237" + "");
             SB.Append("\").attr(\"alt\",");
             SB.Append("\"" + i.baslik + "\"");
             SB.Append(");\r\n");
             SB.Append("});");

             Class.Fonksiyonlar.JavaScript.Ekle(SB.ToString());

             texth.InnerText = i.baslik;
             textp.InnerText = i.text;
            }
        }
    }
</script>
<!--HEADER-->
<div id="header">
    <div id="hmain">
        <div id="hleft">
            <h1 id="texth" runat="server">
            </h1>
            <p id="textp" runat="server">
            </p>
        </div>
        <div id="hright">
            <div id="hri">
            <div id="himgu">
                <div id="himg" class="loading"></div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--HEADER-->