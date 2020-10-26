<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        lith1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 46);
        aramabutton.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 45);
    }

    protected void aramabutton_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(aramatext.Text))
        {
            Response.Redirect("/search/" + HttpUtility.HtmlEncode(Class.Fonksiyonlar.Genel.SQLTemizle(aramatext.Text.Trim())));
        }
    }
</script>
<!--ARAMA-->
<div id="arama">
    <h1>
        <asp:Literal ID="lith1" runat="server"></asp:Literal></h1>
    <div id="aramadiv">
        <asp:TextBox ID="aramatext" runat="server" MaxLength="255"></asp:TextBox>
        <asp:Button ID="aramabutton"
            runat="server" onclick="aramabutton_Click"/>
    </div>
</div>
<!--ARAMA-->
