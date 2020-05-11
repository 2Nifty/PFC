<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExpenseEntryExport.aspx.cs"
    Inherits="ExpenseEntryExport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>SOE Expense Entry</title>
    <link href="http://206.72.71.194/SOE/Common/StyleSheet/printstyles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="SheetContainer~|">
            <table class="PageBg" cellpadding="0" cellspacing="0" width="67%">
                <tr>
                    <td bgcolor="white">
                        <asp:Image ID="imglogo" runat=server ImageUrl="http://206.72.71.194/SOE/Common/Images/PFC_logo.gif" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:DataList ID="dlSOEHeader" runat="server" Width="100%" RepeatColumns="1" Height="1px">
                            <ItemTemplate>
                                <table cellpadding="0" cellspacing="0" width="100%" border="0" class="bborder PageBg">
                                    <tr>
                                        <td class="TabHead" width="12%">
                                            <%--     Customer Number</td>--%>
                                            <td width="12%">
                                                <%--<span id="blCustNo" class="cnt" style="display: inline-block;">
                                                <%#DataBinder.Eval(Container, "DataItem.SellToCustNo")%>
                                            </span>--%>
                                            </td>
                                        <td class="TabHead lborder bborder" width="5%" valign="top" rowspan="4">
                                            <span id="lnkSellTo" class="TabHead">Sold To:</span></td>
                                        <td width="20%" rowspan="4" valign="top" class="lblbox bborder">
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <span id="lblSell_Name">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToCustName")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="lblSell_Contact">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToAddress1")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="lblSell_City">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToCity")%>
                                                        </span>, <span id="Span1">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToState")%>
                                                        </span><span id="lblSell_Pincode">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToZip")%>
                                                        </span><span id="Span2">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToCountry")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="lblSell_Country">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToContactPhoneNo")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td class="TabHead lborder bborder" valign="top" width="5%" rowspan="4">
                                            <span id="lnkShipTo" class="TabHead">Ship To</span>
                                        </td>
                                        <td width="20%" rowspan="4" valign="top" class="lblbox rborder bborder">
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <span id="lblShip_Name">
                                                            <%#DataBinder.Eval(Container, "DataItem.ShipToName")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="lblShip_Contact">
                                                            <%#DataBinder.Eval(Container, "DataItem.ShipToAddress1")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="lblShip_City">
                                                            <%#DataBinder.Eval(Container, "DataItem.City")%>
                                                        </span>, <span id="lblShip_Territory">
                                                            <%#DataBinder.Eval(Container, "DataItem.State")%>
                                                        </span><span id="lblShip_Pincode">
                                                            <%#DataBinder.Eval(Container, "DataItem.Zip")%>
                                                        </span><span id="Span3">
                                                            <%#DataBinder.Eval(Container, "DataItem.Country")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="lblShip_Phone">
                                                            <%#DataBinder.Eval(Container, "DataItem.PhoneNo")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TabHead">
                                            Sales Order Number</td>
                                        <td class="cnt">
                                            <span id="Label4">
                                                <%#DataBinder.Eval(Container, "DataItem.pSOHeaderID")%>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <%-- <span id="lblChain" class="TabHead">Chain</span></td>--%>
                                            <td>
                                                <%--<span id="lblChainValue" style="display: inline-block;">
                                                <%#DataBinder.Eval(Container, "DataItem.SellToCustNo")%>
                                            </span>--%>
                                            </td>
                                    </tr>
                                    <%--  <tr>
                                        <td class="TabHead bborder">
                                            SO Date</td>
                                        <td class="bborder">
                                            &nbsp;<asp:Label runat="server" ID="lblSoDate"><%#DataBinder.Eval(Container, "DataItem.OrderDt").ToString().Split(' ')[0].Trim()%></asp:Label></td>
                                    </tr>--%>
                                </table>
                                <tr>
                                </tr>
                            </ItemTemplate>
                        </asp:DataList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:DataGrid ID="dgExpense" runat="server">
                            <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" />
                            <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                            <ItemStyle CssClass="item" Wrap="False" />
                            <AlternatingItemStyle CssClass="itemShade" />
                        </asp:DataGrid>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
