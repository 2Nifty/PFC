<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AItemSalesRpt.aspx.cs" Inherits="AItemSalesRpt" %>
<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>"A" Item Sales Report</title>
        <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="../Common/javascript/ContextMenu.js"></script>

    <script language="javascript" src="../Common/javascript/browsercompatibility.js"></script>

    <script>

    function LoadHelp()
    {
        window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }
    
    function PrintReport()
    {
        var URL = "AItemPreview.aspx?SortCommand=" + document.getElementById("hidSort").value;
        window.open(URL,'Preview','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }

    </script>
</head>
<body>
    <form id="form1" runat="server">
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="100%" height="400" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td colspan="2" valign="middle" >
                        <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
                            <tr><td valign="top" colspan=2>
                                <uc1:PageHeader ID="PageHeader1" runat="server" />
                            </td></tr>
                            <tr><td class="PageHead" style="height: 40px"><div class="LeftPadding"><div align="left" class="BannerText"> "A" Item Sales Report</div></div></td>
                                <td class="PageHead"  style="height: 40px" >
                            <div class="LeftPadding"><div align="right" class="BannerText" >
                                            &nbsp;<asp:ImageButton ID="ExportRpt" runat="server" Style="cursor: hand" ImageUrl="../Common/images/ExporttoExcel.gif"
                                                OnClick="ExportRpt_Click" />
                                            <img src="../Common/images/Print.gif" onclick="Javascript:PrintReport();" style="cursor: hand" />
                                            <img src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                            <img id="btnClose" src="../Common/images/close.gif" style="cursor: hand" runat="server" />
                             </div></div></td>
                            </tr>
                        </table>
                </td>
            </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr class="Left5pxPadd">
                                        <td valign="top" width="100%" style="height: 314px">
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; width: 1000px; height: 400px; border: 0px solid;">
                                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px"
                                                    ShowFooter="False" AutoGenerateColumns="False" PageSize="18" AllowPaging="true"
                                                    PagerStyle-Visible="false" AllowSorting="true" OnSortCommand="GridView1_SortCommand">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="ItemNo" HeaderText="Item No" SortExpression="ItemNo">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Loc" HeaderText="Loc" SortExpression="Loc">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="30px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="30px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Description" HeaderText="Description" SortExpression="Description">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="150px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="150px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
<%--                                                        <asp:BoundColumn DataField="CorpFixedVelCode" HeaderText="Corp Fixed Velocity" SortExpression="CorpFixedVelCode">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>--%>
                                                        <asp:BoundColumn DataField="TotUse30" HeaderText="30 Day Usage" SortExpression="TotUse30"
                                                            DataFormatString="{0:N0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TotUseWgt" HeaderText="Usage Wgt" SortExpression="TotUseWgt"
                                                            DataFormatString="{0:N2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AvailQty" HeaderText="Available Qty" SortExpression="AvailQty"
                                                            DataFormatString="{0:N0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AvailWgt" HeaderText="Available Wgt" SortExpression="AvailWgt"
                                                            DataFormatString="{0:N2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Net_Wgt" HeaderText="Net Wgt" SortExpression="Net_Wgt"
                                                            DataFormatString="{0:N2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Avg_CostM" HeaderText="Avg Cost" SortExpression="Avg_CostM"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SuggSell" HeaderText="Sugg. Sell Price" SortExpression="SuggSell"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="6MthAvgSellPrice" HeaderText="6 Mo. Avg Sell Price" SortExpression="6MthAvgSellPrice"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="LastWkAvgSellPrice" HeaderText="Last Wk Avg Sell Price" SortExpression="LastWkAvgSellPrice"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="2ndWkAvgSellPrice" HeaderText="2nd Wk Avg Sell Price" SortExpression="2ndWkAvgSellPrice"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="3rdWkAvgSellPrice" HeaderText="3rd Wk Avg Sell Price" SortExpression="3rdWkAvgSellPrice"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="4thWkAvgSellPrice" HeaderText="4th Wk Avg Sell Price" SortExpression="4thWkAvgSellPrice"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="BluBg">
                                <table width="1000px" id="tblPager" runat="SERVER">
                                    <tr>
                                        <td>
                                            <uc1:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" />
                                            <INPUT id="hidSort" type="hidden" name="hidSort" runat="server">
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
