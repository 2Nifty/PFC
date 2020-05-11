<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerData.aspx.cs" Inherits="CustomerActivitySheet_CustomerData" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Data</title>
    <link href="../CustomerActivitySheet/Styles/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body scroll="yes" class="Sbar">
    <form id="form1" runat="server">
        <div class="page" id=SheetContainer~|>
            <table id="master" class="DashBoardBk" width="100%" style="width: 100%; border-collapse: collapse;
                page-break-after: always;">
                <tr>
                    <td valign="top">
                        <table width="100%" border="1" cellpadding="0" cellspacing="0" class="SheetHolder"
                            style="border-collapse: collapse;">
                            <tr>
                                <td valign="top">
                                    <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="PageBorder"
                                        style="border-collapse: collapse;">
                                        <tr>
                                            <td colspan="2">
                                                <table width="100%" cellpadding="2" cellspacing="2" class="SheetHead" border="0"
                                                    style="border-collapse: collapse;">
                                                    <tr>
                                                        <td class="redhead">
                                                            Run Date:
                                                            <%=DateTime.Now.ToString() %>
                                                        </td>
                                                        <td class="redhead">
                                                            CUSTOMER ACTIVITY SHEET</td>
                                                        <td class="redhead">
                                                            PAGE 1</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="center">
                                                <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                                    Visible="False"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:DataGrid ID="dgCas" runat="server" BorderWidth="0" BorderColor="#c9c6c6" Width="100%"
                                                    PageSize="1" AllowPaging="true" ShowHeader="false" PagerStyle-Visible="false"
                                                    AutoGenerateColumns="false" OnItemDataBound="dgCas_ItemDataBound">
                                                    <Columns>
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <table width="100%" style="border-collapse: collapse; border-left: solid 1px #c9c6c6;"
                                                                    cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td width="25%" valign="top" class="tdBorder">
                                                                            <div align="left" class="cntt">
                                                                                <strong>Customer #
                                                                                    <%#DataBinder.Eval(Container.DataItem, "CustNo")%>
                                                                                </strong>
                                                                                <br>
                                                                                Chain Name:
                                                                                <%#DataBinder.Eval(Container.DataItem, "Chain")%>
                                                                                <br>
                                                                                Cust Type:
                                                                                <%#DataBinder.Eval(Container.DataItem, "CustType")%>
                                                                            </div>
                                                                        </td>
                                                                        <td width="38%" rowspan="2" valign="top" class="tdBorder">
                                                                            <table width="100%" cellpadding="0" cellspacing="0" class="cntt">
                                                                                <tr>
                                                                                    <td>
                                                                                        <strong>Customer Profile</strong></td>
                                                                                    <td>
                                                                                        <strong>
                                                                                            <%#DataBinder.Eval(Container.DataItem, "CustProfile").ToString().ToUpper()%>
                                                                                        </strong>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        Sales $ Ranking
                                                                                    </td>
                                                                                    <td>
                                                                                        <%#DataBinder.Eval(Container.DataItem, "SalesDollarVolume")%>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        Margin $ Ranking
                                                                                    </td>
                                                                                    <td>
                                                                                        <%#DataBinder.Eval(Container.DataItem, "MarginDollars")%>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        Margin %
                                                                                    </td>
                                                                                    <td>
                                                                                        <%#DataBinder.Eval(Container.DataItem, "MarginPercent")%>
                                                                                        %&nbsp;/&nbsp;<%#DataBinder.Eval(Container.DataItem, "MarginPctCorpAvg")%>%
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        Price per LB
                                                                                    </td>
                                                                                    <td>
                                                                                        <%#DataBinder.Eval(Container.DataItem, "PricePerLB")%>
                                                                                        &nbsp;/&nbsp;<%#DataBinder.Eval(Container.DataItem, "PricePerLBCorpAvg")%>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        Order $ per SO
                                                                                    </td>
                                                                                    <td>
                                                                                        <%#DataBinder.Eval(Container.DataItem, "OrderDollarPerSO")%>
                                                                                        &nbsp;/&nbsp;<%#DataBinder.Eval(Container.DataItem, "OrdDolPerSoCorpAvg")%></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        Order $ per SO Line
                                                                                    </td>
                                                                                    <td>
                                                                                        <%#DataBinder.Eval(Container.DataItem, "OrderDollarPerSOLine")%>
                                                                                        &nbsp;/&nbsp;<%#DataBinder.Eval(Container.DataItem, "OrdDolPerSOLineCorpAvg")%>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        Rebate %
                                                                                    </td>
                                                                                    <td>
                                                                                        <%#DataBinder.Eval(Container.DataItem, "RebatePct")%>
                                                                                        /C
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td width="38%" rowspan="2" valign="top" class="tdBorder">
                                                                            <table cellpadding="0" cellspacing="0" class="cntt">
                                                                                <tr>
                                                                                    <td>
                                                                                        <strong>Sales Brn:
                                                                                            <%#DataBinder.Eval(Container.DataItem,"BranchDesc") %>
                                                                                        </strong>
                                                                                        <br>
                                                                                        Inside Sales:
                                                                                        <%#DataBinder.Eval(Container.DataItem,"InsideSls") %>
                                                                                        <br>
                                                                                        Sales Rep:
                                                                                        <%#DataBinder.Eval(Container.DataItem,"SalesRep") %>
                                                                                        <br>
                                                                                        Buying Grp:
                                                                                        <%#DataBinder.Eval(Container.DataItem,"BuyGrp") %>
                                                                                        <br>
                                                                                        Key Cust:
                                                                                        <%#DataBinder.Eval(Container.DataItem, "KeyCustRebate")%>
                                                                                        <br>
                                                                                        Annual:
                                                                                        <%#DataBinder.Eval(Container.DataItem, "AnnualRebate")%>
                                                                                        <br>
                                                                                        Commission Rep:
                                                                                        <%#DataBinder.Eval(Container.DataItem,"SalesPerson") %>
                                                                                        <br>
                                                                                        Hub:
                                                                                        <%#DataBinder.Eval(Container.DataItem,"HubSatellites") %>
                                                                                        <br>
                                                                                        Terms:
                                                                                        <%#DataBinder.Eval(Container.DataItem,"Terms") %>
                                                                                        <br>
                                                                                        <%-- DSO: <%#DataBinder.Eval(Container.DataItem,"DSO") %>&nbsp;Days<br>--%>
                                                                                        Credit Limit:<%#DataBinder.Eval(Container.DataItem, "CreditLimit")%>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td width="30%" class="tdBorder">
                                                                            <div align="left" class="cntt">
                                                                                <strong>
                                                                                    <%#DataBinder.Eval(Container.DataItem,"CustName") %>
                                                                                </strong>
                                                                                <br>
                                                                                <%#DataBinder.Eval(Container.DataItem,"CustAddress") %>
                                                                                <br>
                                                                                <%#DataBinder.Eval(Container.DataItem,"CustCity") %>
                                                                                ,
                                                                                <%#DataBinder.Eval(Container.DataItem,"CustState") %>
                                                                                <%#DataBinder.Eval(Container.DataItem,"CustZip") %>
                                                                                <br>
                                                                                Ph:
                                                                                <%#DataBinder.Eval(Container.DataItem,"CustPhone") %>
                                                                                <br>
                                                                                Fx:
                                                                                <%#DataBinder.Eval(Container.DataItem,"CustFax") %>
                                                                                <br>
                                                                                Contact:
                                                                                <%#DataBinder.Eval(Container.DataItem,"CustContact") %>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td colspan="3">
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                <tr>
                                                                                    <td width="100%">
                                                                                        <table width="100%" height="60px" rules="all" class="tBorders" cellpadding="0" align="right"
                                                                                            border="0" cellspacing="0">
                                                                                            <tr style="padding-left: 5px">
                                                                                                <td rowspan="3" class="tBorder" width="140">
                                                                                                    <div align="left" class="BlackBold">
                                                                                                        A/R Aging
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td width="107" class="tBorder">
                                                                                                    <div align="left" class="BlackBold">
                                                                                                        &nbsp;Period</div>
                                                                                                </td>
                                                                                                <td width="105" class="tBorder">
                                                                                                    <div align="center" class="BlackBold">
                                                                                                        Current
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td width="98" class="tBorder">
                                                                                                    <div align="center" class="BlackBold">
                                                                                                        >30
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td width="105" class="tBorder">
                                                                                                    <div align="center" class="BlackBold">
                                                                                                        >60
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td width="83" class="tBorder">
                                                                                                    <div align="center" class="BlackBold">
                                                                                                        >90</div>
                                                                                                </td>
                                                                                                <td width="90" class="tBorder">
                                                                                                    <div align="center" class="BlackBold">
                                                                                                        Total</div>
                                                                                                </td>
                                                                                                <td width="80" style="border-bottom: solid 1px #c9c6c6;">
                                                                                                    <div align="center" class="BlackBold">
                                                                                                        DSO
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr style="padding-left: 5px">
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="BlackBold">
                                                                                                        Amount</div>
                                                                                                </td>
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem, "AgingCur")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem, "Aging30")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem, "Aging60")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem, "AgingOver90")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem, "AgingTot")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td rowspan="2" style="border-bottom: solid 1px #c9c6c6;">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem,"DSO") %>
                                                                                                        &nbsp;Days</div>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr style="padding-left: 5px">
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="BlackBold">
                                                                                                        % of AR
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem, "AgingCurPct")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem, "Aging30Pct")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem, "Aging60Pct")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem, "Aging90Pct")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td class="tBorder">
                                                                                                    <div align="left" class="blackTxt">
                                                                                                        <%#DataBinder.Eval(Container.DataItem, "AgingPctTot")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td class="SheetHead" colspan="3" style="border-right: solid 1px #c9c6c6;">
                                                                            <div class="Left5pxPadd">
                                                                                Customer Metrics</div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td colspan="3">
                                                                            <table width="100%" cellpadding="0" rules="all" border="0" style="width: 100%; border-collapse: collapse;">
                                                                                <tr  bgcolor="#dff3f9">
                                                                                    <td width="155" style="border-bottom:solid 1px #c9c6c6;	border-left:solid 0px #c9c6c6;	border-right:solid 1px #c9c6c6;	border-top:solid 1px #c9c6c6;	border-collapse:collapse;">
                                                                                        <div align="left" style="font-weight: bold; font-size:11px;	color: #003366;word-wrap:normal ">
                                                                                            &nbsp;Fiscal Month:<%=Request.QueryString["MonthName"].Trim()%>&nbsp;<%=Request.QueryString["Year"].Trim()%>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td class="CASGridPadding GridItem" colspan=2>
                                                                                        <div align="Center" style="font-weight: bold;	color: #003366;">
                                                                                            Fiscal Month</div>
                                                                                    </td>
                                                                                    <td class="CASGridPadding GridItem" colspan=2>
                                                                                        <div align="Center" style="font-weight: bold;	color: #003366;">
                                                                                            Fiscal Year</div>
                                                                                    </td>
                                                                                </tr>
                                                                                
                                                                                <tr bgcolor="#dff3f9">
                                                                                    <td width="135" class="CASGridPadding GridItem"></td>
                                                                                    <td class="CASGridPadding GridItem"><div align="left">Current Year</div></td>
                                                                                    <td class="CASGridPadding GridItem"><div align="left">Last Year</div></td>
                                                                                    <td class="CASGridPadding GridItem"><div align="left">Current Year</div></td>
                                                                                    <td class="CASGridPadding GridItem"><div align="left">Last Year</div></td>
                                                                                </tr>
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Cust Rank</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"MTDCustRank") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LMTDCustRank")%>&nbsp;</td>   
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "YTDCustRank")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDCustRank")%>&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                                <tr bgcolor="#FFFFFF"><td class="CASGridPadding GridItem">Fiscal Sales</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"MTDSales") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LMTDSales")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"YTDSales")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDSales")%>&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Sales $ percentage change</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LMTDSales_PctChng")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem">&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDSales_PctChng")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem">&nbsp;</td>
                                                                                </tr>
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Margin $ /%</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "CYTDDolMarginFM")%>&nbsp;/<%#DataBinder.Eval(Container.DataItem, "CYTDDolMarginPctFM")%>%</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDDolMarginFM")%>&nbsp;/<%#DataBinder.Eval(Container.DataItem, "LYTDDolMarginPctFM")%>%</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "CYTDDolMarginFY")%>&nbsp;/<%#DataBinder.Eval(Container.DataItem, "CYTDDolMarginPctFY")%>%</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDDolMarginFY")%>&nbsp;/<%#DataBinder.Eval(Container.DataItem, "LYTDDolMarginPctFY")%>%</td>
                                                                                    
                                                                                </tr>
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Expense</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "CYTDExpenseFM")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDExpenseFM")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "CYTDExpenseFY")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDExpenseFY")%>&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Profit</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "CYTDProfitFM")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDProfitFM")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "CYTDProfitFY")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDProfitFY")%>&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">$ Per LB</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"MTDPricePerLB") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LMTDPricePerLB")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "YTDPricePerLB")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDPricePerLB")%>&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Price per LB % Change</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LMTDPricePerLB_PctChng")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem">&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem">&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDPricePerLB_PctChng")%>&nbsp;</td>
                                                                                </tr>
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Pounds - PFC O/E</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "MTDLbs_OE")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LMTDLbs_OE")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "YTDLbs_OE")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDLbs_OE")%>&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Pounds – E Commerce</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "MTDLbs_Ecomm")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LMTDLbs_Ecomm")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "YTDLbs_Ecomm")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LYTDLbs_Ecomm")%>&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Orders – PFC O/E</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"MTDOrd_OE") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"LMTDOrd_OE") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "YTDOrd_OE")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"LYTDOrd_OE")%>&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Orders – E Commerce</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"MTDOrd_EComm") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"LMTDOrd_EComm") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"YTDOrd_EComm") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"LYTDOrd_EComm") %>&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Lines – PFC O/E</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"MTDLines_OE") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"LMTDLines_OE") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"YTDLines_OE")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"LYTDLines_OE")%>&nbsp;</td>
                                                                                </tr>
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Lines/Ord : Corp Line/Ord</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "CustCYTDLnPerOrdFM")%>&nbsp;/<asp:Label ID="lblCorpCYTDLnPerOrdFM" runat="server" Text=""></asp:Label></td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "CustLYTDLnPerOrdFM")%>&nbsp;/<asp:Label ID="lblCorpLYTDLnPerOrdFM" runat="server" Text=""></asp:Label></td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "CustCYTDLnPerOrdFY")%>&nbsp;/<asp:Label ID="lblCorpCYTDLnPerOrdFY" runat="server" Text=""></asp:Label></td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "CustLYTDLnPerOrdFY")%>&nbsp;/<asp:Label ID="lblCorpLYTDLnPerOrdFY" runat="server" Text=""></asp:Label></td>
                                                                                </tr>
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Lines – E Commerce</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "MTDLines_Ecomm")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem, "LMTDLines_Ecomm")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"YTDLines_Ecomm") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"LYTDLines_Ecomm") %>&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Shipping Fill Rate</td>
                                                                                    <td class="CASGridPadding GridItem" style="word-wrap:normal">
                                                                                        <%#DataBinder.Eval(Container.DataItem,"MTDFillRate_Lines")%>% Lines /<%#DataBinder.Eval(Container.DataItem,"MTDFillRate") %>%&nbsp;Units
                                                                                    </td>
                                                                                    <td class="CASGridPadding GridItem" style="word-wrap:normal">
                                                                                        <%#DataBinder.Eval(Container.DataItem,"LMTDFillRate_Lines")%>% Lines /<%#DataBinder.Eval(Container.DataItem, "LMTDFillRate")%>%&nbsp;Units
                                                                                    </td>
                                                                                    <td class="CASGridPadding GridItem" style="word-wrap:normal">
                                                                                        <%#DataBinder.Eval(Container.DataItem, "YTDFillRate_Lines")%> % Lines /<%#DataBinder.Eval(Container.DataItem,"YTDFillRate")%>%&nbsp;Units
                                                                                    </td>
                                                                                    <td class="CASGridPadding GridItem" style="word-wrap:normal">
                                                                                        <%#DataBinder.Eval(Container.DataItem,"LYTDFillRate_Lines")%>% Lines /<%#DataBinder.Eval(Container.DataItem,"LYTDFillRate")%>%&nbsp;Units
                                                                                    </td>                                                                                    
                                                                                </tr>                                                                                
                                                                                <tr bgcolor="#FFFFFF">
                                                                                    <td class="CASGridPadding GridItem">Ship Pattern</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"MTDShipPattern") %>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem"><%#DataBinder.Eval(Container.DataItem,"LMTDShipPattern")%>&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem">&nbsp;</td>
                                                                                    <td class="CASGridPadding GridItem">&nbsp;</td>
                                                                                </tr>
                                                                                
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ItemTemplate>
                                                            <ItemStyle VerticalAlign="Top" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle Visible="False" />
                                                </asp:DataGrid></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
