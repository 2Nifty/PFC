<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SOFindExport.aspx.cs" Inherits="SOFind" %>

<%@ Register Src="Common/UserControls/PrintHeader.ascx" TagName="PrintHeader" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/TwoDatePicker.ascx" TagName="TwoDatePicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SO Find</title>

    <script type="text/javascript" src="Common/JavaScript/PendingOrdersAndQuotes.js"></script>

    <%= PFC.SOE.DataAccessLayer.Global.PrintStyleSheet %>
</head>
<body>
    <form id="form1" runat="server">
        <table border="0" cellpadding="0" cellspacing="2" style="width: 90%; height: 100%"
            class="PageBg">
            <tr>
                <td bgcolor="white">
                    &nbsp;<uc4:PrintHeader ID="PrintHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td valign="bottom" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px"
                                width="40%">
                                <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                    <tr>
                                        <td width="60%">
                                            <asp:Label ID="lblCuctomerCaption" runat="server" Text="Customer Number :" Font-Bold="True"
                                                Width="135px"></asp:Label></td>
                                        <td>
                                            <%=Request.QueryString["CustomerNumber"]%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle">
                                            <%=Request.QueryString["HeaderType"]%>
                                        </td>
                                        <td>
                                            <%=Request.QueryString["OrderNumber"]%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" class="SubHeaderPanels" width="50%" style="padding-left: 2px; padding-top: 2px">
                                <table border="0" cellpadding="2" cellspacing="0" width="100%">
                                    <tr>
                                        <td width="120" style="font-weight: bold;">
                                            Contract Number :</td>
                                        <td>
                                            <asp:Label ID="lblContractNumber" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight: bold;">
                                            Price Code :</td>
                                        <td>
                                            <asp:Label ID="lblPriceCode" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight: bold;">
                                            Sales Rep Number :</td>
                                        <td>
                                            <asp:Label ID="lblSalesRepNumber" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight: bold;">
                                            Sales Rep Name :</td>
                                        <td>
                                            <asp:Label ID="lblSalesRepName" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="vertical-align: top; padding-bottom: 5px; padding-top: 5px;
                    padding-left: 0px">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td valign="bottom" style="padding-left: 4px;">
                                <table border="0" cellpadding="3" cellspacing="0">
                                    <tr>
                                        <td colspan="2" align="center" style="padding-bottom: 8px; font-weight: bold;">
                                            ----- Order Status Date Range -----</td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight: bold;" width="50%">
                                            Description</td>
                                        <td>
                                            <%=Request.QueryString["Description"]%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight: bold;" colspan="2" align="center">
                                            <%=Request.QueryString["DescDate"]%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:GridView ShowFooter="false" UseAccessibleHeader="true" ID="gvFind" PagerSettings-Visible="false"
                        Width="985px" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="false"
                        AutoGenerateColumns="false">
                        <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" />
                        <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                        <RowStyle CssClass="item" Wrap="False" />
                        <AlternatingRowStyle CssClass="itemShade" />
                        <Columns>
                            <asp:BoundField HeaderText="Ship Loc" DataField="ShipLoc" SortExpression="ShipLoc"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="SO No." DataField="SoNo" SortExpression="SoNo" ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Inv. No." DataField="InvoiceNo" SortExpression="InvoiceNo"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="PO Ref" DataField="PORef" SortExpression="PORef" ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="50px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Order Amt" DataField="Amount" SortExpression="Amount"
                                HtmlEncode="false" DataFormatString="{0:#,##0.00}" ItemStyle-CssClass="Left5pxPadd"
                                ItemStyle-HorizontalAlign="Right">
                                <ItemStyle Width="40px" HorizontalAlign="right" Wrap="false" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Order Wght" DataField="Weight" SortExpression="Weight"
                                HtmlEncode="false" DataFormatString="{0:#,##0.0}" ItemStyle-CssClass="Left5pxPadd"
                                ItemStyle-HorizontalAlign="Right">
                                <ItemStyle Width="40px" HorizontalAlign="right" Wrap="false" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Type" DataField="Type" SortExpression="Type" ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Ship Date" DataField="CShipDate" SortExpression="CShipDate"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="center" Width="35px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Sched Ship Date" DataField="SchShipDt" SortExpression="SchShipDt"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="center" Width="35px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Order Date" DataField="OrderDate" SortExpression="OrderDate"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="center" Width="35px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Cust Req'd" DataField="CustReq" SortExpression="CustReq"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="35px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Status" DataField="StatusCd" SortExpression="StatusCd"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Carrier" DataField="Carrier" SortExpression="Carrier"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Customer No" DataField="CustomerNo" SortExpression="CustomerNo"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="50px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Customer Name" DataField="SellToCustName" SortExpression="SellToCustName"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="150px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Ref SO No" DataField="RefSONo" SortExpression="RefSONo"
                                ItemStyle-CssClass="Left5pxPadd">
                                <ItemStyle HorizontalAlign="Left" Width="50px" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
