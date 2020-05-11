<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Profitometer.ascx.cs" Inherits="Profitometer" %>
<asp:Panel ID="ThermoPanel" runat="server"  onmouseover="profitMouseOver(this);" onmouseout="profitMouseOut();"
    Height="5px" Width="5px" BorderColor="Black" BorderStyle="Solid" BorderWidth="1">
    <asp:Label ID="thermoTop" runat="server" Text=""></asp:Label>
    <asp:Label ID="thermoBottom" runat="server" Text=""></asp:Label>
    <asp:HiddenField ID="profitPrice" runat="server" />
    <asp:HiddenField ID="profitText" runat="server" />
    <SCRIPT >
    var oPopup = window.createPopup();
    function profitMouseOver(meter)
    {
        var profitTextId = meter.id.split("_")[0] + "_profitText";
        if ($get(profitTextId).value != "")
        {
            var profitparent = meter.parentElement;
            var posx = parseInt(profitparent.getAttribute('offsetLeft'), 10);
            var posy = parseInt(profitparent.getAttribute('offsetTop'), 10) + 250;
            var oPopBody = oPopup.document.body;
            oPopBody.style.backgroundColor = "white";
            oPopBody.style.border = "solid blue 3px";
            oPopBody.style.font = 'bold 10pt Arial, sans-serif';
            oPopBody.innerHTML = $get(profitTextId).value;
            oPopup.show(posx, posy, 250, 120, document.body);
        }
    }
    function profitMouseOut()
    {
        oPopup.hide();
    }
    </SCRIPT>
</asp:Panel>
