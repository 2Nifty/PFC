<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CatSalesRpt.aspx.cs" Inherits="CatSalesRpt" %>

<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Dashboard Performance Drilldown - Sales Report By Category</title>
    
    <link href="StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Common/Javascript/Common.js"></script>
    <script type="text/javascript" src="../Common/Javascript/ContextMenu.js"></script>

<script>
function Close(Session)
{
    var str=CatSalesRpt.DeleteExcel('CatSalesRpt_'+Session).value.toString();
    parent.window.close();
}

function PrintReport(Location, LocName, Range, Category, csrName)
{
    var URL = "CatSalesRptPreview.aspx?Location=" + Location + "&LocName=" + LocName + "&Range=" + Range + "&Category=" + Category + "&CSRName=" + csrName;
    window.open(URL,'Preview','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
}

</script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr>
                <td height="5%" id="tdHeader" colspan="2">
                    <uc1:Header ID="ucHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 30px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            <asp:Label ID="lblRangeHd" runat="server"></asp:Label>
                                            <asp:Label ID="lblBranchHd" runat="server"></asp:Label>
                                        </td>
                                        <td align="right" style="width: 280px; padding-right: 3px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <img style="cursor: hand" src="../Common/Images/Print.gif" align="middle" onclick="Javascript:PrintReport('<%=Request.QueryString["Location"] %>', '<%=Request.QueryString["LocName"] %>', '<%=Request.QueryString["Range"] %>', '<%=Request.QueryString["Category"] %>','<%= Request.QueryString["CSRName"] %>');" />
                                                    </td>
                                                    <td>
                                                        <img align="right" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');"
                                                            src="../Common/Images/Close.gif" style="cursor: hand; padding-right: 2px;" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="left" valign="top" id="tdgrid">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" style="overflow: auto; position: relative; top: 0px; height: 565px; width: 1020px; border: 0px solid;">
                                <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                    height: 545px; width: 1170px; border: 0px solid;">

                                    <table class="GridHead" width="1170px" border="0" cellspacing="0" cellpadding="0"
                                        style="position: relative; top: 0px; left: 0px; height: 20px; width: 1170px;">
                                        <tr style="background-color: #DFF3F9;">
                                            <td class="GridHead">
                                                <table width="226px">
                                                    <tr>
                                                        <td>
                                                            &nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="GridHead" style="border-left: 1px solid #e1e1e1;" align="center">
                                                <table width="279px">
                                                    <tr>
                                                        <td>
                                                            - - - - - Current Month To Date - - - - -
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="GridHead" style="border-left: 1px solid #e1e1e1;" align="center">
                                                <table width="282px">
                                                    <tr>
                                                        <td>
                                                            - - - - - Last Closed Month - - - - -
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="GridHead" style="border-left: 1px solid #e1e1e1;" align="center">
                                                <table width="280px">
                                                    <tr>
                                                        <td>
                                                            - - - - - Previous Closed Month - - - - -
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px"
                                        ShowFooter="True" AutoGenerateColumns="False" PageSize="21" AllowPaging="true"
                                        PagerStyle-Visible="false" AllowSorting="true" OnSortCommand="GridView1_SortCommand"
                                        OnItemDataBound="ItemDataBound">
                                        <HeaderStyle CssClass="GridHead" Wrap="false" BackColor="#DFF3F9" Height="20px" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" />
                                        <AlternatingItemStyle CssClass="Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF" />
                                        <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                            HorizontalAlign="Right" />
                                        <Columns>
                                            <asp:BoundColumn HeaderText="Cust No" DataField="CustNo" SortExpression="CustNo">
                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                                                <FooterStyle HorizontalAlign="Left" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Cust Name" DataField="CustName" SortExpression="CustName">
                                                <HeaderStyle CssClass="GridHead" Width="250px" Font-Bold="True" />
                                                <ItemStyle HorizontalAlign="Left" Width="250px" />
                                                <FooterStyle HorizontalAlign="Left" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Sales $" DataField="SalesDollars" SortExpression="SalesDollars">
                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Pounds" DataField="Lbs" SortExpression="Lbs">
                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Price/Lb" DataField="SalesPerLb" SortExpression="SalesPerLb"
                                                DataFormatString="{0:C}">
                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Mgn %" DataField="MarginPct" SortExpression="MarginPct"
                                                DataFormatString="{0:N2}%">
                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Mgn $" DataField="MarginDollars" Visible="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Sales $" DataField="LMSalesDollars" SortExpression="LMSalesDollars">
                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Pounds" DataField="LMLbs" SortExpression="LMLbs">
                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Price/Lb" DataField="LMSalesPerLb" SortExpression="LMSalesPerLb"
                                                DataFormatString="{0:C}">
                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Mgn %" DataField="LMMarginPct" SortExpression="LMMarginPct"
                                                DataFormatString="{0:N2}%">
                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Mgn $" DataField="LMMarginDollars" Visible="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Sales $" DataField="PMSalesDollars" SortExpression="PMSalesDollars">
                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Pounds" DataField="PMLbs" SortExpression="PMLbs">
                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Price/Lb" DataField="PMSalesPerLb" SortExpression="PMSalesPerLb"
                                                DataFormatString="{0:C}">
                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Mgn %" DataField="PMMarginPct" SortExpression="PMMarginPct"
                                                DataFormatString="{0:N2}%">
                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                <FooterStyle CssClass="Left5pxPadd" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Mgn $" DataField="PMMarginDollars" Visible="false"></asp:BoundColumn>
                                        </Columns>
                                    </asp:DataGrid>
                                    <table class="BluBordAll" width="1170px" border="0" cellspacing="0" cellpadding="0"
                                        style="position: relative; top: 0px; left: 0px; height: 30px; width: 1170px; border: 1px solid;">
                                        <tr style="border: 1px solid #e1e1e1; background-color: #B3E2F0;">
                                            <td class="GridHead" style="border:1px solid #e1e1e1;" align="left"><table width="63px"><tr><td>&nbsp;</td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1;" align="left"><table width="174px"><tr><td>Grand Totals</td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="80px"><tr><td><asp:Label ID="lblTotSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="78px"><tr><td><asp:Label ID="lblTotPounds" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="62px"><tr><td><asp:Label ID="lblTotPricePerLb" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="61px"><tr><td><asp:Label ID="lblTotMgnPct" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="83px"><tr><td><asp:Label ID="lblLMTotSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="80px"><tr><td><asp:Label ID="lblLMTotPounds" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="61px"><tr><td><asp:Label ID="lblLMTotPricePerLb" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="60px"><tr><td><asp:Label ID="lblLMTotMgnPct" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="80px"><tr><td><asp:Label ID="lblPMTotSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="80px"><tr><td><asp:Label ID="lblPMTotPounds" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="60px"><tr><td><asp:Label ID="lblPMTotPricePerLb" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                            <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="60px"><tr><td><asp:Label ID="lblPMTotMgnPct" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="BluBg">
                    <table width="100%" id="Table1" runat="SERVER">
                        <tr>
                            <td>
                                <uc1:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" Visible="true" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <table width="100%">
                        <uc2:BottomFooter ID="ucFooter" Title="Dashboard Performance Drilldown" runat="server" />
                    </table>
                    <input type="hidden" runat="server" id="hidSort" />
                </td>
            </tr>
        </table>
    </form>

    <script>window.parent.document.getElementById("Progress").style.display='none';</script>

</body>
</html>