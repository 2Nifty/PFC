<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Warehouse.ascx.cs" Inherits="MaintenanceApps_Common_UserControls_Warehouse" %>
<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center">
    <tr>
        <td colspan="5" class="lightBlueBg" style="padding-top: 5px;" nowrap="nowrap" runat="server"
            id="tdHeader">
            <asp:Label ID="lblctrlHeader" CssClass="BanText" runat="server" Text="Warehouse Options"></asp:Label>
        </td>
        <td align="right" class="Left2pxPadd lightBlueBg" style="padding-top: 5px;padding-right:8px;">
            <asp:ImageButton ID="btnSave" runat="server" ImageUrl="~/MaintenanceApps/Common/Images/BtnSave.gif"
                OnClick="btnSave_Click" />
            <asp:ImageButton ID="btnWarehouseClose" runat="server" ImageUrl="~/MaintenanceApps/Common/images/cancel.png" OnClick="btnOptionClose_Click" />
        </td>
    </tr>
    <tr>
        <td colspan="6">
            <table cellpadding="0" cellspacing="0" width="90%" align="center">
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        ASN Odometer
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlASNOdometer" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Prompt Rec Bin
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlPromptRecBin" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Serial # Print</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlSerialPrint" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Create LPN
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlCreateLPN" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Pallet
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlPallet" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Shipping Label</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlShippingLabel" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        End Carton Docs
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlEndCartonDocs" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText">
                        Receive Mode</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlReceiveMode" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Shipping Module</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlShippingModule" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Invoice Print
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlInvoicePrint" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Reform to Item</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlReformtoItem" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Shipping Method
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlShippingMethod" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Lot Track
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlLotTrack" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        RF Print
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlRFPrint" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Shipped Order
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd " style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlShippedOrder" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Packing Slip Print
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlPackingSlipPrint" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        ROP Days
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <%--  <asp:DropDownList ID="ddlROPDays" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList>--%>
                        <asp:TextBox ID="txtROPDays" onkeypress="javascript:ValdateNumber();" CssClass="FormCtrl"
                            runat="server">
                        </asp:TextBox></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Support Rep
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlSupportRep" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Pick End Order</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlPickEndOrder" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Serial #</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlSerial" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px;">
                        Transaction Set
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                        <asp:DropDownList ID="ddlTransactionSet" Height="20px" CssClass="FormCtrl" runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td colspan="4" align="center" style="padding-bottom: 10px; padding-top: 10px;">
                        <div align="left" style="width: 95%;" class="blueBorder">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="height: 22px;" valign="middle" class="lightBlueBg">
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
                                            <asp:ListItem>Comp Item Ship</asp:ListItem>
                                            <asp:ListItem>ILT Batch Control</asp:ListItem>
                                            <asp:ListItem>Phys Activation</asp:ListItem>
                                            <asp:ListItem>Use Odometer</asp:ListItem>
                                            <asp:ListItem>Default Bin</asp:ListItem>
                                            <asp:ListItem>LPN Control</asp:ListItem>
                                            <asp:ListItem>Print Carton</asp:ListItem>
                                            <asp:ListItem>Allow Partial Receipts</asp:ListItem>
                                            <asp:ListItem>Default Item</asp:ListItem>
                                            <asp:ListItem>Move Doc </asp:ListItem>
                                            <asp:ListItem>Ship Confirm </asp:ListItem>
                                            <asp:ListItem>Use Scale</asp:ListItem>
                                            <asp:ListItem>Default Sell stk UM</asp:ListItem>
                                            <asp:ListItem>Multiple UM</asp:ListItem>
                                            <asp:ListItem>Ship in Full</asp:ListItem>
                                            <asp:ListItem>Default Primary From Bin</asp:ListItem>
                                        </asp:CheckBoxList></td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td colspan="2" align="center" valign="top" style="padding-bottom: 10px; padding-top: 10px;">
                        <div align="left" style="width:95%; height:120px;" class="blueBorder">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding-left: 5px; height: 22px; color: #CC0000; font-weight: bold;" class="lightBlueBg">
                                        Virtual Location
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div>
                                            <table cellpadding="0" cellspacing="0" width="100%" align="center">
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                                                        Name
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                                                        <asp:TextBox ID="txtVLocName" CssClass="FormCtrl" runat="server" width="180px" MaxLength="30">
                                                        </asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                                                        No.
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                                                        <asp:TextBox ID="txtVLocNo" CssClass="FormCtrl" runat="server" width="100px" MaxLength="10">
                                                        </asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                                                        Bin Zone
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 5px;">
                                                        <asp:TextBox ID="txtVLocZone" CssClass="FormCtrl" runat="server" width="100px" MaxLength="2">
                                                        </asp:TextBox></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>