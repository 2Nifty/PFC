<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DayReport.aspx.cs" Inherits="DayReport" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc4" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>365 Day Inventory Report</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script>
    function DeleteFiles()
       {
            var str=DayReport.DeleteExcel('DayReport'+'<%=Session["SessionID"].ToString()%>').value.toString();
            parent.window.close();           
       }
    function PrintReport()
    {
         var url="status=" +'<%=Request.QueryString["status"]%>'+"&Sort="+document.getElementById("hidSort").value;           
       var hwin= window.open("DayReportPreview.aspx?"+url,"DayReportPreview" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width)/2 - (1020/2))+',resizable=no',"");
       hwin.focus();
    }
    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=DayInventoryReport",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
    } 
    </script>    
</head>
<body>
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top" colspan="2">
                    <uc4:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" height="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 40px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td style="height: 40px" width="75%">
                                            <div class="Left5pxPadd">
                                                <div align="left" class="BannerText">
                                                    <asp:Label ID="lblMenuName" CssClass="BannerText" runat="server" Text=""></asp:Label></div>
                                            </div>
                                        </td>
                                        <td align="right" style="width: 100px; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="280">
                                                <tr>
                                                    <td style="width: 100px; padding: 2px;">
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td style="width: 100px; padding: 2px;">
                                                        <img style="cursor: hand" src="../common/images/Print.gif" id="btnPrint" onclick="javascript:PrintReport();" /></td>
                                                    <td style="width: 100px; padding: 2px;">
                                                        <img style="cursor: hand" src="../common/images/Close.gif" id="Img1" onclick="javascript:DeleteFiles();" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr id="trHead" class="PageBg" height="20px">
                            <td class="LeftPadding TabHead" style="width:400px">
                                Fiscal Period : <%=DayInventoryReport.GetDateCondition()%>
                            </td>                           
                            <td class="TabHead" style="width:200px">
                                Run By : <%= Session["UserName"].ToString()%>
                            </td>
                            <td class="TabHead" style="width:300px" colspan=2 align=left>
                                Run Date : <%=DateTime.Now.ToString()%>
                            </td>                            
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="PrintDG2">
                        <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
                            position: relative; top: 0px; left: 0px; width: 1020px; height: 516px; border: 0px solid;">
                            <asp:DataGrid ID="dgDayReport" Width="100%" runat="server" GridLines="both" BorderWidth="1px"
                                ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false" BorderColor="#DAEEEF"
                                AllowPaging="true" PageSize="19" PagerStyle-Visible="false" OnItemDataBound="dgDayReport_ItemDataBound"
                                OnPageIndexChanged="dgDayReport_PageIndexChanged" OnSortCommand="dgDayReport_SortCommand">
                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                <ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White"
                                    Height="20px" HorizontalAlign="Left" />
                                <AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                    HorizontalAlign="Left" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                <Columns>
                                    <asp:TemplateColumn SortExpression="CategoryGroup" ItemStyle-HorizontalAlign="center" 
                                        HeaderText="Cat Grp ">
                                        <ItemTemplate>
                                            <asp:HyperLink ID="hplCategoryGroup" Target="_blank" runat="server" Visible="true" 
                                                NavigateUrl='<%# "CategoryDayReport.aspx?CategoryGroup=" + DataBinder.Eval(Container,"DataItem.CategoryGroup")+"&CategoryGroupDesc="+ DataBinder.Eval(Container,"DataItem.CategoryDsc")+"&status="+strStatus%>'
                                                Text='<%#DataBinder.Eval(Container,"DataItem.CategoryGroup")%>'></asp:HyperLink>
                                            <asp:Label runat="server" ID="lblCatGroup" Text='<%#DataBinder.Eval(Container,"DataItem.CategoryGroup")%>' Visible=false></asp:Label>
                                        </ItemTemplate>                     
                                        <ItemStyle Width="80px" Wrap="False" />
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Qty O/H "
                                        FooterStyle-HorizontalAlign="right" DataField="ContainersOH" DataFormatString="{0:#,##0}"
                                        SortExpression="ContainersOH" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="$ O/H "
                                        FooterStyle-HorizontalAlign="right" DataField="InvExtCost" DataFormatString="{0:#,##0}"
                                        SortExpression="InvExtCost" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Daily Usg $ @ Avg Cost"
                                        FooterStyle-HorizontalAlign="right" DataField="AvgCstPerDay" DataFormatString="{0:#,##0.00}"
                                        SortExpression="AvgCstPerDay" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Days Supply "
                                        FooterStyle-HorizontalAlign="right" DataField="DaysOH" DataFormatString="{0:#,##0.000}"
                                        SortExpression="DaysOH" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="$ Value Days Supply > 150D "
                                        FooterStyle-HorizontalAlign="right" DataField="OHover150Days" DataFormatString="{0:#,##0}"
                                        SortExpression="OHover150Days" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="$ Value Days Supply > 365D "
                                        FooterStyle-HorizontalAlign="right" DataField="OHover365Days" DataFormatString="{0:#,##0}"
                                        SortExpression="OHover365Days" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="200" ItemStyle-HorizontalAlign="left" HeaderText="Category Description "
                                        ItemStyle-CssClass="LeftPadding" FooterStyle-HorizontalAlign="left" DataField="CategoryDsc"
                                        SortExpression="CategoryDsc" ItemStyle-Wrap="false" ItemStyle-Width="200" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn></asp:BoundColumn>
                                </Columns>
                            </asp:DataGrid>
                        </div>
                    </div>
                    <center>
                        <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                            Visible="False"></asp:Label></center>
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
