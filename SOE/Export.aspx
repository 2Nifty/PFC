<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Export.aspx.cs" Inherits="Export" %>

<%@ Register Src="Common/UserControls/PrintHeader.ascx" TagName="PrintHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Main Order Entry</title>
    <%= PFC.SOE.DataAccessLayer.Global.PrintStyleSheet %>
    

</head>
<body>
    <form id="form1" runat="server">
    <div class=LandscapeDiv >  
        <div id="SheetContainer~|">
            <table class="PageBg" cellpadding="0" cellspacing="0">
                <tr>
                    <td bgcolor="white">
                        <uc1:PrintHeader ID="printHeader" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:DataList ID="dlSOEHeader" runat="server" Width="100%" RepeatColumns="1" OnItemDataBound="dlSOEHeader_ItemDataBound">
                            <ItemTemplate>
                                <table cellpadding="0" cellspacing="0" width="100%" border="0" class="bborder PageBg">
                                    <tr>
                                        <td class="TabHead" width="12%">
                                            Customer Number</td>
                                        <td width="12%">
                                            <span id="blCustNo" class="cnt" style="display: inline-block;">
                                                <%#DataBinder.Eval(Container, "DataItem.SellToCustNo")%>
                                            </span>
                                        </td>
                                        <td class="TabHead lborder bborder" width="6%" valign="top" rowspan="4">
                                           <table><tr><td> <span id="Span5" class="TabHead">Sold To</span></td></tr>
                                        <tr><td ><span id="Span6">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToCustNo")%>
                                                 </span></td></tr>
                                                 <tr><td valign=baseline><span id="Span8" class="TabHead">Bill To</span></td></tr>
                                                 <tr><td valign=baseline><span id="Span9" class=" "> <%#DataBinder.Eval(Container, "DataItem.BillToCustNo")%></span></td></tr></table></td>
                                        <td width="20%" rowspan="4" valign="top" class="lblbox bborder">
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <span id="lblBill_Name">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToCustName")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                 <tr>
                                                    <td>
                                                        <span id="Span11">
                                                            <%#DataBinder.Eval(Container, "DataItem.OrderTermsName")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="lblBill_Contact">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToContactName")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="lblBill_City">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToCity")%>
                                                        </span>, <span id="Span1">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToState")%>
                                                        </span><span id="lblBill_Pincode">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToZip")%>
                                                        </span><span id="Span2">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToCountry")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="lblBill_Country">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToContactPhoneNo")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr> <td>
                                                        <span id="Span7" class="TabHead">
                                                            Order Contact :<%#DataBinder.Eval(Container, "DataItem.SellToContactName")%>
                                                        </span>
                                                    </td></tr>
                                                    <tr><td class="bborder">
                                             <asp:Label runat="server" ID="Label2"><%#DataBinder.Eval(Container, "DataItem.BillToCustName").ToString().Split(' ')[0].Trim()%></asp:Label></td></tr>
                                            </table>
                                        </td>
                                        <td class="TabHead lborder bborder" valign="top" width="6%" rowspan="4">
                                        <table><tr><td> <span id="lnkShipTo" class="TabHead">Ship To</span></td></tr>
                                        <tr><td >   <span id="Span4">
                                                            <%#DataBinder.Eval(Container, "DataItem.SellToCustNo")%>
                                                        </span></td></tr></table>
                                           
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
                                                            <%#DataBinder.Eval(Container, "DataItem.ContactPhoneNo")%>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td class="TabHead" width="15%" style="padding-left: 5px">
                                            <span id="lnkUsage" class="TabHead">Usage Loc:</span>
                                        </td>
                                        <td class="cnt" width="8%" align="left">
                                            <span id="txtSONumber" class="cnt">
                                                <%#DataBinder.Eval(Container, "DataItem.UsageLoc")%>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TabHead">
                                            Sales Order Number</td>
                                        <td class="cnt">
                                            <span id="Label4">
                                                <%#DataBinder.Eval(Container, "DataItem.HeaderID")%>
                                            </span>
                                        </td>
                                        <td class="TabHead" style="padding-left: 5px">
                                            <span id="lblSalesHead">Total Sales $:</span>
                                        </td>
                                        <td align="left">
                                            <asp:Label ID="lblSales" runat="server">0.00</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span id="lblChain" class="TabHead">Chain</span></td>
                                        <td>
                                            <span id="lblChainValue" style="display: inline-block;">
                                                <%#DataBinder.Eval(Container, "DataItem.SellToCustNo")%>
                                            </span>
                                        </td>
                                        <td style="padding-left: 5px">
                                            <span id="lblGp1" class="TabHead">Total Gp$/Lb:</span></td>
                                        <td>
                                            <asp:Label runat="server" ID="lblTotGPLb">0</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td class="TabHead bborder">
                                            SO Date</td>
                                        <td class="bborder">
                                            <asp:Label runat="server" ID="lblSoDate"><%#DataBinder.Eval(Container, "DataItem.OrderDt").ToString().Split(' ')[0].Trim()%></asp:Label></td>
                                        
                                        <td style="padding-left: 5px">
                                            <span id="Label31" class="TabHead">Total Weight:</span></td>
                                        <td>
                                            <asp:Label ID="lblTotalWeight" runat="server">0.00</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td colspan="6" rowspan="3" valign="top" class="TabHead rborder">
                                            <table cellpadding="0" cellspacing="0" style="padding-left: 2px;" border="0" width="100%">
                                                <tr>
                                                    <td width="99" class="TabHead">
                                                        PO #:</td>
                                                    <td width="19">
                                                        <span id="txtPO1" style="display: inline-block;">
                                                            <%#DataBinder.Eval(Container, "DataItem.CustPONo")%>
                                                        </span>
                                                    </td>
                                                    <td width="89" class="TabHead">
                                                        Ship From:</td>
                                                    <td width="71">
                                                        <span id="lblShipFrom1" style="display: inline-block;">
                                                            <%#DataBinder.Eval(Container, "DataItem.ShipLoc")%>
                                                        </span>
                                                    </td>
                                                    <td class="TabHead">
                                                        Order Type:</td>
                                                    <td width="77">
                                                        <span id="lblOrderType1" style="display: inline-block;">
                                                            <%#DataBinder.Eval(Container, "DataItem.OrderType")%>
                                                        </span>
                                                    </td>
                                                    <td class="TabHead">
                                                        Carrier Cd:</td>
                                                    <td width="39">
                                                        <span id="lblCarrierCd1" style="display: inline-block;">
                                                            <%#DataBinder.Eval(Container, "DataItem.OrderCarrier")%>
                                                        </span>
                                                    </td>
                                                     <td class="TabHead">
                                                        Freight Cd:</td>
                                                    <td class="cnt">
                                                         <span id="Label71" style="display: inline-block;"><%#DataBinder.Eval(Container, "DataItem.OrderFreightCd").ToString()%></span></td>
                                                   
                                                </tr>
                                                <tr>
                                                    <td class="TabHead" width="72">
                                                        Cust Req Dt:</td>
                                                    <td width="44">
                                                        <asp:Label runat="server" ID="Label3" Style="display: inline-block;"><%#(DataBinder.Eval(Container, "DataItem.CustReqDt").ToString()=="")?"":Convert.ToDateTime(DataBinder.Eval(Container, "DataItem.CustReqDt").ToString()).ToShortDateString()%></asp:Label></td>
                                                     <td class="TabHead" width="72">
                                                        Branch Req Dt:</td>
                                                    <td width="44">
                                                        <asp:Label runat="server" ID="Label5" Style="display: inline-block;"><%#(DataBinder.Eval(Container, "DataItem.BranchReqDt").ToString() == "") ? "" :Convert.ToDateTime(DataBinder.Eval(Container, "DataItem.BranchReqDt").ToString()).ToShortDateString()%></asp:Label></td>
                                                    <td class="TabHead">
                                                        Expedite Cd:</td>
                                                    <td>
                                                        <%#DataBinder.Eval(Container, "DataItem.OrderExpdCd")%>
                                                    </td>
                                                    <td class="TabHead">
                                                        Priority Cd:</td>
                                                    <td class="cnt">
                                                        <span id="Label61" style="display: inline-block;"><%#DataBinder.Eval(Container, "DataItem.OrderPriorityCd")%></span></td>                                               
                                                    <td class="TabHead">
                                                        Reason Cd:</td>
                                                    <td class="cnt">
                                                         <span id="Label91" style="display: inline-block;"><%#DataBinder.Eval(Container,"DataItem.ReasonCd") %></span></td>
                                                  
                                                </tr>
                                                <tr>
                                                
                                                    <td class="TabHead">
                                                        Sch Ship Dt:</td>
                                                    <td>
                                                        <asp:Label runat="server" ID="lblShipDate" Style="display: inline-block;"><%#DataBinder.Eval(Container, "DataItem.ShippedDt").ToString().Split(' ')[0].Trim()%></asp:Label></td>
                                                    <td class="TabHead" width="76">
                                                        Invoice Date:</td>
                                                    <td>
                                                        <asp:Label runat="server" ID="lblInvDate" Style="display: inline-block;"><%#DataBinder.Eval(Container, "DataItem.InvoiceDt").ToString().Split(' ')[0].Trim()%></asp:Label></td>
                                                 
                                                    <td class="TabHead">
                                                        Entry Id:</td>
                                                    <td>
                                                        <span id="Label141" style="display: inline-block;"><%#DataBinder.Eval(Container,"DataItem.EntryID") %></span></td>
                                                         <td class="TabHead">
                                                        Entry Id:</td>
                                                    <td>
                                                        <span id="Span10" style="display: inline-block;"><%#DataBinder.Eval(Container,"DataItem.ChangeID") %></span></td>
                                                </tr>
                                                <tr>
                                                
                                                    <td class="TabHead">
                                                        Ref SO No:</td>
                                                    <td>
                                                        <asp:Label runat="server" ID="lblRefNo" Style="display: inline-block;"><%#DataBinder.Eval(Container, "DataItem.RefSONo").ToString()%></asp:Label></td>
                                                    <td class="TabHead" width="76">
                                                        </td>
                                                    <td>
                                                        </td>                                                 
                                                    <td class="TabHead" colspan=2>                                                        
                                                        <span id="Span12" style="display: inline-block;"><%#DataBinder.Eval(Container, "DataItem.OrderTypeDsc")%></span></td>
                                                    <td class="TabHead">
                                                        </td>
                                                    <td>
                                                        </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td style="padding-left: 5px">
                                            <span id="Label21" class="TabHead">Ord Sts:</span></td>
                                        <td>
                                            <span id="lblOrdSts1"><asp:Label ID="lblOrdSts" runat="server" Text="Label"></asp:Label></span></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 5px">
                                            <span id="Label01" class="TabHead">WHS:</span></td>
                                        <td>
                                            <asp:Label ID="lblWHS" runat="server" Text=""></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td class="TabHead" style="padding-left: 5px"></td>
                                        <td align="left" style="padding-left: 9px"></td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </asp:DataList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:DataGrid ID="dgReport" runat="server" OnItemDataBound="dgReport_ItemDataBound">
                            <HeaderStyle HorizontalAlign="Center" Wrap=true CssClass="GridHead" />
                            <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                            <ItemStyle CssClass="item" Wrap="False" />
                            <AlternatingItemStyle CssClass="itemShade" />
                        </asp:DataGrid>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    </form>
</body>
</html>
