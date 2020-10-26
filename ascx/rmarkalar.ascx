<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        h1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 38);
    }
</script>
<!--MARKALAR-->
<asp:PlaceHolder ID="phmarka" runat="server">
<div id="rmarkalar" class="rsagi">
    <h1>
        <asp:Literal ID="h1" runat="server"></asp:Literal></h1>
    <asp:Literal ID="litmarka" runat="server"></asp:Literal>
</div>
</asp:PlaceHolder>
<!--MARKALAR-->