<%@ Control Language="C#" %>
<script runat="server" type="text/C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        h1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 5);
    }
</script>
<!--SAG MENU-->
<div id="ures">
    <h1>
        <asp:Literal ID="h1" runat="server"></asp:Literal></h1>
    <div id="uresic">
        <div id="uresicdiv">
            <div class="uresimres">
                <img src="/images/guarantee.png" alt="" /></div>
            <div class="uresimres">
                <img src="/images/guarantee.png" alt="" /></div>
            <div class="uresimres">
                <img src="/images/guarantee.png" alt="" /></div>
            <div class="uresimres">
                <img src="/images/guarantee.png" alt="" /></div>
            <div class="uresimres">
                <img src="/images/guarantee.png" alt="" /></div>
        </div>
    </div>
</div>
<!--SAG MENU-->