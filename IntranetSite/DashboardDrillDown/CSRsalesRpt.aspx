<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CSRsalesRpt.aspx.cs" Inherits="CSRSalesRpt" %>

<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Dashboard Performance Drilldown - Margin Report</title>
    <link href="StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../Common/Javascript/Common.js"></script>

    <script type="text/javascript" src="../Common/Javascript/ContextMenu.js"></script>

    <script>

function Close(Session)
{
    var str=CSRSalesRpt.DeleteExcel('MarginRpt_'+Session).value.toString();
    parent.window.close();
}

function PrintReport(Location, LocName, Range,csrName)
{
    var URL = "CSRSalesRptPreview.aspx?Location=" + Location + "&LocName=" + LocName + "&Range=" + Range + "&CSRName=" + csrName;
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
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <img style="cursor: hand" src="../Common/Images/Print.gif" align="middle" onclick="Javascript:PrintReport('<%=Request.QueryString["Location"] %>', '<%=Request.QueryString["LocName"] %>', '<%=Request.QueryString["Range"] %>','<%= Request.QueryString["CSRName"] %>');" />
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
                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                left: 5px; height: 555px; width: 940px; border: 0px solid;">
                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px"
                                    ShowFooter="True" AutoGenerateColumns="False" PageSize="22" AllowPaging="true"
                                    PagerStyle-Visible="false" AllowSorting="true" OnSortCommand="GridView1_SortCommand"
                                    OnItemDataBound="ItemDataBound">
                                    <HeaderStyle CssClass="GridHead" Wrap="false" BackColor="#DFF3F9" BorderColor="#DAEEEF"
                                        Height="20px" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" />
                                    <AlternatingItemStyle CssClass="Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Right" />
                                    <Columns>
<%--                                        <asp:BoundColumn HeaderText="Category" DataField="CategoryGroup" SortExpression="CategoryGroup">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                        </asp:BoundColumn>--%>

                                        <asp:TemplateColumn ItemStyle-Width="60px" HeaderText="Category" HeaderStyle-Width="60px"
                                            ItemStyle-HorizontalAlign="center" SortExpression="CategoryGroup">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCatNo" runat="server" Visible="false" Text='<%#DataBinder.Eval(Container,"DataItem.CategoryGroup")%>'></asp:Label>
                                                <asp:HyperLink ID="lnkCatNo" runat="server" Visible="false" Text='<%# DataBinder.Eval(Container,"DataItem.CategoryGroup")%>'
                                                        NavigateUrl='<%# "CatSalesRpt.aspx?CSRName="+Request.QueryString["CSRName"].ToString().Trim()+"&Range="+Request.QueryString["Range"].ToString().Trim()+"&Category="+DataBinder.Eval(Container,"DataItem.CategoryGroup")%>'></asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

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
                                            <HeaderStyle CssClass="GridHead" Width="70px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="70px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn HeaderText="Mgn $" DataField="MarginDollars" SortExpression="MarginDollars">
                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn HeaderText="Mgn/Lb" DataField="MarginPerLb" SortExpression="MarginPerLb"
                                            DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <table class="BluBordAll" border="0" cellspacing="0" cellpadding="0" style="position: relative;
                                    top: 0px; left: 0px; height: 30px; width: 590px; border: 1px solid;">
                                    <tr style="border: 1px solid #e1e1e1; background-color: #B3E2F0;">
                                        <td class="GridHead" align="left" style="border: 1px solid #e1e1e1; font-weight: bold;
                                            width: 63px">
                                            Grd-Tot:</td>
                                        <td class="Left5pxPadd" align="right" style="border: 1px solid #e1e1e1; font-weight: bold;
                                            width: 80px">
                                            <asp:Label ID="lblTotSales" runat="server" Text="n/a"></asp:Label>
                                        </td>
                                        <td class="Left5pxPadd" align="right" style="border: 1px solid #e1e1e1; font-weight: bold;
                                            width: 80px">
                                            <asp:Label ID="lblTotPounds" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border: 1px solid #e1e1e1; font-weight: bold;
                                            width: 60px">
                                            <asp:Label ID="lblTotPricePerLb" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border: 1px solid #e1e1e1; font-weight: bold;
                                            width: 70px">
                                            <asp:Label ID="lblTotMgnPct" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border: 1px solid #e1e1e1; font-weight: bold;
                                            width: 80px">
                                            <asp:Label ID="lblTotMgnDollars" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border: 1px solid #e1e1e1; font-weight: bold;
                                            width: 60px">                                            
                                            <asp:Label ID="lblTotMgnPerLb" runat="server" Text="n/a"></asp:Label>
                                            </td>
                                    </tr>
                                </table>
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
