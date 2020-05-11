<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QuoteRecallExport.aspx.cs"
    Inherits="QuoteRecall" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Quote Recall V1.0.0</title>

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>

    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>

    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
    <!-- Used to include print style sheet -->
    <%= PFC.SOE.DataAccessLayer.Global.PrintStyleSheet %>
</head>
<body>
    <form id="form1" runat="server">
        <div class="LandscapeDiv">
            <div id="SheetContainer~|">
                <table width="100%">
                    <tr>
                        <td class="Left5pxPadd">
                            <asp:Panel ID="HeaderPanel" runat="server" Style="border: 1px solid #88D2E9; display: block;">
                                <table width="100%">
                                    <tr>
                                        <td class="Left5pxPadd" valign="top" colspan="5" style="border: 1px solid #88D2E9;
                                            display: block;">
                                            <table>
                                                <tr>
                                                    <td style="font-weight: bold;">
                                                        Customer:
                                                    </td>
                                                    <td>
                                                        <asp:Label CssClass="ws_whitebox_cntr" ID="CustNoTextBox" runat="server" Text=""
                                                            Width="60px" TabIndex="1"></asp:Label>
                                                        <asp:HiddenField ID="QuoteNoHidden" runat="server" />
                                                    </td>
                                                    <td align="right">
                                                        <asp:Label CssClass="ws_whitebox_left" ID="CustNameLabel" runat="server" Text=""
                                                            Width="200"></asp:Label>
                                                    </td>
                                                    <td style="font-weight: bold;">
                                                        <asp:Label ID="SearchColumn" runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="txtSearchText" runat="server" CssClass="ws_whitebox_left" Width="100px"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <asp:Panel ID="DatePanel" runat="server" Width="240px">
                                                <asp:GridView ID="DateGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                    RowStyle-CssClass="priceDarkLabel">
                                                    <AlternatingRowStyle CssClass="priceLightLabel" />
                                                    <Columns>
                                                        <asp:BoundField DataField="QuoteDate" HeaderText="Quote Date" ItemStyle-Width="80"
                                                            DataFormatString="{0:MM/dd/yyyy}" SortExpression="QuoteDate" ItemStyle-HorizontalAlign="center"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteCount" HeaderText="Quotes" ItemStyle-Width="60" SortExpression="QuoteNumber"
                                                            ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                    </Columns>
                                                </asp:GridView>
                                            </asp:Panel>
                                        </td>
                                        <td valign="top">
                                        </td>
                                        <td valign="top">
                                            Quotes on File for
                                            <asp:Label ID="FilterShowingLabel" runat="server" Text="Label"></asp:Label><br />
                                            <asp:Panel ID="QuoteGridPanel" runat="server" EnableViewState="true">
                                                <asp:GridView ID="QuoteGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                    RowStyle-CssClass="priceDarkLabel">
                                                    <AlternatingRowStyle CssClass="priceLightLabel" />
                                                    <Columns>
                                                        <asp:BoundField DataField="Quote" HeaderText="Quote #" ItemStyle-Width="80" SortExpression="Quote"
                                                            ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteLines" HeaderText="Lines" DataFormatString="{0:#,##0} "
                                                            ItemStyle-Width="60" SortExpression="QuoteLines" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteWeight" HeaderText="Total Weight" DataFormatString="{0:#,##0.00} "
                                                            ItemStyle-Width="90" SortExpression="QuoteWeight" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteAmount" HeaderText="Total Amount" DataFormatString="{0:#,##0.00} "
                                                            ItemStyle-Width="90" SortExpression="QuoteAmount" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="Status" HeaderText="Status" ItemStyle-Width="60" SortExpression="Status"
                                                            ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" ConvertEmptyStringToNull="false" />
                                                    </Columns>
                                                </asp:GridView>
                                                <asp:GridView ID="ItemGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                    RowStyle-CssClass="priceDarkLabel">
                                                    <AlternatingRowStyle CssClass="priceLightLabel" />
                                                    <Columns>
                                                        <asp:BoundField DataField="Quote" HeaderText="Quote #" ItemStyle-Width="80" SortExpression="Quote"
                                                            ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteDate" HeaderText="Quote Date" ItemStyle-Width="80"
                                                            DataFormatString="{0:MM/dd/yyyy}" SortExpression="QuoteDate" ItemStyle-HorizontalAlign="center"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteQty" HeaderText="Qty" DataFormatString="{0:#,##0} "
                                                            ItemStyle-Width="40" SortExpression="QuoteQty" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuotePrice" HeaderText="Price" DataFormatString="{0:#,##0.00} "
                                                            ItemStyle-Width="60" SortExpression="QuotePrice" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteAmount" HeaderText="Total Amount" DataFormatString="{0:#,##0.00} "
                                                            ItemStyle-Width="90" SortExpression="QuoteAmount" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="Status" HeaderText="Status" ItemStyle-Width="60" SortExpression="Status"
                                                            ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" ConvertEmptyStringToNull="false" />
                                                    </Columns>
                                                </asp:GridView>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr>
                        <td class="Left5pxPadd" align="left" valign="middle">
                            <table width="100%" style="border: 1px solid #88D2E9; display: block;">
                                <tr>
                                    <td>
                                        <asp:Panel ID="DetailPanel" runat="server">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <b>Quote Extended Weight</b>
                                                        <asp:Label ID="ExtendedWeightLabel" runat="server" Text=""></asp:Label>
                                                    </td>
                                                    <td colspan="5" align="right">
                                                    </td>
                                                </tr>
                                            </table>
                                            <asp:GridView ID="DetailGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                RowStyle-CssClass="priceDarkLabel">
                                                <AlternatingRowStyle CssClass="priceLightLabel" />
                                                <Columns>
                                                    <asp:BoundField DataField="SessionID" HeaderText="Quote #" ItemStyle-Width="50" SortExpression="SessionID"
                                                        ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="center" />
                                                    <asp:BoundField DataField="UserItemNo" HeaderText="Customer Item#" ItemStyle-Width="90"
                                                        SortExpression="UserItemNo" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="center" />
                                                    <asp:BoundField DataField="PFCItemNo" HeaderText="PFC Item #" ItemStyle-Width="90"
                                                        SortExpression="PFCItemNo" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="center" />
                                                    <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-Width="200"
                                                        SortExpression="Description" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="center" />
                                                    <asp:BoundField DataField="RequestQuantity" HeaderText="Req'd Qty" ItemStyle-Width="50"
                                                        DataFormatString="{0:#,##0} " SortExpression="RequestQuantity" ItemStyle-HorizontalAlign="right"
                                                        HeaderStyle-HorizontalAlign="center" />
                                                    <asp:BoundField DataField="BaseQtyGlued" HeaderText="Base Qty/UOM" ItemStyle-Width="60"
                                                        SortExpression="BaseUOMQty" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                    <asp:TemplateField ItemStyle-Width="45" HeaderText="Avail. Qty" HeaderStyle-HorizontalAlign="Center"
                                                        ItemStyle-HorizontalAlign="right">
                                                        <ItemTemplate>
                                                            <asp:Label ID="QOHLabel" runat="server" Text='<%# Eval("AvailableQuantity", "{0:#,##0} ") %>' />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="PriceGlued" HeaderText="Price/UOM" ItemStyle-Width="80"
                                                        SortExpression="UnitPrice" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                    <asp:BoundField DataField="TotalPrice" HeaderText="Extended Amount" DataFormatString="{0:#,##0.00} "
                                                        ItemStyle-Width="80" SortExpression="TotalPrice" ItemStyle-HorizontalAlign="Right"
                                                        HeaderStyle-HorizontalAlign="center" />
                                                    <asp:BoundField DataField="LineWeight" HeaderText="Extended Weight" DataFormatString="{0:#,##0.00} "
                                                        ItemStyle-Width="80" SortExpression="LineWeight" ItemStyle-HorizontalAlign="Right"
                                                        HeaderStyle-HorizontalAlign="center" />
                                                    <asp:BoundField DataField="LocationCode" HeaderText="Loc." ItemStyle-Width="40" SortExpression="LocationCode"
                                                        ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="center" />
                                                    <asp:BoundField DataField="LocationName" HeaderText="Name" SortExpression="LocationName"
                                                        ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="center" />
                                                </Columns>
                                            </asp:GridView>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="ErrorLabel" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
