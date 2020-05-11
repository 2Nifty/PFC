<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CSRSOCustomerRpt.aspx.cs" Inherits="CSRSOCustomerRpt" %>

<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Dashboard Performance Drilldown - Sales Orders By Customer</title>
    
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
    var str=CSRSOCustomerRpt.DeleteExcel('SOCustomer_'+Session).value.toString();
    parent.window.close();
}

function PrintReport(Location, LocName, CustNo, Range, csrName)
{
    var URL = "CSRSOCustomerRptPreview.aspx?Location=" + Location + "&LocName=" + LocName + "&Customer=" + CustNo + "&Invoice=**********&Range=" + Range + "&CSRName=" + csrName;
    window.open(URL,'Preview','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
}

function ViewCustomer(CustNo)
{
    //This link appears to work properly using SOHeaderRpt instead of CSRSOHeaderRpt
    //Both CSRSOHeaderRpt & CSRSODetailRpt appear to have been programmed to return ONLY the complete set of invoices based on the specified CSRName
    //var URL = "CSRSOHeaderRpt.aspx?Location=**~LocName=******~Customer=" + CustNo + "~Invoice=0000000000~Range=" + document.getElementById("hidRange").value + "~CSRName=" + document.getElementById("hidCSRName").value;
    var URL = "SOHeaderRpt.aspx?Location=**~LocName=******~Customer=" + CustNo + "~Invoice=0000000000~Range=" + document.getElementById("hidRange").value;
    URL = "ProgressBar.aspx?destPage=" + URL;
    window.open(URL,'Header','height=710,width=1020,scrollbars=no,status=yes,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
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
                                            <asp:Label ID="lblCustHd" runat="server"></asp:Label>
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
                                                            align="middle" onclick="Javascript:PrintReport('<%=Request.QueryString["Location"] %>', '<%=Request.QueryString["LocName"] %>', '<%=Request.QueryString["Customer"] %>', '<%=Request.QueryString["Range"] %>','<%=Request.QueryString["CSRName"] %>');" />
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
                                top: 0px; left: 5px; height: 555px; width: 1010px; border: 0px solid;">
                                    <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px" Width="1245px"
                                        ShowFooter="True" AutoGenerateColumns="False" PageSize="22" AllowPaging="true"
                                        PagerStyle-Visible="false" AllowSorting="true" OnSortCommand="GridView1_SortCommand"
                                        OnItemDataBound="ItemDataBound">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Center" />
                                    <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" />
                                    <AlternatingItemStyle CssClass="Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:HyperLinkColumn HeaderText="Cust No" DataTextField="CustNo" DataNavigateURLField="CustNo" SortExpression="CustNo"
                                                             DataNavigateUrlFormatString="javascript:ViewCustomer('{0}');">
                                            <HeaderStyle CssClass="GridHead" Width="65px" Font-Bold="True" />
                                            <ItemStyle CssClass="GreenLink" HorizontalAlign="Center" Width="65px" />
                                        </asp:HyperLinkColumn>

                                        <asp:BoundColumn HeaderText="Customer Name" DataField="CustName" SortExpression="CustName">
                                            <HeaderStyle CssClass="GridHead" Width="250px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Left" Width="250px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                        </asp:BoundColumn>
                                        
                                        <asp:BoundColumn HeaderText="Sales $" DataField="SalesDollars" SortExpression="SalesDollars">
                                            <HeaderStyle CssClass="GridHead" Width="85px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="85px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Pounds" DataField="Lbs" SortExpression="Lbs">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="75px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Price/Lb" DataField="SalesPerLb" SortExpression="SalesPerLb" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="GridHead" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="40px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Mgn $" DataField="MarginDollars" SortExpression="MarginDollars">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="75px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Mgn/Lb" DataField="MarginPerLb" SortExpression="MarginPerLb" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="40px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Mgn %" DataField="MarginPct" SortExpression="MarginPct" DataFormatString="{0:N2}%">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="40px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="MTD Goal $" DataField="MTDGoalDol" SortExpression="MTDGoalDol">
                                            <HeaderStyle CssClass="GridHead" Width="85px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="85px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Goal GM%" DataField="MTDGoalGMPct" SortExpression="MTDGoalGMPct">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="40px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:TemplateColumn HeaderStyle-Width="85px" HeaderText="YTD Sales $" ItemStyle-Width="85px"
                                            ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="right" SortExpression="YTDSalesDol">
                                            <ItemTemplate>
                                                <asp:HyperLink ID="hplYTDSalesDol" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.YTDSalesDol")%>'>
                                                </asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:BoundColumn HeaderText="YTD Goal $" DataField="YTDGoalDol" SortExpression="YTDGoalDol">
                                            <HeaderStyle CssClass="GridHead" Width="85px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="85px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Goal GM%" DataField="YTDGoalGMPct" SortExpression="YTDGoalGMPct">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="40px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Web Sales $" DataField="SalesDollarsWeb" SortExpression="SalesDollarsWeb">
                                            <HeaderStyle CssClass="GridHead" Width="85px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="85px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Web Mgn $" DataField="MarginDollarsWeb" SortExpression="MarginDollarsWeb">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="75px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Web Mgn %" DataField="MarginPctWeb" SortExpression="MarginPctWeb" DataFormatString="{0:N2}%">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="40px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="% Web Orders" DataField="WebPctSales" SortExpression="WebPctSales" DataFormatString="{0:N2}%">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="40px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="PrevMth1SalesDol" DataField="PrevMth1SalesDol" SortExpression="PrevMth1SalesDol" DataFormatString="{0:c}" Visible="false">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="100px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Right" Width="100px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="PrevMth2SalesDol" DataField="PrevMth2SalesDol" SortExpression="PrevMth2SalesDol" DataFormatString="{0:c}" Visible="false">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="100px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Right" Width="100px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="PrevMth3SalesDol" DataField="PrevMth3SalesDol" SortExpression="PrevMth3SalesDol" DataFormatString="{0:c}" Visible="false">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="100px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Right" Width="100px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="PrevMth1GMPct" DataField="PrevMth1GMPct" SortExpression="PrevMth1GMPct" DataFormatString="{0:0.0%}" Visible="false">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="45px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Right" Width="45px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="PrevMth2GMPct" DataField="PrevMth2GMPct" SortExpression="PrevMth2GMPct" DataFormatString="{0:0.0%}" Visible="false">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="45px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Right" Width="45px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="PrevMth3GMPct" DataField="PrevMth3GMPct" SortExpression="PrevMth3GMPct" DataFormatString="{0:0.0%}" Visible="false">
                                            <HeaderStyle CssClass="GridHead LeftPad" Width="45px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Right" Width="45px" />
                                            <FooterStyle CssClass="Left5pxPadd" />
                                        </asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>

                                <table id="tblGrdTot" class="BluBordAll" border="0" cellspacing="0" cellpadding="0" runat="server">
                                    <tr style="border:1px solid #e1e1e1; background-color:#B3E2F0;">
                                        <td class="GridHead" style="border:1px solid #e1e1e1;" align="left"><table width="55px"><tr><td>&nbsp;</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1;" align="left"><table width="185px"><tr><td>Grand Totals:</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="78px"><tr><td><asp:Label ID="lblTotSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="71px"><tr><td><asp:Label ID="lblTotPounds" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="42px"><tr><td><asp:Label ID="lblTotPricePerLb" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="71px"><tr><td><asp:Label ID="lblTotMgnDol" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="42px"><tr><td><asp:Label ID="lblTotMgnPerLb" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="47px"><tr><td><asp:Label ID="lblTotMgnPct" runat="server" Text="n/a"></asp:Label></td></tr></table></td>

                                        <td id="td1" runat="server" class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="79px"><tr><td><asp:Label ID="lblMTDGoal" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td id="td2" runat="server" class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="47px"><tr><td><asp:Label ID="lblMTDGoalGM" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td id="td3" runat="server" class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="78px"><tr><td><asp:Label ID="lblYTDSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td id="td4" runat="server" class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="81px"><tr><td><asp:Label ID="lblYTDGoal" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td id="td5" runat="server" class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="48px"><tr><td><asp:Label ID="lblYTDGoalGM" runat="server" Text="n/a"></asp:Label></td></tr></table></td>                                        

                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="77px"><tr><td><asp:Label ID="lblTotWebSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="69px"><tr><td><asp:Label ID="lblTotWebMgnDol" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="47px"><tr><td><asp:Label ID="lblTotWebMgnPct" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="48px"><tr><td><asp:Label ID="lblTotWebPctSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                    </tr>
                                </table>

<%--                                <table class="BluBordAll" border="0" cellspacing="0" cellpadding="0"
                                  style="position: relative; top: 0px; left: 0px; height: 30px; border: 1px solid;">
                                    <tr style="border:1px solid #e1e1e1; background-color:#B3E2F0;">
                                        <td class="GridHead" style="border:1px solid #e1e1e1;" align="left"><table width="55px"><tr><td>&nbsp;</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1;" align="left"><table width="190px"><tr><td>Grand Totals:</td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="96px"><tr><td><asp:Label ID="lblTotSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="88px"><tr><td><asp:Label ID="lblTotPounds" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="48px"><tr><td><asp:Label ID="lblTotPricePerLb" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="87px"><tr><td><asp:Label ID="lblTotMgnDol" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="51px"><tr><td><asp:Label ID="lblTotMgnPerLb" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="53px"><tr><td><asp:Label ID="lblTotMgnPct" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="96px"><tr><td><asp:Label ID="lblTotWebSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="85px"><tr><td><asp:Label ID="lblTotWebMgnDol" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="53px"><tr><td><asp:Label ID="lblTotWebMgnPct" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                        <td class="GridHead" style="border:1px solid #e1e1e1; padding-right:3px;" align="right"><table width="52px"><tr><td><asp:Label ID="lblTotWebPctSales" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                    </tr>
                                </table>--%>
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
                    <asp:HiddenField ID="hidRange" runat="server" />  
                    <asp:HiddenField ID="hidCSRName" runat="server" />                  
                </td>
            </tr>
        </table>
    </form>
    
        <script>window.parent.document.getElementById("Progress").style.display='none';</script>

</body>
</html>

