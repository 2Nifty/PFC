<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SelectedSKUAnalysis.aspx.cs" Inherits="SelectedSKUAnalysis" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head2" runat="server">
    <title>Selected SKU Analysis</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">
        function Close(session)
        {
            Unload(session);
            SelectedSKUAnalysis.Close(session).value;
            window.close();
        }

        function Unload(session)
        {
            SelectedSKUAnalysis.DelExcel(session).value;
        }

    </script>
</head>
<body onunload="javascript:Unload('<%=Session["SessionID"].ToString() %>');">
    <form id="frmMain" runat="server">
        <asp:ScriptManager runat="server" ID="smSKU">
        </asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;" id="mainTable">
            <tr>
                <td style="height:5%;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <%--BEGIN MAIN--%>
                    <table id="tblMain" style="width: 100%; height: 130px;" class="blueBorder" cellpadding="0" cellspacing="0">
                        <tr style="vertical-align:top;">
                            <td>
                                <%--TITLE--%>
                                <table id="tblTitle" border="0" cellpadding="0" cellspacing="0" style="width: 100%" class="lightBlueBg">
                                    <tr>
                                        <td class="Left5pxPadd BannerText">
                                            Selected SKU Analysis
                                        </td>

                                        <td align="right">
                                            <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                        </td>
                                        <td width="80px">
                                            <img align="right" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');"
                                                src="../Common/Images/Close.gif" style="cursor: hand; padding-right: 5px;" />
                                        </td>
                                    </tr>
                                </table>

                                <%--PARAMETERS--%>
<%--
                                <table cellspacing="0" cellpadding="0" height="40px" width="100%">
                                    <tr>
                                        <td class="Left5pxPadd PageBg TabHead">
                                            PARAMETERS HERE
                                        </td>
                                    </tr>
                                </table>
--%>

                                <%--BEGIN BODY--%>
                                <table cellpadding="0" border="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td align="left" valign="top">
                                            <asp:UpdatePanel ID="pnlGrid" UpdateMode="conditional" runat="server">
                                                <ContentTemplate>
                                                    <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                                        top: 0px; left: 0px; height: 560px; width: 1020px; border: 0px solid;">
                                                        <asp:GridView ID="gvSKU" runat="server" Width="2940px" PageSize="23" ShowHeader="true" ShowFooter="false" AutoGenerateColumns="false"
                                                            UseAccessibleHeader="false" PagerSettings-Visible="false" AllowPaging="true" AllowSorting="true"
                                                            OnRowDataBound="gvSKU_RowDataBound" OnSorting="gvSKU_Sorting" BorderWidth="0px">
                                                            <HeaderStyle CssClass="GridHead" Wrap="true" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Center" />
                                                            <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White" Height="20px" HorizontalAlign="Right" />
                                                            <AlternatingRowStyle CssClass="Left5pxPadd GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Right" />
                                                            <EmptyDataRowStyle CssClass="GridHead" BackColor="#DFF3F9" BorderWidth="0" Height="20px" HorizontalAlign="Right" />
                                                            <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Right" />
                                                            <Columns>
	                                                            <asp:BoundField HeaderText="Loc" DataField="Location" SortExpression="Location"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="40px"
	                                                                HeaderStyle-CssClass="locked" ItemStyle-CssClass="locked" FooterStyle-CssClass="locked" />

	                                                            <asp:BoundField HeaderText="Item No" DataField="ItemNo" SortExpression="ItemNo"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="100px"
	                                                                HeaderStyle-CssClass="locked" ItemStyle-CssClass="locked" FooterStyle-CssClass="locked" />
<%--
	                                                            <asp:BoundField HeaderText="Desc" DataField="ItemDesc" SortExpression="ItemDesc"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="left" ItemStyle-Width="250px" />
--%>
	                                                            <asp:BoundField HeaderText="Category Desc" DataField="CatDesc" SortExpression="CatDesc"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="left" ItemStyle-Width="240px" />

	                                                            <asp:BoundField HeaderText="Item Size" DataField="ItemSize" SortExpression="ItemSize"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="left" ItemStyle-Width="150px" />

	                                                            <asp:BoundField HeaderText="Plat" DataField="Finish" SortExpression="Finish"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="left" ItemStyle-Width="15px" />

	                                                            <asp:BoundField HeaderText="Qty OH" DataField="QtyOH" SortExpression="QtyOH" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="false" ItemStyle-Width="65px" />

	                                                            <asp:BoundField HeaderText="Qty Avl" DataField="QtyAvail" SortExpression="QtyAvail" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="false" ItemStyle-Width="65px" />

	                                                            <asp:BoundField HeaderText="ROP" DataField="ReOrderPoint" SortExpression="ReOrderPoint" DataFormatString="{0:#,##0.0}"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="SVC" DataField="SalesVelocityCd" SortExpression="SalesVelocityCd"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="40px" />

	                                                            <asp:BoundField HeaderText="CFV" DataField="CorpFixedVelocity" SortExpression="CorpFixedVelocity"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="40px" />

	                                                            <asp:BoundField HeaderText="Avg Cost/Alt UM" DataField="AvgCostAltUM" SortExpression="AvgCostAltUM" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="false" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="OH Cost Ext" DataField="ExtCostOH" SortExpression="ExtCostOH" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="false" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="Avg Value/LB" DataField="NetAvgLBVal" SortExpression="NetAvgLBVal" DataFormatString="{0:#,##0.000}"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />
