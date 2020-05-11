<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesCategoryDetail.aspx.cs"
    Inherits="CustomerActivitySheet_SalesCategoryDetail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Sales Category Details</title>
    <link href="../CustomerActivitySheet/Styles/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body scroll="yes">
    <form id="form1" runat="server">
        <div id="SheetContainer~|">
            <% if((Request.QueryString["mode"]  !=null && Request.QueryString["mode"].Trim() != "Print" &&  Request.QueryString["mode"].Trim()!= "Export") || Request.QueryString["mode"] ==null)
           { %>
            <table id="master" class="DashBoardBk" width="100%" style="page-break-after: always">
                <tr>
                    <td valign="top">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="SheetHolder">
                            <tr>
                                <td valign="top">
                                    <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="PageBorder">
                                        <tr>
                                            <td colspan="2">
                                                <table width="100%" border="0" cellpadding="2" cellspacing="2" class="SheetHead">
                                                    <tr>
                                                        <td class="redhead" style="height: 24px">
                                                            Run Date:
                                                            <%=DateTime.Now.ToString() %>
                                                        </td>
                                                        <td class="redhead" style="height: 24px">
                                                            SALES CATEGORY DETAIL</td>
                                                        <td class="redhead" style="height: 24px">
                                                            PAGE 4</td>
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
                                                                <asp:ListItem Text="PFC Employee" Value="PFC Employee" Selected="true"></asp:ListItem>
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
                                            <td align="center" colspan="2">
                                                <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                                    Visible="False"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <asp:DataGrid ID="dgSalesDetails" runat="server" BorderWidth="1" BorderColor="#c9c6c6"
                                                    Width="100%" AutoGenerateColumns="false" GridLines="both">
                                                    <HeaderStyle HorizontalAlign="center" CssClass="GridHead" BackColor="#dff3f9" />
                                                    <ItemStyle CssClass="GridItem" BackColor="#f4fbfd" />
                                                    <FooterStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                                    <Columns>
                                                        <asp:BoundColumn ItemStyle-CssClass="CASGridPadding GridItem" HeaderStyle-CssClass="GridHead"
                                                            HeaderText="SALES DETAILS" DataField="CatGrpDesc"></asp:BoundColumn>
                                                        <asp:BoundColumn ItemStyle-CssClass="CASGridPadding GridItem" HeaderStyle-CssClass="GridHead"
                                                            HeaderText="Ext Sales Amt $" DataField="MTDSales" ItemStyle-HorizontalAlign="right">
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn ItemStyle-CssClass="CASGridPadding GridItem" HeaderStyle-CssClass="GridHead"
                                                            HeaderText="Margins $" DataField="MTDGM" ItemStyle-HorizontalAlign="right"></asp:BoundColumn>
                                                        <asp:BoundColumn ItemStyle-CssClass="CASGridPadding GridItem" HeaderStyle-CssClass="GridHead"
                                                            HeaderText="Pounds Sold" DataField="MTDLbs" ItemStyle-HorizontalAlign="right"></asp:BoundColumn>
                                                        <asp:BoundColumn ItemStyle-CssClass="CASGridPadding GridItem" HeaderStyle-CssClass="GridHead"
                                                            HeaderText="Margin %" DataField="MTDGMPct" ItemStyle-HorizontalAlign="right"></asp:BoundColumn>
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
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <%}
       else if(Request.QueryString["mode"].Trim()=="Print" || Request.QueryString["mode"].Trim()== "Export")
       {
            %>
            <div id="divHTML" runat="server">
            </div>
            <%} %>
        </div>
    </form>
</body>
</html>
