<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShippingMarksExport.aspx.cs"
    Inherits="ShippingMarksExport" %>

<%@ Register Src="Common/UserControls/PrintHeader.ascx" TagName="PrintHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Shipping Mark Export</title>
    <%= PFC.SOE.DataAccessLayer.Global.PrintStyleSheet %>
</head>
<body>
    <form id="form1" runat="server">
        <div id="SheetContainer~|">
            <table class="PageBg" cellpadding="0" cellspacing="0" width="60%">
                <tr>
                    <td bgcolor="white">
                        <uc1:PrintHeader ID="PrintHeader1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td bgcolor ="white">
                        <asp:DataList ID="dlSOEHeader" runat="server" Width="101%" RepeatColumns="1" Height="1px">
                            <ItemTemplate>
                                <table cellpadding="0" cellspacing="0" width="101%" border="0" class="bborder PageBg">
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
                                                <%#DataBinder.Eval(Container, "DataItem.ID")%>
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
                                <table cellpadding="0" cellspacing="0" width="50%" border="0" align="center">
                                    <tr>
                                        <td class="TabHead" width="12%">
                                            Shipping Mark1</td>
                                        <td width="12%">
                                            <span id="Span4" class="cnt" style="display: inline-block;">
                                                <%#DataBinder.Eval(Container, "DataItem.ShippingMark1")%>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TabHead" width="12%">
                                            Shipping Mark2</td>
                                        <td width="12%">
                                            <span id="Span5" class="cnt" style="display: inline-block;">
                                                <%#DataBinder.Eval(Container, "DataItem.ShippingMark2")%>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TabHead" width="12%">
                                            Shipping Mark3</td>
                                        <td width="12%">
                                            <span id="Span6" class="cnt" style="display: inline-block;">
                                                <%#DataBinder.Eval(Container, "DataItem.ShippingMark3")%>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TabHead" width="12%">
                                            Shipping Mark4</td>
                                        <td width="12%">
                                            <span id="Span8" class="cnt" style="display: inline-block;">
                                                <%#DataBinder.Eval(Container, "DataItem.ShippingMark4")%>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TabHead" width="12%">
                                            Shipping Instructions</td>
                                        <td width="12%">
                                            <span id="Span7" class="cnt" style="display: inline-block;">
                                                <%#DataBinder.Eval(Container, "DataItem.ShipInstrCdName")%>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TabHead" width="12%">
                                            Remarks</td>
                                        <td width="12%">
                                            <span id="Span9" class="cnt" style="display: inline-block;">
                                                <%#DataBinder.Eval(Container, "DataItem.Remarks")%>
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </asp:DataList>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