<%--
	                                                            <asp:BoundField HeaderText="Cntr Qty/UM" DataField="AltSell" SortExpression="AltSell"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="Super Qty/UM" DataField="SuperUMQty" SortExpression="SuperUMQty"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />
--%>
	                                                            <asp:BoundField HeaderText="Cntr Qty" DataField="BaseStkQty" SortExpression="BaseStkQty" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="UM" DataField="AltSellUM" SortExpression="AltSellUM"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="left" ItemStyle-Width="15px" />

	                                                            <asp:BoundField HeaderText="Super Qty" DataField="SuperQty" SortExpression="SuperQty" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="UM" DataField="SuperUM" SortExpression="SuperUM"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="left" ItemStyle-Width="15px" />

	                                                            <asp:BoundField HeaderText="UnRcvd PO Qty" DataField="UnRcvdPOQty" SortExpression="UnRcvdPOQty" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="Trf Qty" DataField="TrfQty" SortExpression="TrfQty" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="Prod Qty" DataField="ProdOrdQty" SortExpression="ProdOrdQty" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="OTW Qty" DataField="OWQty" SortExpression="OWQty" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="100pc Wght" DataField="HundredWght" SortExpression="HundredWght" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="false" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="Net Wght" DataField="NetWght" SortExpression="NetWght" DataFormatString="{0:#,##0.000}"
	                                                                HtmlEncode="false" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="OH Net Ext" DataField="ExtNetWghtOH" SortExpression="ExtNetWghtOH" DataFormatString="{0:#,##0.000}"
	                                                                HtmlEncode="false" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="Gross Wght" DataField="GrossWght" SortExpression="GrossWght" DataFormatString="{0:#,##0.000}"
	                                                                HtmlEncode="false" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="Capacity" DataField="Capacity" SortExpression="Capacity" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="false" ItemStyle-Width="65px" />

	                                                            <asp:BoundField HeaderText="Routing" DataField="RoutingNo" SortExpression="RoutingNo"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="Stock Code" DataField="StockInd" SortExpression="StockInd"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="PPI Code" DataField="PPICode" SortExpression="PPICode"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="65px" />

	                                                            <asp:BoundField HeaderText="UPC Code" DataField="UPCCd" SortExpression="UPCCd"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="100px" />

	                                                            <asp:BoundField HeaderText="Parent BOM" DataField="ParentProdNo" SortExpression="ParentProdNo"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="100px" />

	                                                            <asp:BoundField HeaderText="Create Dt" DataField="EntryDt" SortExpression="EntryDt" DataFormatString="{0:MM/dd/yyyy}"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="List Price Alt" DataField="ListPriceAlt" SortExpression="ListPriceAlt" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="false" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="Smooth Avg Cost Alt" DataField="SmoothAvgAlt" SortExpression="SmoothAvgAlt" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="false" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="Price Cost Alt" DataField="PriceCostAlt" SortExpression="PriceCostAlt" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="false" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="Repl Cost Alt" DataField="ReplacementCostAlt" SortExpression="ReplacementCostAlt" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="false" ItemStyle-Width="75px" />

	                                                            <asp:BoundField HeaderText="Buy Grp No" DataField="BuyGroupNo" SortExpression="BuyGroupNo"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="Rpt Grp No" DataField="ReportGroupNo" SortExpression="ReportGroupNo"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="Rpt Sort" DataField="ReportSort" SortExpression="ReportSort"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="Web Ind" DataField="WebEnabledInd" SortExpression="WebEnabledInd"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="40px" />

	                                                            <asp:BoundField HeaderText="FQA Ind" DataField="FQAInd" SortExpression="FQAInd"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="40px" />

	                                                            <asp:BoundField HeaderText="Cert Req" DataField="CertRequiredInd" SortExpression="CertRequiredInd"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="40px" />

	                                                            <asp:BoundField HeaderText="Prop 65" DataField="Prop65" SortExpression="Prop65"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="40px" />

	                                                            <asp:BoundField HeaderText="Cust No" DataField="IMCustNo" SortExpression="IMCustNo" DataFormatString="{0:c}"
	                                                                HtmlEncode="false" ItemStyle-Width="50px" />

	                                                            <asp:BoundField HeaderText="Stock SKU" DataField="SVCInd" SortExpression="SVCInd"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="40px" />

	                                                            <asp:BoundField HeaderText="Harm Cd" DataField="Tariff" SortExpression="Tariff"
	                                                                HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="100px" />
                                                            </Columns>
                                                        </asp:GridView>
                                                        <input type="hidden" runat="server" id="hidSort" />
                                                    </div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                                <%--END BODY--%>
                            </td>
                        </tr>
                    </table>
                    <%--END MAIN--%>
                </td>
            </tr>

            <tr>    <%--Status Bar--%>
                <td class="lightBlueBg buttonBar" height="20px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true" runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="pnlProgress" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>    <%--PAGER Control--%>
                <td>
                <div id="divPager" runat="server">
                    <uc3:pager ID="gvPager" runat="server" OnBubbleClick="gvPager_PageChanged" />
                </div>
                
                </td>
            
            </tr>

            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Selected SKU Analysis" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

