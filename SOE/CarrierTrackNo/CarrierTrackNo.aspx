<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CarrierTrackNo.aspx.cs" Inherits="CarrierTrackNo" %>

<%@ Register Src="Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
<title>Carrier Tracking Number Entry</title>
<link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

<script language="javascript">

    function Close()
    {
        parent.window.close();
    }

    function LoadHelp()
        {
        window.open('Help.htm','Help','height=600,width=900,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (600/2))+',left='+((screen.width/2) - (900/2))+',resizable=no','');
        }

</script>

</head>
<body>
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="100%" height="267" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="2" valign="middle">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" colspan="2">
                                            <uc1:PageHeader ID="PageHeader1" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="PageHead" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">Carrier Tracking Number Entry</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img id="btnHelp" src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                                    <img id="btnClose" src="../Common/Images/close.gif" style="cursor: hand" runat="server" onclick="javascript:Close();" />
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr style="padding-left: 10px;">
                            <td width="38%" valign="top">
                                <table border="0" cellpadding="5" cellspacing="0">
                                    <tr>
                                        <td style="width: 100px">
                                            <asp:Label ID="lblOrderNo" runat="server" Text="Sales Order No:"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtOrderNo" runat="server" CssClass="FormCtrl" MaxLength="15" Width="100px" TabIndex="1"
                                                AutoPostBack="true" OnFocus="javascript:this.select();" OnTextChanged="txtOrderNo_TextChanged"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                                <asp:Panel ID="pnlInfo1" DefaultButton="btnUpd" runat="server">
                                    <table id="tSOInfo1" runat="server" border="0" cellpadding="5" cellspacing="0">
                                        <tr>
                                            <td style="width: 100px">
                                                Customer PO No:
                                            </td>
                                            <td>
                                                <asp:Label ID="lblCustPO" runat="server" Text="~Cust PO~"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px">
                                                <asp:Label ID="lblCarTrackNo" runat="server" Text="Carrier Tracking No:"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtCarTrackNo" runat="server" CssClass="FormCtrl" MaxLength="20" TabIndex="2"
                                                    Width="125px" OnFocus="javascript:this.select();"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px">
                                                <asp:Label ID="lblCarrier" runat="server" Text="Carrier:"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlCarrier" Height="20px" CssClass="FormCtrl" runat="server" TabIndex="3"></asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </td>
                            <td>
                                <table id="tSOInfo2" runat="server" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="7%" style="padding-left: 5px; border-left: solid thin lightblue; font-weight: bold">
                                            Sold To:
                                        </td>
                                        <td width="24%">
                                            <asp:Label ID="lblSellToName" runat="server" Text="~Sell To Name~"></asp:Label>
                                        </td>
                                        <td width="7%" style="padding-left: 5px; border-left: solid thin lightblue; font-weight: bold">
                                            Ship To:
                                        </td>
                                        <td width="24%">
                                            <asp:Label ID="lblShipToName" runat="server" Text="~Ship To Name~"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">
                                            <asp:Label ID="lblSellToNo" runat="server" Text="~999999~"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblSellToAddress1" runat="server" Text="~Sell To Address1~"></asp:Label>
                                        </td>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">
                                            <asp:Label ID="lblShipToNo" runat="server" Text="~999999~"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblShipToAddress1" runat="server" Text="~Ship To Address1~"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">&nbsp;</td>
                                        <td>
                                            <asp:Label ID="lblSellToAddress2" runat="server" Text="~Sell To Address2~"></asp:Label>
                                        </td>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">
                                            &nbsp;</td>
                                        <td>
                                            <asp:Label ID="lblShipToAddress2" runat="server" Text="~Ship To Address2~"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">&nbsp;</td>
                                        <td>
                                            <asp:Label ID="lblSellToPhone" runat="server" Text="~Sell To Phone~"></asp:Label>
                                        </td>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">&nbsp;</td>
                                        <td>
                                            <asp:Label ID="lblShipToPhone" runat="server" Text="~Ship To Phone~"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">&nbsp;</td>
                                        <td>
                                            Order Contact:
                                            <asp:Label ID="lblSellToContact" runat="server" Text="~Sell To Contact~"></asp:Label>
                                        </td>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">
                                            &nbsp;</td>
                                        <td>
                                            Contact:
                                            <asp:Label ID="lblShipToContact" runat="server" Text="~Ship To Contact~"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">&nbsp;</td>
                                        <td></td>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">&nbsp;</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td width="7%" style="padding-left: 5px; border-left: solid thin lightblue; font-weight: bold">
                                            Bill To:
                                        </td>
                                        <td>
                                            <asp:Label ID="lblBillToTerms" runat="server" Text="~Bill To Terms~"></asp:Label>
                                        </td>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">&nbsp;</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">
                                            <asp:Label ID="lblBillToNo" runat="server" Text="~999999~"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblBillToName" runat="server" Text="~Bill To Name~"></asp:Label>
                                        </td >
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">&nbsp;</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">&nbsp;</td>
                                        <td></td>
                                        <td style="padding-left: 5px; border-left: solid thin lightblue;">&nbsp;</td>
                                        <td></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table id="tUpdate" runat="server" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="BluBg" width="787px">
                                <table id="tStatus" runat="server" visible="false" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" style="padding-left: 10px; font-weight: bold; color: Red;">
                                            <asp:Label ID="lblStatus" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="BluBg">
                                <div runat="server" id=divUpdate visible="false" class="LeftPadding">
                                    <span style="vertical-align: middle; padding-top: 10px; padding-bottom: 10px;">
                                        <asp:ImageButton ID="btnUpd" runat="server" ImageUrl="../Common/Images/update.gif" style="cursor: hand" OnClick="btnUpd_Click" TabIndex="4" />
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
