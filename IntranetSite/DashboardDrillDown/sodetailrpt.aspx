<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SODetailRpt.aspx.cs" Inherits="SODetailRpt" %>

<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Dashboard Performance Drilldown - Sales Order Detail</title>
    
    <link href="StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Common/Javascript/Common.js"></script>
    <script type="text/javascript" src="../Common/Javascript/ContextMenu.js"></script>

<style type="text/css"> 
    .LeftPad {padding-left: 5px;}
</style> 

<script>
    function Close(Session)
    {
        var str=SODetailRpt.DeleteExcel('SODetail_'+Session).value.toString();
        parent.window.close();
    }

    function PrintReport(Location, LocName, InvoiceNo, Range)
    {
        var URL = "SODetailRptPreview.aspx?Location=" + Location + "&LocName=" + LocName + "&Customer=000000&Invoice=" + InvoiceNo + "&Range=" + Range + "&Source=" + document.getElementById("hidSource").value;;
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
                                            <asp:Label ID="lblInvHd" runat="server"></asp:Label>
                                        </td>
                                        <td align="right" style="width:280px; padding-right: 3px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td align="left" style="padding-right:50px">
                                                        <asp:DropDownList ID="ddlOrderSource" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlOrderSource_SelectedIndexChanged"></asp:DropDownList>
                                                    </td>
                                                    <td align="right" style="padding-right:10px">
                                                        <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td align="right" style="padding-right:10px">
                                                        <img Style="cursor: hand" src="../Common/Images/Print.gif"
                                                            align="middle" onclick="Javascript:PrintReport('<%=Request.QueryString["Location"] %>', '<%=Request.QueryString["LocName"] %>', '<%=Request.QueryString["Invoice"] %>', '<%=Request.QueryString["Range"] %>');" />
                                                    </td>
                                                    <td align="right" style="padding-right:10px">
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
                                top: 0px; left: 5px; height: 560px; width: 1000px; border: 0px solid;">
                                    <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px"
                                        ShowFooter="True" AutoGenerateColumns="False" PageSize="22" AllowPaging="true"
                                        PagerStyle-Visible="false" AllowSorting="true" OnSortCommand="GridView1_SortCommand"
                                        OnItemDataBound="ItemDataBound" width="1275px">
                                    <HeaderStyle CssClass="GridHead" Wrap=false BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Center" />
                                    <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" />
                                    <AlternatingItemStyle CssClass="Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundColumn HeaderText="Invoice" DataField="InvoiceNo" SortExpression="InvoiceNo">
                                            <HeaderStyle CssClass="GridHead" Width="65px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="65px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Cust No" DataField="CustNo" SortExpression="CustNo">
                                            <HeaderStyle CssClass="GridHead" Width="65px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="65px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Customer Name" DataField="CustName" SortExpression="CustName">
                                            <HeaderStyle CssClass="GridHead" Width="275px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Left" Width="275px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                        </asp:BoundColumn>
                                        
                                        <asp:BoundColumn HeaderText="Loc" DataField="Location" SortExpression="Location">
                                            <HeaderStyle CssClass="GridHead" Width="30px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="30px" />
                                        </asp:BoundColumn>
                                        
                                        <asp:BoundColumn HeaderText="Post Date" DataField="ARPostDt" SortExpression="ARPostDt" DataFormatString="{0:MM/dd/yyyy}">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="75px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Item No" DataField="ItemNo" SortExpression="ItemNo">
                                            <HeaderStyle CssClass="GridHead" Width="95px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="95px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Line" DataField="LineNumber" SortExpression="LineNumber">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Ship Qty" DataField="QtyShipped" SortExpression="QtyShipped">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="75px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

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
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="50px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="50px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Mgn $" DataField="MarginDollars" SortExpression="MarginDollars">
                                            <HeaderStyle CssClass="GridHead" Width="125px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="125px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Mgn/Lb" DataField="MarginPerLb" SortExpression="MarginPerLb" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="50px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="50px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Mgn %" DataField="MarginPct" SortExpression="MarginPct" DataFormatString="{0:N2}%">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="50px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="50px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Src" DataField="OrderSource" SortExpression="OrderSource">
                                            <HeaderStyle CssClass="GridHead" Width="35px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="35px" />
                                        </asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <table class="BluBordAll" border="0" cellspacing="0" cellpadding="0"
                                  style="position: relative; top: 0px; left: 0px; height: 30px; border: 1px solid;">
                                    <tr style="border:1px solid #e1e1e1; background-color:#B3E2F0;">
                                        <td class="GridHead" style="border:1px solid #e1e1e1;"><table width="61px"><tr><td>&nbsp;</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1;"><table width="61px"><tr><td>&nbsp;</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1;" align="left"><table width="234px"><tr><td>Grand Totals:</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1;"><table width="29px"><tr><td>&nbsp;</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1;"><table width="72px"><tr><td>&nbsp;</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1;"><table width="84px"><tr><td>&nbsp;</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1;"><table width="54px"><tr><td>&nbsp;</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="75px"><tr><td><asp:Label ID="lblTotShipQty" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="123px"><tr><td><asp:Label ID="lblTotSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="101px"><tr><td><asp:Label ID="lblTotPounds" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="58px"><tr><td><asp:Label ID="lblTotPricePerLb" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="121px"><tr><td><asp:Label ID="lblTotMgnDollars" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="58px"><tr><td><asp:Label ID="lblTotMgnPerLb" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="58px"><tr><td><asp:Label ID="lblTotMgnPct" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1;"><table width="34px"><tr><td>&nbsp;</td></tr></table></td>
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
                    <input type="hidden" runat="server" id="hidSource" />
                </td>
            </tr>
        </table>
    </form>
        <script>window.parent.document.getElementById("Progress").style.display='none';</script>
</body>
</html>
