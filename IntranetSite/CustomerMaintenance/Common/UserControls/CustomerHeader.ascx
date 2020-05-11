<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomerHeader.ascx.cs"
    Inherits="PFC.Intranet.Maintenance.AddressHeader" %>
<table cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td class="lightBlueBg">
            <asp:Label ID="lblInfo" CssClass="BanText" runat="server" Text="Customer"></asp:Label>
        </td>
        <td class="lightBlueBg" align="right" valign=bottom>&nbsp;
            <table border="0" cellpadding="0" cellspacing="0" runat=server id="tblEntryPanel" visible=false>
                <tr>
                    <td style="padding-right:10px;">
                        <span class=""><strong>Entry ID:</strong></span>
                        <asp:Label ID="lblCustMastEntryID" runat="server" Font-Bold="false" Text=""></asp:Label></td>
                    <td style="padding-right:10px;">
                        <span class="" style="padding-left: 5px;"><strong>Entry Date:</strong> </span>
                        <asp:Label ID="lblCustMastEntryDt" runat="server" Font-Bold="false" Text=""></asp:Label></td>
                    <td style="padding-right:10px;">
                        <strong>Change ID:</strong>
                        <asp:Label ID="lblCustMastChangeID" runat="server" Font-Bold="false" Text=""></asp:Label></td>
                    <td style="padding-right:10px;">
                        <strong>Change Date:</strong>
                        <asp:Label ID="lblCustMastChnageDt" runat="server" Font-Bold="false" Text=""></asp:Label></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td id="tdSoldAddress" runat="server" style="padding-top: 5px;">
            <table width="100%">
                <tr>
                    <td>
                        <table cellpadding="2" cellspacing="0" id="tbSoldTo" runat="server">
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt boldText" runat="server" id="tdPayAddress" nowrap="nowrap"
                                    align="left">
                                    <asp:LinkButton ID="lnkSoldto" runat="server" Font-Underline="true" Text="Sold To"
                                        CssClass="TabHead"></asp:LinkButton><br />
                                    <asp:Label ID="lblSoldToCustomerNumber" runat="server" Text="Label"></asp:Label><br />
                                    <div id="divSoldToolTips" class="list" style="display: none; position: absolute;"
                                        onmouseup="return false;">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td colspan=2>Customer Address</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="">Entry ID: </span>
                                                    <asp:Label ID="lblSoldEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                <td>
                                                    <span class="" style="padding-left: 5px;">Entry Date: </span>
                                                    <asp:Label ID="lblSoldEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="">Change ID: </span>
                                                    <asp:Label ID="lblSoldChangeID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                <td>
                                                    <span class="" style="padding-left: 5px;">Change Date: </span>
                                                    <asp:Label ID="lblSoldChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                                <td valign="top">
                                    <asp:Label ID="lblSoldName" runat="server">Sold To Customer Name</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h " nowrap="nowrap">
                                    <asp:Label ID="lblSoldLine1" runat="server">Sold Line1,Sold Line2</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h " nowrap="nowrap">
                                    <asp:Label ID="lblSoldCity" runat="server">City, State, Zip</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h ">
                                    <asp:Label ID="lblSoldCountry" runat="server">Country</asp:Label></td>
                                <td>
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h " nowrap="nowrap">
                                    <span class="boldText">Phone:&nbsp;</span><asp:Label ID="lblSoldPhone" runat="server">Phone</asp:Label></td>
                                <td class="splitBorder_r_h " nowrap="nowrap">
                                    <span class="boldText">Fax:&nbsp;</span><asp:Label ID="lblSoldFax" runat="server">Fax</asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td id="tdBillAddress" runat="server" style="padding-top: 5px;">
            <table width="100%">
                <tr>
                    <td>
                        <table cellpadding="2" cellspacing="0">
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt boldText" runat="server" id="td2" nowrap="nowrap"
                                    align="left">
                                    <asp:LinkButton ID="lnkBillto" runat="server" Font-Underline="true" Text="Bill To"
                                        CssClass="TabHead"></asp:LinkButton><br />
                                    <asp:Label ID="lblBillToCustomerNumber" runat="server" Text="Label"></asp:Label><br />
                                    <div id="divBillToolTips" class="list" style="display: none; position: absolute;"
                                        onmouseup="return false;">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td colspan=2>Customer Address</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="">Entry ID: </span>
                                                    <asp:Label ID="lblBillEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                <td>
                                                    <span class="" style="padding-left: 5px;">Entry Date: </span>
                                                    <asp:Label ID="lblBillEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="">Change ID: </span>
                                                    <asp:Label ID="lblBillChangeID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                <td>
                                                    <span class="" style="padding-left: 5px;">Change Date: </span>
                                                    <asp:Label ID="lblBillChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                                <td valign="top">
                                    <asp:Label ID="lblBillName" runat="server">Bill To Customer Name</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h " nowrap="nowrap">
                                    <asp:Label ID="lblBillLine1" runat="server">Bill Line1,Bill Line2</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h " nowrap="nowrap">
                                    <asp:Label ID="lblBillCity" runat="server">City, State, Zip</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h ">
                                    <asp:Label ID="lblBillCountry" runat="server">Country</asp:Label></td>
                                <td>
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h" nowrap="nowrap">
                                    <span class="boldText">Phone:&nbsp;</span><asp:Label ID="lblBillPhone" runat="server">Phone</asp:Label></td>
                                <td class="splitBorder_r_h " nowrap="nowrap">
                                    <span class="boldText">Fax:&nbsp;</span><asp:Label ID="lblBillFax" runat="server">Fax</asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
