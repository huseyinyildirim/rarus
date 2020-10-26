<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        lith1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 7);
    }
</script>
<!--ETIKETLER-->
<asp:PlaceHolder ID="phetiket" runat="server">
<div id="etiket">
    <h1>
        <asp:Literal ID="lith1" runat="server"></asp:Literal></h1>
        <div id="etdiv">
        <asp:Literal ID="litetiket" runat="server"></asp:Literal>
       </div>
</div>
</asp:PlaceHolder>
<!--ETIKETLER-->