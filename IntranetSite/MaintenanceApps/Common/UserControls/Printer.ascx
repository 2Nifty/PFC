<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Printer.ascx.cs" Inherits="MaintenanceApps_Common_UserControls_Printer" %>
<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center" >
    <tr>
        <td colspan="5" class="lightBlueBg" style="padding-top: 7px;" nowrap="nowrap" runat="server"
            id="tdHeader">
            <asp:Label ID="lblctrlHeader" CssClass="BanText" runat="server" Text="Default Printers"></asp:Label>
        </td>
        <td align="right" class="Left2pxPadd lightBlueBg" style="padding-top: 7px;padding-right:8px;">
            <asp:ImageButton ID="btnSave" runat="server" ImageUrl="~/MaintenanceApps/Common/Images/BtnSave.gif"
                OnClick="btnSave_Click" />
            <asp:ImageButton ID="btnPrintClose" runat="server" ImageUrl="~/MaintenanceApps/Common/images/cancel.png" OnClick="btnPrintClose_Click" />
        </td>
    </tr>
    <tr>
        <td colspan="6">
            <table cellpadding="0" cellspacing="0" width="60%" align="center">
            <tr><td colspan=4>&nbsp;</td></tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Acknowledgement
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                        <asp:DropDownList ID="ddlAcknowledgement" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                        </asp:DropDownList>
                    </td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 7px;">
                        Pick Sheet
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                        <asp:DropDownList ID="ddlPickSheet" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                        </asp:DropDownList>
                    </td>
                   
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Receiver
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                    <asp:DropDownList ID="ddlReceiver" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                    </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 7px;">
                        Pick Slip
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                        <asp:DropDownList ID="ddlPickSlip"  Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                        </asp:DropDownList>
                    </td>
                   
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Bill of Lading
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                    <asp:DropDownList ID="ddlBillofLading" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                    </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 7px;">
                        Priority Ship</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                        <asp:DropDownList ID="ddlPriorityShip" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                        </asp:DropDownList></td>
                  
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        AP Check
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                        <asp:DropDownList ID="ddlAPCheck" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 7px;">
                        Purchase Order</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                        <asp:DropDownList ID="ddlPurchaseOrder" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                        </asp:DropDownList></td>
                    
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                       Debit Memo
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                        <asp:DropDownList ID="ddlDebitMemo" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                        </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 7px;">
                       Remote Ship
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                        <asp:DropDownList ID="ddlRemoteShip" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                        </asp:DropDownList></td>
                   
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Invoice
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                    <asp:DropDownList ID="ddlInvoice" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                    </asp:DropDownList></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 7px;">
                        Shipping Label
                    </td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                        <asp:DropDownList ID="ddlShippingLabel" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                        </asp:DropDownList></td>
                   
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Commercial Invoice</td>
                    <td  class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                    <asp:DropDownList ID="ddlCommercialInvoice" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                    </asp:DropDownList></td>
                    <td   class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 7px;">
                        Statement</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                    <asp:DropDownList ID="ddlStatement" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                    </asp:DropDownList></td>
                   
                </tr>
                 <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px; padding-left: 15px;">
                        Packing List</td>
                    <td  class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                    <asp:DropDownList ID="ddlPackingList" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                    </asp:DropDownList></td>
                    <td   class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 7px;">
                        WC Ship</td>
                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-top: 7px;">
                    <asp:DropDownList ID="ddlWCShip" Height="20px" CssClass="FormCtrl" runat="server" Width="150px">
                    </asp:DropDownList></td>
                   
                </tr>
                <tr><td class="Left2pxPadd DarkBluTxt boldText"  colspan=4>&nbsp;</td></tr>
            
            </table>
        </td>
    </tr>
</table>