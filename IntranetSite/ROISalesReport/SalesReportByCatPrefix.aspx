<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesReportByCatPrefix.aspx.cs"
    Inherits="Sales_Inventory_Report_SalesReportByCatPrefix" %>



<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<title>ROI Sales Report by Category Prefix</title>
<link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
<link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
 //Javascript function to Show the preview page
function PrintReport()
{
   
    var url= "CategoryGroupNo=" +'<%=Request.QueryString["CategoryGroupNo"]%>'+"&Sort="+document.getElementById("hidSort").value+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>&Year=<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "" %>';
    var hwin=window.open("SalesReportByCatPrefixPreview.aspx?"+url,"SalesPrefixPreview" ,'height=700,width=1010,scrollbars=no,status=no,top=0,left='+((screen.width)/2 - (1010/2))+',resizable=Yes',"");
    hwin.focus();
}

// Javascript Function To Call Server Side Function Using Ajax
function DeleteFiles()
{

   var str=Sales_Inventory_Report_SalesReportByCatPrefix.DeleteExcel('SalesInventoryCategoryPrefix'+'<%=Session["SessionID"].ToString()%>').value.toString();
   window.close();
} 
 
</script>


    <link href="../StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

</head>
<body>
    <form id="form1" runat="server">
       
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top" colspan="2">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" height="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                        <tr>
                            <td class="PageHead" colspan="5" style="height: 40px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText">
                                            ROI Sales Report by Category Prefix
                                        </td>
                                        <td align="right" style="width: 100px;padding-right:5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="280">
                                                <tr>
                                                    <td style="width: 100px">
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    <td style="width: 100px">
                                                        <img align="right" onclick="javascript:PrintReport();" src="../Common/Images/Print.gif"
                                                            style="cursor: hand" /></td>
                                                    <td style="width: 100px">
                                                        <img align="right" src="Common/Images/Buttons/Close.gif" style="cursor: hand" onclick="DeleteFiles();" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr id="trHead" class="PageBg" height="15px">
                            <td class="LeftPadding TabHead" style="width:200px">
                                Category Group : <%= Request.QueryString["CategoryGroupNo"]%>
                            </td>                           
                            <td class="LeftPadding TabHead" style="width:200px">
                                Fiscal Period : <%= ROISalesReport.GetDate(Request.QueryString["Month"])%>&nbsp;<%=Request.QueryString["Year"]%> 
                            </td>                           
                            <td class="TabHead" style="width:200px">
                                Run By : <%= Session["UserName"].ToString()%>
                            </td>
                            <td class="TabHead" style="width:300px" colspan=2 align=left>
                                Run Date : <%=DateTime.Now.ToShortDateString()%>
                            </td>                            
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                        top: 0px; left: 0px; width: 1020px; height: 510px; border: 0px solid;">
                        <div id="PrintDG2">
                            <asp:DataGrid ID="dgPrefix" Width="100%" PageSize="19" runat="server" GridLines="both"
                                BorderWidth="1px" AllowSorting="true" AutoGenerateColumns="false" ShowFooter="true"
                                BorderColor="#DAEEEF" AllowPaging="true" PagerStyle-Visible="false" OnItemDataBound="dgPrefix_ItemDataBound"
                                OnPageIndexChanged="dgPrefix_PageIndexChanged" OnSortCommand="dgPrefix_SortCommand">
                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                <ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White"
                                    Height="20px" HorizontalAlign="Left" />
                                <AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                    HorizontalAlign="Left" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                <Columns>
                                    <asp:BoundColumn HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="left" HeaderText="Cat Prefix"
                                        DataField="CatPrefixDes" SortExpression="CatPrefixDes" ItemStyle-Wrap="false" ItemStyle-Width="150px"
                                        HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        HeaderText="Inv $ " DataField="ExtAvgCost" DataFormatString="{0:#,##0}" SortExpression="ExtAvgCost"
                                        ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        HeaderText="12 Mos Sales " DataField="Roll12Sales" DataFormatString="{0:#,##0}"
                                        SortExpression="Roll12Sales" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        HeaderText="M_OH " DataField="MOH" DataFormatString="{0:#,##0.0}" SortExpression="MOH"
                                        ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        HeaderText="$/Lb " DataField="DLB" DataFormatString="{0:#,##0.000}" SortExpression="DLB"
                                        ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        HeaderText="GM/Lb " DataField="GMLB" DataFormatString="{0:#,##0.000}" SortExpression="GMLB"
                                        ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                   <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="% Corp $" FooterStyle-HorizontalAlign="right"
                                        DataField="Roll12PctTotSalesCorpAvg" DataFormatString="{0:#,##0.0}" SortExpression="Roll12PctTotSalesCorpAvg" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="% Corp GM $" FooterStyle-HorizontalAlign="right"
                                        DataField="Roll12GMPctCorpAvg" DataFormatString="{0:#,##0.0}" SortExpression="Roll12GMPctCorpAvg" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        HeaderText="ROI" DataField="ROI" DataFormatString="{0:#,##0.000}" SortExpression="ROI"
                                        ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn></asp:BoundColumn>
                                </Columns>
                            </asp:DataGrid> 
                            <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle"  Text="No Records Found"
                                    Visible="False"></asp:Label></center>                             
                        </div>
                    </div>                   
                    <uc3:pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged" />
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:BottomFrame ID="BottomFrame1" runat="server" />
                    <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                    <input type="hidden" runat="server" id="hidSort" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>


