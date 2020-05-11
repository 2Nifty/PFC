<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Option.ascx.cs" Inherits="MaintenanceApps_Common_UserControls_Option" %>
<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center">
    <tr>
        <td colspan="5" class="lightBlueBg" style="padding-top: 5px;" nowrap="nowrap" runat="server"
            id="tdHeader">
            <asp:Label ID="lblctrlHeader" CssClass="BanText" runat="server" Text="Options"></asp:Label>
        </td>
        <td align="right" class="Left2pxPadd lightBlueBg" style="padding-top: 5px;padding-right:8px;">
            <asp:ImageButton ID="btnSave" runat="server" ImageUrl="~/MaintenanceApps/Common/Images/BtnSave.gif"
                OnClick="btnSave_Click" />
            <asp:ImageButton ID="btnOptionClose" runat="server" ImageUrl="~/MaintenanceApps/Common/images/cancel.png" OnClick="btnOptionClose_Click" />
        </td>
    </tr>
    <tr>
        <td colspan="6">
            <table cellpadding="0" cellspacing="0" width="90%" align="center">
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Credit Check Code
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlCreditCheckCode" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Ship Hold Code
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlShipHoldCode" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        PO Form</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlPOForm" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Delinquent Days
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:TextBox ID="txtDelinquentDays" runat="server" MaxLength="5" onkeypress="javascript:ValdateNumber();"
                            CssClass="FormCtrl"></asp:TextBox></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" height="20px" style="padding-top: 5px;">
                        Allocation Type
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlAllocationType" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Item Prompt</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlItemPrompt" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Ship From Location
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:TextBox ID="txtShipFromLocation" MaxLength="5" runat="server" onkeypress="javascript:ValdateNumber();"
                            CssClass="FormCtrl"></asp:TextBox></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        AP Checks
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlAPChecks" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Shipper Form</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlShipperForm" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Short Code
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:TextBox ID="txtShortCd" MaxLength="3" runat="server" CssClass="FormCtrl"></asp:TextBox>
                    </td>
                    <td class="Left2pxPadd DarkBluTxt boldText">
                        Blind Receiver
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlBlindReceiver" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Statement
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlStatement" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Cost % Price
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <%--<asp:DropDownList ID="ddlCostpctPrice" Height=20px CssClass="FormCtrl" Width=127px runat="server">
                        </asp:DropDownList>--%>
                        <asp:TextBox ID="txtCostpctPrice" onkeypress="javascript:ValdateNumber();" CssClass="FormCtrl"
                            runat="server">
                        </asp:TextBox></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        BOL Form
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlBOLForm" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Supp Desc Print
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd " style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlSuppDescPrint" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Big Quote Minimum
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:TextBox ID="txtBigQuoteMin" onkeypress="javascript:ValdateNumberWithDot();" CssClass="FormCtrl"
                            runat="server">
                        </asp:TextBox></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Freight Expedite
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlFreightExpedite" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Vendor PO
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlVendorPO" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Transfer Vendor #
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:HiddenField ID="hidTransferVendor" runat="server" />
                        <asp:TextBox ID="txtTransferVendor" AutoPostBack="true" runat="server" CssClass="FormCtrl"
                            OnTextChanged="txtTransferVendor_TextChanged"></asp:TextBox></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Invoice Form
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlInvoiceForm" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        US Duty Calc Required
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlDutyCalc" Height="20px" CssClass="FormCtrl" Width="127px"
                            runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Default Vendor #
                    </td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        <asp:HiddenField ID="hidDefaultVendor" runat="server" />
                        <asp:TextBox ID="txtDefaultVendor" AutoPostBack="true" runat="server" CssClass="FormCtrl"
                            OnTextChanged="txtDefaultVendor_TextChanged"></asp:TextBox></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;"></td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;"></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;"></td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;"></td>
                </tr>
                <tr>
                    <td colspan="6" align="center" style="padding-bottom: 10px; padding-top: 10px;">
                        <div align="left" style="width: 75%;" class="blueBorder">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="height: 22px;" class="lightBlueBg">
                                        <asp:CheckBox ID="chkSelectAll" runat="server" Text="Select / Deselect All" AutoPostBack="True"
                                            OnCheckedChanged="chkSelectAll_CheckedChanged" ForeColor="#CC0000" TabIndex="7"
                                            Font-Bold="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 5px;">
                                        <asp:CheckBoxList ID="chkSelection" TextAlign="right" runat="server" Height="20px"
                                            RepeatColumns="4" RepeatDirection="Horizontal" AutoPostBack="false" TabIndex="8"
                                            Font-Bold="True" Width="100%">
                                            <asp:ListItem>Cost Center</asp:ListItem>
                                            <asp:ListItem>Transfer</asp:ListItem>
                                            <asp:ListItem>Prompt Reason Code</asp:ListItem>
                                            <asp:ListItem>SO Detail Screen</asp:ListItem>
                                            <asp:ListItem>Group Pricing</asp:ListItem>
                                            <asp:ListItem>Duplicate Items</asp:ListItem>
                                            <asp:ListItem>Use Queues</asp:ListItem>
                                            <asp:ListItem>Freight Collection Required</asp:ListItem>
                                            <asp:ListItem>Enter Ship To</asp:ListItem>
                                            <asp:ListItem>Request PO </asp:ListItem>
                                            <asp:ListItem>Dimension</asp:ListItem>
                                            <asp:ListItem>Use EDI</asp:ListItem>
                                            <asp:ListItem>Maintain IM Qty</asp:ListItem>
                                            <asp:ListItem>Requisition Request</asp:ListItem>
                                            <asp:ListItem>SO Display Product</asp:ListItem>
                                            <asp:ListItem>Allow Split EDI</asp:ListItem>
                                        </asp:CheckBoxList></td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
        </table> </td>
    </tr>
</table>
