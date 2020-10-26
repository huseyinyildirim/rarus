<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        h1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 8);
    }
</script>
<!--SAG MAIL LISTESI-->
<div id="rmail">
    <h1>
        <asp:Literal ID="h1" runat="server"></asp:Literal></h1>
    <div id="rmailic">
        <div id="rmailicdiv">
        </div>
    </div>
</div>
<!--SAG MAIL LISTESI-->