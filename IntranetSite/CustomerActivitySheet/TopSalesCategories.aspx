<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TopSalesCategories.aspx.cs"
    Inherits="PFC.Intranet.CustomerActivity.TopSalesCategories" %>

<%@ Register TagPrefix="dotnet" Namespace="dotnetCHARTING" Assembly="dotnetCHARTING" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Top 5 Sales Categories</title>
    <link href="../CustomerActivitySheet/Styles/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body scroll="yes">
    <form id="form1" runat="server">
        <div id="SheetContainer~|">
            <table id="master" class="DashBoardBk" width="100%" style="page-break-after: always">
                <tr>
                    <td valign="top">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="SheetHolder">
                            <tr>
                                <td valign="top">
                                    <table width="100%" align="center" border="0" cellpadding="1" cellspacing="1" class="PageBorder">
                                        <tr>
                                            <td colspan="2">
                                                <table width="100%" border="0" cellpadding="2" cellspacing="2" class="SheetHead">
                                                    <tr>
                                                        <td class="redhead">
                                                            Run Date:
                                                            <%=DateTime.Now.ToString() %>
                                                        </td>
                                                        <td class="redhead">
                                                            TOP 5 SALES CATEGORIES</td>
                                                        <td class="redhead">
                                                            PAGE 3</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="BlackBold">
                                                    Customer # &nbsp;
                                                    <%=Request.QueryString["CustNo"].Trim() %>
                                                    &nbsp;&nbsp;
                                                    <asp:Label ID="lblCustName" runat="server" CssClass="BlackBold"></asp:Label>
                                                </div>
                                            </td>
                                            <td class="redhead">
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="75%">
                                                            <asp:RadioButtonList ID="rbtnlCustType" runat="server" RepeatDirection="Horizontal"
                                                                OnSelectedIndexChanged="rbtnlCustType_SelectedIndexChanged" AutoPostBack="true">
                                                                <asp:ListItem Text="Customer" Value="Customer"> </asp:ListItem>
                                                                <asp:ListItem Text="PFC Employee" Value="PFC Employee"></asp:ListItem>
                                                            </asp:RadioButtonList></td>
                                                        <td width="25%">
                                                            <div class="BlackBold">
                                                                <%=Request.QueryString["MonthName"].Trim()%>
                                                                '<%=Request.QueryString["Year"].Trim()%>
                                                            </div>
                                                        </td>
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
                                            <td colspan="2">
                                                <asp:DataGrid ID="dgSalesDetails" runat="server" Width="100%" BorderColor="#c9c6c6"
                                                    BorderWidth="1" AutoGenerateColumns="false" OnItemDataBound="dgSalesDetails_ItemDataBound">
                                                    <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" BackColor="#dff3f9" />
                                                    <ItemStyle CssClass="GridItem" Wrap="false" BackColor="#f4fbfd" />
                                                    <FooterStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                                    <Columns>
                                                        <asp:BoundColumn HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="CASGridPadding GridItem"
                                                            HeaderText="Top 5 Sales Categories" DataField="CatGrpDesc"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="CASGridPadding GridItem"
                                                            ItemStyle-HorizontalAlign="Right" HeaderText="Ext Sales Amt $" DataFormatString="{0:#,##0}"
                                                            DataField="MTDSales"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="CASGridPadding GridItem"
                                                            ItemStyle-HorizontalAlign="Right" HeaderText="Margins $" DataFormatString="{0:#,##0}"
                                                            DataField="MTDSaleMargin"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="CASGridPadding GridItem"
                                                            ItemStyle-HorizontalAlign="Right" HeaderText="Pounds Sold" DataFormatString="{0:#,##0}"
                                                            DataField="MTDLbs"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="CASGridPadding GridItem"
                                                            ItemStyle-HorizontalAlign="Right" HeaderText="Margin %" DataField="MTDGMPct"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="CASGridPadding GridItem"
                                                            HeaderText="Crp Avg" DataField="MTDGMPctCorpAvg" ItemStyle-HorizontalAlign="right">
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="CASGridPadding GridItem"
                                                            ItemStyle-HorizontalAlign="Right" HeaderText="$/Lb" DataField="MTDDOLPerLb"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="CASGridPadding GridItem"
                                                            HeaderText="Crp Avg" DataField="MTDDolPerLBCorpAvg" DataFormatString="{0:#,##0.00}"
                                                            ItemStyle-HorizontalAlign="right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="CASGridPadding GridItem"
                                                            ItemStyle-HorizontalAlign="Right" HeaderText="% Of Sales" DataField="MTDPctTotSales">
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="CASGridPadding GridItem"
                                                            HeaderText="Crp Avg" DataField="MTDPctTotSalesCorpAvg" ItemStyle-HorizontalAlign="right">
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="100%" align="center" colspan="2">
                                                <table width="100%" class="PageBorder">
                                                    <tr class="SheetHead">
                                                        <td class="redhead" align="center">
                                                            TOP 5 SALES CATEGORIES $</td>
                                                    </tr>
                                                    <tr>
                                                        <td width="100%">
                                                            <dotnet:Chart ID="chTopCategorieSales" Width="330" Height="200" runat="server" Use3D="true"
                                                                ImageFormat="Jpg">
                                                            </dotnet:Chart>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="100%" align="center" colspan="2">
                                                <table width="100%" class="PageBorder">
                                                    <tr class="SheetHead">
                                                        <td class="redhead" align="center">
                                                            TOP 5 CATEGORIES LB
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="100%">
                                                            <dotnet:Chart ID="chTopCategoriePounds" Width="330" Height="200" runat="server" Use3D="true"
                                                                ImageFormat="Jpg">
                                                            </dotnet:Chart>
                                                        </td>
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
            </table>
        </div>
    </form>
</body>
</html>
