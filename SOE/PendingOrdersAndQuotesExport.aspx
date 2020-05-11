<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PendingOrdersAndQuotesExport.aspx.cs"
    Inherits="PendingOrdersAndQuotes" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="CEHeader" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE- Pending Orders & Quotes</title>
    <link href="http://206.72.71.194/SOE/Common/StyleSheet/printstyles.css" rel="stylesheet"
        type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <table class="PageBg" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td bgcolor="white">
                    <asp:Image ID="imglogo" runat="server" ImageUrl="http://206.72.71.194/SOE/Common/Images/PFC_logo.gif" />
                </td>
            </tr>
            <tr>
                <td class="lightBg" valign="top" style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                    <table height="90" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="width: 100px;">
                                <asp:Label ID="Label1" runat="server" Text="Customer Number" Font-Bold="True" Width="126px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblCustNo" runat="server" Font-Bold="True" Width="106px"></asp:Label>
                            </td>
                            <td style="width: 50px">
                            </td>
                            <td style="width: 30px;">
                                <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Order Type" Width="120px"></asp:Label></td>
                            <td style="width: 30px;">
                                <asp:Label ID="lblOrderType" runat="server" Font-Bold="True" Width="106px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Location" Width="106px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblLocation" runat="server" Font-Bold="True" Width="106px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Start Date" Width="70px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblStartDt" runat="server" Font-Bold="True" Width="106px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="height: 16px;font-weight:bold;">
                             User ID
                            </td>
                            <td style="height: 16px;">
                            <asp:Label ID="lblUserID" runat="server" Font-Bold="True" Width="106px"></asp:Label>
                            </td>
                            <td style="height: 16px">
                            </td>
                            <td style="height: 16px;">
                                <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="End Date" Width="70px"></asp:Label></td>
                            <td style="height: 16px;">
                                <asp:Label ID="lblEndDt" runat="server" Font-Bold="True" Width="106px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="height: 16px">
                            </td>
                            <td style="height: 16px">
                            </td>
                            <td style="height: 16px">
                            </td>
                            <td style="height: 16px">
                            </td>
                            <td style="height: 16px">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBg"  valign="top" style="padding: 5PX;">
                    <table cellpadding="0" cellspacing="0" width="100%" align="center">
                        <tr>
                            <td colspan="2">
                                <asp:GridView ShowFooter="false" ID="gvPendingOrders" PagerSettings-Visible="false"
                                    Width="850" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="false"
                                    AutoGenerateColumns="false">
                                    <HeaderStyle HorizontalAlign="center" Height="20px" CssClass="GridHead" Font-Bold="true" />
                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                    <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                    <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                    <Columns>
                                        <asp:BoundField HeaderText="Order Type" DataField="OrderType" SortExpression="OrderType"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Ship Loc" DataField="ShipLoc" SortExpression="ShipLoc"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Order No." DataField="OrderNo" SortExpression="OrderNo"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Customer No." DataField="SellToCustNo" SortExpression="SellToCustNo"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Customer Name" DataField="SellToCustName" SortExpression="SellToCustName"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="150px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Order Amt." DataField="TotalOrder" SortExpression="TotalOrder"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Order Date" DataField="OrderDt" SortExpression="OrderDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Cust Req’d" DataField="CustReqDt" SortExpression="CustReqDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Status" DataField="OrderStatus" SortExpression="OrderStatus"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Entry ID" DataField="EntryID" SortExpression="EntryID"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Entry Date" DataField="EntryDt" SortExpression="EntryDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Deleted Date" DataField="DeleteDt" SortExpression="DeleteDt"
                                            ItemStyle-CssClass="Left5pxPadd" Visible="false">
                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView><input id="hidLocationCode" type="hidden" name="hidPrintURL" runat="server">
                                <input id="hidOrderType" type="hidden" name="hidPrintURL" runat="server">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
