<%@ Page Language="C#" AspCompat="true" AutoEventWireup="true" CodeFile="PalletLabel.aspx.cs" Inherits="PalletLabel" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer2" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <script>
        var LabelWindow;
        function pageUnload() 
        {
            if (LabelWindow != null) {LabelWindow.close();LabelWindow=null;}
        }
        function ClosePage()
        {
            window.close();	
        }

        function OpenLabel()
        {
            if (LabelWindow != null) {LabelWindow.close();LabelWindow=null;}
            //alert(BTW);
            LabelWindow=window.open(document.getElementById("hidLabelPath").value,'BartenderWin','height=750,width=1000,toolbar=0,scrollbars=0,status=1,resizable=YES','');  
            return false;  
        }

    </script>

    <style type="text/css">
    .Text 
        {
	    font-family: Arial, Helvetica, sans-serif;
	    font-size: 14px;
	    color: #000000;
	    text-decoration:none;
        }

    </style>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <title>Pallet Labels</title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="PalletLabelScriptManager" runat="server" EnablePartialRendering="true" />
        <div>
            <asp:UpdatePanel ID="MainUpdatePanel1" runat="server">
                <ContentTemplate>
                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td class="PageHead" style="height: 40px" width="75%">
                                <div class="LeftPadding">
                                    <div align="left" class="BannerText">
                                        EDI ASN Shipping Pallet Label</div>
                                </div>
                                <asp:HiddenField ID="hidOrderNo" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="updpnlSelector" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td style="width: 200px;">
                                                    &nbsp;&nbsp;&nbsp;<b>Warehouse Order Number</b>&nbsp;&nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtOrderNumber" runat="server"></asp:TextBox>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td class="Text Left2pxPadd">
                                <asp:UpdatePanel ID="updpnlOrder" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td colspan="5">
                                                    <b>Order</b> &nbsp;<asp:Label ID="lblOrderNumber" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd" style="width: 135px;">
                                                    <b>Sell To</b>
                                                </td>
                                                <td style="width: 25px;" rowspan="6">
                                                    &nbsp;
                                                </td>
                                                <td class="Left2pxPadd" style="width: 135px;">
                                                    <b>Ship To</b>
                                                </td>
                                                <td style="width: 25px;" rowspan="6">
                                                    &nbsp;
                                                </td>
                                                <td class="Left2pxPadd" style="width: 135px;">
                                                    <b>Branch:</b>&nbsp;<asp:Label ID="lblBranchNo" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" class="Left2pxPadd">
                                                    <asp:Label ID="lblSellToNo" runat="server"></asp:Label>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td align="left" class="Left2pxPadd">
                                                    <asp:Label ID="lblBranchName" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" class="Left2pxPadd">
                                                    <asp:Label ID="SellToName" runat="server"></asp:Label>
                                                </td>
                                                <td align="left" class="Left2pxPadd">
                                                    <asp:Label ID="ShipToName" runat="server"></asp:Label>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" class="Left2pxPadd">
                                                    <asp:Label ID="SellToAddr1" runat="server"></asp:Label>
                                                </td>
                                                <td align="left" class="Left2pxPadd">
                                                    <asp:Label ID="ShipToAddr1" runat="server"></asp:Label>
                                                </td>
                                                <td align="left" class="Left2pxPadd">
                                                    <b>Date:</b>&nbsp;<asp:Label ID="lblDocDate" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" class="Left2pxPadd">
                                                    <asp:Label ID="SellToAddr2" runat="server"></asp:Label>
                                                </td>
                                                <td align="left" class="Left2pxPadd">
                                                    <asp:Label ID="ShipToAddr2" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" class="Left2pxPadd">
                                                    <asp:Label ID="SellToCityStZip" runat="server"></asp:Label>
                                                </td>
                                                <td align="left" class="Left2pxPadd">
                                                    <asp:Label ID="ShipToCityStZip" runat="server"></asp:Label>
                                                </td>
                                                <td align="left" class="Left2pxPadd">
                                                    <b>Format:</b>&nbsp;<asp:Label ID="lblFormat" runat="server"></asp:Label>
                                                    <asp:HiddenField ID="hidLabelPath" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg">
                                <asp:Panel ID="pnlBottom" runat="server">
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                        <tr>
                                            <td align="left" style="width: 200px;" valign="middle">
                                                <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        &nbsp;&nbsp;&nbsp;
                                                        <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                                        <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                            <td>
                                                <div class="LeftPadding">
                                                    <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        <asp:ImageButton ID="SearchSubmit" ImageUrl="../Common/Images/submit.gif" Style="cursor: hand"
                                                            runat="server" OnClick="SearchSubmit_Click" />&nbsp;&nbsp;
                                                        <asp:ImageButton ID="PrintLabel" OnClientClick="OpenLabel();" OnClick="PrintLabel_Click" AlternateText="Print Label"
                                                            runat="server" ImageUrl="../Common/Images/Print.gif" CausesValidation="false" />
                                                        <asp:ImageButton ID="PrintCancel" ImageUrl="../Common/Images/Cancel.gif" runat="server"
                                                            OnClick="PrintCancel_Click" />
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                &nbsp;
                                                <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                                                    <ProgressTemplate>
                                                        Processing. One Moment.......
                                                    </ProgressTemplate>
                                                </asp:UpdateProgress>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </td>
                        </tr>
                        <%--            <tr>
                <td>
                    <uc2:Footer2 id="PageFooter2" runat="server">
                    </uc2:Footer2>
                </td>
            </tr>
--%>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
