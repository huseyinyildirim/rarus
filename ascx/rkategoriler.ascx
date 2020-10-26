<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        h1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 4);
    }
</script>
<!--KATEGORILER-->
<div id="rmenu" class="rsagi">
    <h1 style="margin-top: 0">
        <asp:Literal ID="h1" runat="server"></asp:Literal></h1>
    <asp:Literal ID="litkategori" runat="server"></asp:Literal>
</div>
<!--KATEGORILER-->