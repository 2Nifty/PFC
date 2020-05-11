<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CanadaBLSummaryRpt.aspx.vb" Inherits="CanadaBLSummaryRpt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Canada Bill Of Lading Summary Report</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="javascript/ContextMenu.js"></script>

    <script language="javascript" src="javascript/browsercompatibility.js"></script>

    <script language="javascript">

    function ViewDetail()
    {
    var Url = "CanadaBLDetailRpt.aspx?BLNo=" + document.form1.BLNo.value;
/*  Url = "ProgressBar.aspx?destPage="+Url;   */
    window.open(Url,'CanadaBLDetailRpt','height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }
    
    </script>

</head>
<body bottommargin="0" onmouseup="Hide();">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td colspan="2" style="height: 98px">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td colspan="2" valign="middle" class="PageHead">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
                                    <tr>
                                        <td width="62%" valign="middle">
                                            <img src="Images/Logo.gif" hspace="25" vspace="10"></td>
                                    </tr>
                                </table>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td style="height: 20px" valign="middle">
                                            <div align="left" class="LeftPadding">
                                                Canada Bill Of Lading Summary Report</div>
                                        </td>
                                        <td style="height: 20px" valign="middle" align=right>
                                            <asp:ImageButton ID="ExportSummary" runat="server" style="cursor: hand" ImageUrl="images/ExporttoExcel.gif" />
                                            <img style="cursor: hand" src="images/list.gif" onclick="javascript:ViewDetail();" />
                                            <img style="cursor: hand" src="images/close.gif" id="imgClose" onclick="parent.window.close();" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                                <table width="100%" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td height="19px" class="TabHead">
                                            <span>Bill Of Lading Number: <%=(Request.QueryString("BLNo"))%>
                                            </span>
                                            <input type="hidden" name="BLNo" id="BLNo" value="<%=(Request.QueryString("BLNo"))%>">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2" width="990px" align="left" class="PageBg">
                                <table cellpadding="0" cellspacing="0">
                                    <tr height="19px" class="TabHead">
                                        <td style="width: 95px" class="LeftPadding">Total Transfers: </td>
                                        <td align="left" style="width: 65px"><asp:Label ID="lblTotTrf" runat="server"></asp:Label></td>
                                        <td style="width: 70px">Total Lines: </td>
                                        <td align="left" style="width: 65px"><asp:Label ID="lblTotLines" runat="server"></asp:Label></td>
                                        <td style="width: 90px">Total Net Wght: </td>
                                        <td align="left" style="width: 100px"><asp:Label ID="lblTotNet" runat="server"></asp:Label></td>
                                        <td style="width: 110px">Transfers Landed: </td>
                                        <td align="left" style="width: 65px"><asp:Label ID="lblTrfLanded" runat="server"></asp:Label></td>
                                        <td style="width: 85px">Lines Landed: </td>
                                        <td align="left" style="width: 65px"><asp:Label ID="lblLinesLanded" runat="server"></asp:Label></td>
                                        <td style="width: 105px">Net Wght Landed: </td>
                                        <td align="left" style="width: 75px"><asp:Label ID="lblNetLanded" runat="server"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" width="100%">
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; width: 1000px; height: 488px; border: 0px solid;">
                                                <asp:DataGrid ID="DataGrid1" BackColor="#F4FBFD" runat="server" AutoGenerateColumns="False" PagerStyle-Visible="false"
                                                    BorderWidth="1px" DataSourceID="SqlDataSource1">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="BL No" HeaderText="BL No" SortExpression="BL No">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Cat No" HeaderText="Category" SortExpression="Cat No">
                                                            <ItemStyle CssClass="GridItem" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Cat Desc" HeaderText="Description" SortExpression="Cat Desc">
                                                            <ItemStyle CssClass="GridItem" Width="250px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="250px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CatQty" HeaderText="Quantity" SortExpression="CatQty"
                                                            DataFormatString="{0:0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Unit of Measure Code" HeaderText="UOM" SortExpression="Unit of Measure Code">
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="50px" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CatLineCount" HeaderText="Line Count" SortExpression="CatLineCount">
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Avg Cost Ext" HeaderText="Avg Cost" SortExpression="Avg Cost Ext"
                                                            DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Declared Cost Ext" HeaderText="Declared Cost" ReadOnly="True"
                                                            SortExpression="Declared Cost Ext" DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Gross Wgt" HeaderText="Gross Wgt" SortExpression="Gross Wgt"
                                                            DataFormatString="{0:0.000}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Net Wgt" HeaderText="Net Wgt" SortExpression="Net Wgt"
                                                            DataFormatString="{0:0.000}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Net Wgt (KG)" HeaderText="Net Wgt (KG)" ReadOnly="True"
                                                            SortExpression="Net Wgt (KG)" DataFormatString="{0:0.000}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                    <PagerStyle Visible="False" />
                                                </asp:DataGrid>
                                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:csSQLPERP %>"
                                                    SelectCommand="--Summary info from tLandedCostLines&#13;&#10;SELECT     [BL No], [Cat No], [Cat Desc], SUM(Quantity) AS CatQty, [Unit of Measure Code], CatLineCount, SUM([Avg Cost Ext]) AS [Avg Cost Ext], &#13;&#10;                      SUM([Avg Cost Ext (CAN)]) AS [Declared Cost Ext], SUM([Gross Wgt Ext]) AS [Gross Wgt], SUM([Net Wgt Ext]) AS [Net Wgt], SUM([Net Wgt Ext (KG)]) &#13;&#10;                      AS [Net Wgt (KG)]&#13;&#10;FROM         tLandedCostLines&#13;&#10;GROUP BY [Cat No], [Cat Desc], [Unit of Measure Code], CatLineCount, [BL No]&#13;&#10;ORDER BY [Cat No]">
                                                </asp:SqlDataSource>
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
    </form>
</body>
</html>
