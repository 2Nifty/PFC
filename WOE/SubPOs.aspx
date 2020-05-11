<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="SubPOs.aspx.cs"  Inherits="SubPOs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sub-Contractor POs</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script>
    function ShowPO(POControl) 
    {
        window.open("<%=POESiteURL %>POrderEntry.aspx",'SubPORecpt','height=768,width=1024,toolbar=0,scrollbars=0,status=0,resizable=0,top='+((screen.height/2) - (768/2))+',left='+((screen.width/2) - (1024/2))+'','');    
    }
    </script>
</head>
<body class="PageBg" onload="window.focus();" onblur="window.focus();">
    <form id="form1" runat="server">
        <div id="header" class="BlueBorder">
            <h1 style="padding-top: 10px; padding-left: 5px">
                Sub-Contractor Purchase Orders
            </h1>
        </div>
        <div>
            <table cellpadding="0" cellspacing="0" border="0" width="100%" style="height: 320px;">
                <tr>
                    <td valign="top" class="10pxPadding">
                        <asp:GridView ID="gvPOs" runat="server" AutoGenerateColumns="false" BackColor="#ECF9FB"
                            BorderColor="#9AB8C3" OnRowDataBound="gvPOs_OnRowDataBound">
                            <HeaderStyle HorizontalAlign="Center" CssClass="WOGridHead" Font-Bold="True" BackColor="#DFF3F9" />
                            <Columns>
                                <asp:TemplateField HeaderText="PO Number" ItemStyle-Width="80px" >
                                    <ItemTemplate>
                                        <asp:HyperLink ID="HyperLink1" CssClass="redLink Left2pxPadd" runat="server" NavigateUrl="javascript:ShowPO(this)" Text='<%#DataBinder.Eval(Container.DataItem,"POOrderNo") %>'></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="BuyFromVendorNo" HeaderText="Vend No." ItemStyle-Width="60px" ItemStyle-HorizontalAlign="center" />
                                <asp:BoundField DataField="VendorAlphaCd" HeaderText="Short Code" ItemStyle-Width="80px" ItemStyle-HorizontalAlign="center" />
                                <asp:BoundField DataField="BuyFromName" HeaderText="Vendor" ItemStyle-Width="160px" />
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
        <div>
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                    <td align="right">
                        <asp:ImageButton ID="ImageButton1" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                            AlternateText="Close" ImageUrl="~/Common/Images/close.gif" OnClientClick="window.close();" />
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
