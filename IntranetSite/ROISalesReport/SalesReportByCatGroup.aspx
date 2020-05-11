<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesReportByCatGroup.aspx.cs"
    Inherits="Sales_Inventory_Report_SalesReportByCatGroup" %>


<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager"  TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ROI Sales Report by Category Group</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
<script>
 //Javascript function to Show the preview page
        function PrintReport()
        {
            
                    var url= "Sort="+document.getElementById("hidSort").value+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>&Year=<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "" %>';
                    var hwin=window.open('SalesReportByCatGroupPreview.aspx?'+url, '', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
                    hwin.focus();
                        
   //         window.open("SalesReportByCatGroupPreview.aspx?Sort="+document.getElementById("hidSort").value+" Month=06,"SalesPreview" ,'height=700,width=1020,scrollbars=no,status=no,top=0,left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
        }
         // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles()
       {
           var str=Sales_Inventory_Report_SalesReportByCatGroup.DeleteExcel('SalesInventory'+'<%=Session["SessionID"].ToString()%>').value.toString();
           parent.window.close();
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
                <td width="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 40px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            ROI Sales Report by Category Group
                                        </td>
                                        <td align="right"  style="width: 30%;padding-right:5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td >
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif" ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td> 
                                                         <img style="cursor:hand" src="../common/images/Print.gif" id="btnPrint"  onclick="javascript:PrintReport();" /></td>
                                                    <td >
                                                        <img align="right" onclick="Javascript:DeleteFiles();"
                                                            src="Common/Images/Buttons/Close.gif" style="cursor: hand;padding-right:2px;" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr id="trHead" class="PageBg" height="15px">
                            <td class="LeftPadding TabHead" style="width:400px">
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
                            <asp:DataGrid ID="dgCategoryGroup" Width="100%" runat="server" GridLines="both" BorderWidth="1px" ShowFooter="true" AllowSorting="true"
                                AutoGenerateColumns="false" BorderColor="#DAEEEF" AllowPaging="true" PageSize="19" PagerStyle-Visible="false" OnItemDataBound="dgCategoryGroup_ItemDataBound" OnPageIndexChanged="dgCategoryGroup_PageIndexChanged" OnSortCommand="dgCategoryGroup_SortCommand">
                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                <ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White"
                                    Height="20px" HorizontalAlign="Left" />
                                <AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                    HorizontalAlign="Left" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                <Columns>
                                    <asp:TemplateColumn SortExpression="CatGroup" ItemStyle-HorizontalAlign="left"
                                        HeaderText="Cat Group">
                                        <ItemTemplate>
                                            <asp:HyperLink ID="hplCategoryGroup" runat="server" Visible="true" NavigateUrl='<%# "SalesReportByCatPrefix.aspx?Month="+Request.QueryString["Month"].ToString().Trim()+"&Year="+Request.QueryString["Year"].ToString().Trim() +"&CategoryGroupNo=" + DataBinder.Eval(Container,"DataItem.CatGrpNo")%>' Text='<%#DataBinder.Eval(Container,"DataItem.CatGroup")%>'></asp:HyperLink> 
                                        </ItemTemplate>
                                        <ItemStyle Width="250px" Wrap="False" />
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Inv $" FooterStyle-HorizontalAlign="right"
                                        DataField="ExtAvgCost" DataFormatString="{0:#,##0}" SortExpression="ExtAvgCost" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="12 Mos Sales" FooterStyle-HorizontalAlign="right"
                                        DataField="Roll12Sales" DataFormatString="{0:#,##0}" SortExpression="Roll12Sales" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="M_OH" FooterStyle-HorizontalAlign="right"
                                        DataField="AvgCostSales" DataFormatString="{0:#,##0.0}" SortExpression="AvgCostSales" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="$/Lb" FooterStyle-HorizontalAlign="right"
                                        DataField="SalesLbs" DataFormatString="{0:#,##0.000}" SortExpression="SalesLbs" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="GM/Lb" FooterStyle-HorizontalAlign="right"
                                        DataField="GMLbs" DataFormatString="{0:#,##0.000}" SortExpression="GMLbs" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="% Corp $" FooterStyle-HorizontalAlign="right"
                                        DataField="Roll12PctTotSalesCorpAvg" DataFormatString="{0:#,##0.0}" SortExpression="Roll12PctTotSalesCorpAvg" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="% Corp GM $" FooterStyle-HorizontalAlign="right"
                                        DataField="Roll12GMPctCorpAvg" DataFormatString="{0:#,##0.0}" SortExpression="Roll12GMPctCorpAvg" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="ROI" DataField="ROI" SortExpression="ROI" DataFormatString="{0:#,##0.000}" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="right"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
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
