<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CanadaBLDetailRpt.aspx.vb" Inherits="CanadaBLDetailRpt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Canada Bill Of Lading Detail Report</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="javascript/ContextMenu.js"></script>

    <script language="javascript" src="javascript/browsercompatibility.js"></script>

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
                                                Canada Bill Of Lading Detail Report</div>
                                        </td>
                                        <td style="height: 20px" valign="middle" align="right">
                                            <asp:ImageButton ID="ExportDetail" runat="server" style="cursor: hand" ImageUrl="images/ExporttoExcel.gif" />
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
                                        </td>
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
                                                left: 0px; width: 1010px; height: 488px; border: 0px solid;">
                                                <asp:DataGrid ID="DataGrid1" BackColor="#F4FBFD" runat="server" AutoGenerateColumns="False"
                                                    BorderWidth="1px" DataSourceID="SqlDataSource1" Width="1640px">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="TO #" HeaderText="TO #" SortExpression="TO #">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn DataField="Line No_" HeaderText="Line #" SortExpression="Line No_">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>                                                        
                                                        
                                                        <asp:BoundColumn DataField="CatLineCount" HeaderText="Cat Line Count" SortExpression="CatLineCount">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Cat No" HeaderText="Category" SortExpression="Cat No">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Unit of Measure Code" HeaderText="UOM" SortExpression="Unit of Measure Code">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="40px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="40px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Quantity" HeaderText="Quantity" SortExpression="Quantity"
                                                            DataFormatString="{0:0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="ItemDesc" HeaderText="Description" SortExpression="ItemDesc">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="250px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="250px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="BL No" HeaderText="BL No" SortExpression="BL No">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Item No_" HeaderText="Item No" SortExpression="Item No_">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="125px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="125px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Transfer-from Code" HeaderText="Trf From Code" SortExpression="Transfer-from Code">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Gross Wgt Ext" HeaderText="Gross Wgt Ext" SortExpression="Gross Wgt Ext"
                                                            DataFormatString="{0:0.000}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn DataField="Net Wgt Ext" HeaderText="Net Wgt Ext" SortExpression="Net Wgt Ext"
                                                            DataFormatString="{0:0.000}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn DataField="Net Wgt Ext (KG)" HeaderText="Net Wgt Ext (KG)" SortExpression="Net Wgt Ext (KG)"
                                                            DataFormatString="{0:0.000}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn DataField="Unit Cost" HeaderText="Avg (Unit) Cost" SortExpression="Unit Cost"
                                                            DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn DataField="Avg Cost Ext" HeaderText="Avg Cost Ext" SortExpression="Avg Cost Ext"
                                                            DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="AntLandCost" HeaderText="Landed Cost" SortExpression="AntLandCost"
                                                            DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Direct Unit Cost" HeaderText="Direct Unit Cost" SortExpression="Direct Unit Cost"
                                                            DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Landed Adder %" HeaderText="Landed %" SortExpression="Landed Adder %"
                                                            DataFormatString="{0:0.000}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Duty %" HeaderText="Duty %" SortExpression="Duty %"
                                                            DataFormatString="{0:0.000}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="AvgCostAdders" HeaderText="Avg Cost Landed %" SortExpression="AvgCostAdders"
                                                            DataFormatString="{0:0.000}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="AvgCost Duty Only" HeaderText="Canada Declaration Value" SortExpression="AvgCost Duty Only"
                                                            DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Avg Cost Ext (CAN)" HeaderText="Canada Declaration Value Ext" SortExpression="Avg Cost Ext (CAN)"
                                                            DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="Harmonizing Tariff Code" HeaderText="Harmonizing Code" SortExpression="Harmonizing Tariff Code">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="150px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="150px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>                                                                                                  
                                                    </Columns>
                                                    <PagerStyle Visible="False" />
                                                </asp:DataGrid>
                                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:csSQLPERP %>"
                                                    SelectCommand="--Detail info from tLandedCostLines&#13;&#10;SELECT * FROM tLandedCostLines&#13;&#10;ORDER BY [Cat No]">
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
