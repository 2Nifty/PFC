<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CASReportExport.aspx.cs" Inherits="CASReport" %>

<%@ Register Src="Common/UserControls/PrintHeader.ascx" TagName="PrintHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Activity Sheet</title>
    <%= PFC.SOE.DataAccessLayer.Global.PrintStyleSheet %>
    
    <style>
    .BlackBold
    {
        font-weight:bold;
    }
    td.lightBg
    {
	    border: 1px solid #E4E4E4;
	    background: #FFFFFF;
	    border-collapse:collapse;
    }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        &nbsp;<div>
            <table border="0" cellpadding="0" cellspacing="0" style="width: 700px">
                <tr>
                    <td>
                        <uc1:PrintHeader ID="PrintHeader1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <asp:Label  runat=server id="lblStatus" CssClass="redtitle" Font-Bold="True" ForeColor="#C00000" Text="No Records Found" Visible="False"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 100px;height:200px;">
                        <asp:DataGrid ID="dgCas" runat="server" BorderWidth="0" BorderColor="#c9c6c6" PageSize="1"
                            AllowPaging="true" ShowHeader="false" PagerStyle-Visible="false" AutoGenerateColumns="false">
                            <Columns>
                                <asp:TemplateColumn>
                                    <ItemTemplate>
                                        <table width="700px" style="border-collapse: collapse; border-left: solid 1px #c9c6c6;"
                                            cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="padding-left: 5px;" width="25%" valign="top" class="HeaderPanels">
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
                                                    <br />
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
                                                <td style="padding-left: 5px;" width="38%" valign="top" class="HeaderPanels">
                                                    <table width="100%" cellpadding="0" style="line-height: 18px;" cellspacing="0">
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
                                                <td style="padding-left: 5px;" width="38%" valign="top" class="HeaderPanels">
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
                                            <tr valign="top">
                                                <td colspan="3">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td width="100%">
                                                                <table width="100%" height="60px" rules="all" cellpadding="0" align="right" border="0"
                                                                    cellspacing="0">
                                                                    <tr style="padding-left: 3px">
                                                                        <td rowspan="3" class="lightBg" width="100">
                                                                            <div align="left" class="BlackBold">
                                                                                A/R Aging
                                                                            </div>
                                                                        </td>
                                                                        <td width="94" class="lightBg">
                                                                            <div align="left" class="BlackBold">
                                                                                &nbsp;Period</div>
                                                                        </td>
                                                                        <td width="105" class="lightBg">
                                                                            <div align="center" class="BlackBold">
                                                                                Current
                                                                            </div>
                                                                        </td>
                                                                        <td width="107" class="lightBg">
                                                                            <div align="center" class="BlackBold">
                                                                                >30
                                                                            </div>
                                                                        </td>
                                                                        <td width="95" class="lightBg">
                                                                            <div align="center" class="BlackBold">
                                                                                >60
                                                                            </div>
                                                                        </td>
                                                                        <td width="90" class="lightBg">
                                                                            <div align="center" class="BlackBold">
                                                                                >90</div>
                                                                        </td>
                                                                        <td width="100" class="lightBg">
                                                                            <div align="center" class="BlackBold">
                                                                                Total</div>
                                                                        </td>
                                                                        <td width="108" style="border: solid 1px #E4E4E4;">
                                                                            <div align="center" class="BlackBold">
                                                                                DSO
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                             <tr style="padding-left: 5px">
                                                                        <td class="lightBg">
                                                                            <div align="left" class="BlackBold">
                                                                                Amount</div>
                                                                        </td>
                                                                        <td class="lightBg">
                                                                            <div align="left" class="blackTxt">
                                                                                <%= AgingCur %>
                                                                            </div>
                                                                        </td>
                                                                        <td class="lightBg">
                                                                            <div align="left" class="blackTxt">
                                                                                <%= Aging30 %>
                                                                            </div>
                                                                        </td>
                                                                        <td class="lightBg">
                                                                            <div align="left" class="blackTxt">
                                                                                <%= Aging60 %>
                                                                            </div>
                                                                        </td>
                                                                        <td class="lightBg">
                                                                            <div align="left" class="blackTxt">
                                                                                <%= AgingOver90 %>
                                                                            </div>
                                                                        </td>
                                                                        <td class="lightBg">
                                                                            <div align="left" class="blackTxt">
                                                                                <%= AgingTot %>
                                                                            </div>
                                                                        </td>
                                                                        <td rowspan="2" class="lightBg">
                                                                            <div align="left" class="blackTxt">&nbsp;</div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="padding-left: 5px">
                                                                        <td class="lightBg">
                                                                            <div align="left" class="BlackBold">
                                                                                % of AR
                                                                            </div>
                                                                        </td>
                                                                        <td class="lightBg">
                                                                            <div align="left" class="blackTxt">
                                                                                <%= AgingCurPct %>
                                                                            </div>
                                                                        </td>
                                                                        <td class="lightBg">
                                                                            <div align="left" class="blackTxt">
                                                                                <%= Aging30Pct %>
                                                                            </div>
                                                                        </td>
                                                                        <td class="lightBg">
                                                                            <div align="left" class="blackTxt">
                                                                                <%= Aging60Pct %>
                                                                            </div>
                                                                        </td>
                                                                        <td class="lightBg">
                                                                            <div align="left" class="blackTxt">
                                                                                <%= Aging90Pct %>                                                                                
                                                                            </div>
                                                                        </td>
                                                                        <td class="lightBg">
                                                                            <div align="left" class="blackTxt">
                                                                                <%= AgingPctTot %>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                            </Columns>
                        </asp:DataGrid></td>
                </tr>
                <tr>
                    <td class="lightBg">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr  runat=server id="tblControls">
                                <td>
                                    <div class="BlackBold">
                                        <strong>Customer #</strong> &nbsp;
                                        <%= custNo + " - " %>
                                        <asp:Label ID="lblCustName" runat="server" Text="" CssClass="BlackBold" Font-Bold="True"></asp:Label>
                                    </div>
                                </td>
                                <td class="redhead">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="75%">
                                                <asp:RadioButtonList ID="rbtnlCustType" runat="server" RepeatDirection="Horizontal"
                                                    OnSelectedIndexChanged="rbtnlCustType_SelectedIndexChanged" AutoPostBack="true"
                                                    Font-Bold="True">
                                                    <asp:ListItem Text="Customer" Value="Customer"></asp:ListItem>
                                                    <asp:ListItem Text="PFC Employee" Value="PFC Employee" Selected="True"></asp:ListItem>
                                                </asp:RadioButtonList></td>
                                            <td width="25%">
                                                <div class="BlackBold">
                                                    <%=monthname%>
                                                    '<%=curYear%>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="height:185px;" valign=top>
                                    <asp:DataGrid ID="dgSalesDetails" runat="server" Width="700px" BorderColor="#c9c6c6"
                                        GridLines="Both" BorderWidth="1" AutoGenerateColumns="false" OnItemDataBound="dgSalesDetails_ItemDataBound">
                                        <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" BackColor="#DFF3F9" Font-Bold="True"
                                            Height="20px" />
                                        <ItemStyle CssClass="item" Wrap="False"  Height="20px" />
                                        <FooterStyle HorizontalAlign="Right" Font-Bold="true" />
                                        <AlternatingItemStyle CssClass="itemShade" BackColor="White" />
                                        <Columns>
                                            <asp:BoundColumn HeaderText="Top 5 Sales Categories" DataField="CatGrpDesc">
                                                <HeaderStyle CssClass="GridHead" />
                                                <ItemStyle CssClass="CASGridPadding GridItem" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Ext Sales Amt $" DataFormatString="{0:#,##0}" DataField="MTDSales">
                                                <HeaderStyle CssClass="GridHead" />
                                                <ItemStyle CssClass="CASGridPadding GridItem" HorizontalAlign="Right" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Margins $" DataFormatString="{0:#,##0}" DataField="MTDSaleMargin">
                                                <HeaderStyle CssClass="GridHead" />
                                                <ItemStyle CssClass="CASGridPadding GridItem" HorizontalAlign="Right" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Pounds Sold" DataFormatString="{0:#,##0}" DataField="MTDLbs">
                                                <HeaderStyle CssClass="GridHead" />
                                                <ItemStyle CssClass="CASGridPadding GridItem" HorizontalAlign="Right" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Margin %" DataField="MTDGMPct">
                                                <HeaderStyle CssClass="GridHead" />
                                                <ItemStyle CssClass="CASGridPadding GridItem" HorizontalAlign="Right" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Crp Avg" DataField="MTDGMPctCorpAvg">
                                                <HeaderStyle CssClass="GridHead" />
                                                <ItemStyle CssClass="CASGridPadding GridItem" HorizontalAlign="Right" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="$/Lb" DataField="MTDDOLPerLb">
                                                <HeaderStyle CssClass="GridHead" />
                                                <ItemStyle CssClass="CASGridPadding GridItem" HorizontalAlign="Right" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Crp Avg" DataField="MTDDolPerLBCorpAvg" DataFormatString="{0:#,##0.00}">
                                                <HeaderStyle CssClass="GridHead" />
                                                <ItemStyle CssClass="CASGridPadding GridItem" HorizontalAlign="Right" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="% Of Sales" DataField="MTDPctTotSales">
                                                <HeaderStyle CssClass="GridHead" />
                                                <ItemStyle CssClass="CASGridPadding GridItem" HorizontalAlign="Right" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Crp Avg" DataField="MTDPctTotSalesCorpAvg">
                                                <HeaderStyle CssClass="GridHead" />
                                                <ItemStyle CssClass="CASGridPadding GridItem" HorizontalAlign="Right" />
                                            </asp:BoundColumn>
                                        </Columns>
                                    </asp:DataGrid>
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
