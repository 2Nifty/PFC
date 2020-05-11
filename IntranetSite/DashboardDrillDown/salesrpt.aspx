<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesRpt.aspx.cs" Inherits="SalesRpt" %>

<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Dashboard Performance Drilldown - Sales Report</title>
    
    <link href="StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Common/Javascript/Common.js"></script>
    <script type="text/javascript" src="../Common/Javascript/ContextMenu.js"></script>

<script>



//    function ViewDetail(InvoiceNo)
    function ViewDetail()
    {
    
    alert('ViewDetail');
    
//        var URL = "SODetailRpt.aspx?Location=**~LocName=******~Customer=******~Invoice=" + InvoiceNo + "~Range=" + document.getElementById("hidRange").value;
//        URL = "ProgressBar.aspx?destPage=" + URL;
//        window.open(URL,'Detail','height=710,width=1020,scrollbars=no,status=yes,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }




function Close(Session)
{
    var str=SalesRpt.DeleteExcel('SalesRpt_'+Session).value.toString();
    parent.window.close();
}

function PrintReport(Location, LocName, Range)
{
    var URL = "SalesRptPreview.aspx?Location=" + Location + "&LocName=" + LocName + "&Range=" + Range;
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
                                        <td align="right" style="width:280px; padding-right: 3px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <img Style="cursor: hand" src="../Common/Images/Print.gif"
                                                            align="middle" onclick="Javascript:PrintReport('<%=Request.QueryString["Location"] %>', '<%=Request.QueryString["LocName"] %>', '<%=Request.QueryString["Range"] %>');" />
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
                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative;
                                top: 0px; left: 5px; height: 555px; width: 940px; border: 0px solid;">
                                    <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px"
                                        ShowFooter="True" AutoGenerateColumns="False" PageSize="22" AllowPaging="true"
                                        PagerStyle-Visible="false" AllowSorting="true" OnSortCommand="GridView1_SortCommand"
                                        OnItemDataBound="ItemDataBound">
                                    <HeaderStyle CssClass="GridHead" Wrap=false BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Center" />
                                    <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" />
                                    <AlternatingItemStyle CssClass="Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:TemplateColumn ItemStyle-Width="60px" HeaderText="Category" HeaderStyle-Width="60px"
                                            ItemStyle-HorizontalAlign="center" SortExpression="CategoryGroup">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCatNo" runat="server" Visible="false" Text='<%#DataBinder.Eval(Container,"DataItem.CategoryGroup")%>'></asp:Label>
                                                <asp:HyperLink ID="lnkCatNo" runat="server" Visible="false" Text='<%# DataBinder.Eval(Container,"DataItem.CategoryGroup")%>'
                                                        NavigateUrl='<%# "CatSalesRpt.aspx?CSRName=&Location="+Request.QueryString["Location"].ToString().Trim()+"&LocName="+Request.QueryString["LocName"].ToString().Trim()+"&Range="+Request.QueryString["Range"].ToString().Trim()+"&Category="+DataBinder.Eval(Container,"DataItem.CategoryGroup")%>'></asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        
                                        <asp:BoundColumn HeaderText="Sales $" DataField="SalesDollars" SortExpression="SalesDollars">
                                            <HeaderStyle CssClass="GridHead" Width="125px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="125px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Pounds" DataField="Lbs" SortExpression="Lbs">
                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="100px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Price/Lb" DataField="SalesPerLb" SortExpression="SalesPerLb" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Mgn %" DataField="MarginPct" SortExpression="MarginPct" DataFormatString="{0:N2}%">
                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Mgn $" DataField="MarginDollars" SortExpression="MarginDollars">
                                            <HeaderStyle CssClass="GridHead" Width="125px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="125px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>
                                        
                                        <asp:BoundColumn HeaderText="Mgn/Lb" DataField="MarginPerLb" SortExpression="MarginPerLb" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Budget Sales" DataField="BudgetSales" SortExpression="BudgetSales">
                                            <HeaderStyle CssClass="GridHead" Width="125px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="125px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>
                                                                                
                                        <asp:BoundColumn HeaderText="Budget Mgn" DataField="BudgetMargin" SortExpression="BudgetMargin">
                                            <HeaderStyle CssClass="GridHead" Width="125px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="125px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Budget Mgn %" DataField="BudgetMarginPct" SortExpression="BudgetMarginPct" DataFormatString="{0:N2}%">
                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <table class="BluBordAll" width="860" border="0" cellspacing="0" cellpadding="0"
                                  style="position: relative; top: 0px; left: 0px; height: 30px; width: 940px; border: 1px solid;">
                                    <tr style="border:1px solid #e1e1e1; background-color:#B3E2F0;">
                                        <td class="GridHead" align="left" style="border:1px solid #e1e1e1; font-weight:bold; width:66px">Grd-Tot:</td>
                                        <td class="Left5pxPadd" align="right" style="border:1px solid #e1e1e1; font-weight:bold; width:114px">
                                            <asp:Label ID="lblTotSales" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border:1px solid #e1e1e1; font-weight:bold; width:94px">
                                            <asp:Label ID="lblTotPounds" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border:1px solid #e1e1e1; font-weight:bold; width:55px">
                                            <asp:Label ID="lblTotPricePerLb" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border:1px solid #e1e1e1; font-weight:bold; width:74px">
                                            <asp:Label ID="lblTotMgnPct" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border:1px solid #e1e1e1; font-weight:bold; width:115px">
                                            <asp:Label ID="lblTotMgnDollars" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border:1px solid #e1e1e1; font-weight:bold; width:58px">
                                            <asp:Label ID="lblTotMgnPerLb" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border:1px solid #e1e1e1; font-weight:bold; width:114px">
                                            <asp:Label ID="lblTotBudgetSales" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border:1px solid #e1e1e1; font-weight:bold; width:114px">
                                            <asp:Label ID="lblTotBudgetMgn" runat="server" Text="n/a"></asp:Label></td>
                                        <td class="Left5pxPadd" align="right" style="border:1px solid #e1e1e1; font-weight:bold; width:70px">
                                            <asp:Label ID="lblTotBudgetMgnPct" runat="server" Text="n/a"></asp:Label></td>
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