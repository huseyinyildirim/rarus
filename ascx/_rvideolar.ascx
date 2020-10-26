<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        h1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 6);
    }
</script>
<!--SAG MENU-->
<div id="uvid">
    <h1>
        <asp:Literal ID="h1" runat="server"></asp:Literal></h1>
    <div id="uvidic">
        <div id="uvidicdiv">
            <div class="uvidimres">
                <img src="/images/guarantee.png" alt="" /></div>
            <div class="uvidimres">
                <img src="/images/guarantee.png" alt="" /></div>
            <div class="uvidimres">
                <img src="/images/guarantee.png" alt="" /></div>
            <div class="uvidimres">
                <img src="/images/guarantee.png" alt="" /></div>
            <div class="uvidimres">
                <img src="/images/guarantee.png" alt="" /></div>
        </div>
    </div>
</div>
<!--SAG MENU-->