<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="CategoryDayReport.aspx.cs"
    Inherits="CategoryDayReport" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc4" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head id="Head1" runat="server">
    <title>365 Day Inventory Report</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
    function DeleteFiles()
    {
       var str=CategoryDayReport.DeleteExcel('DayInventoryCategory'+'<%=Session["SessionID"].ToString()%>').value.toString();
       parent.window.close();
    }
    function PrintReport()
    {     
        var url="status=" +'<%=Request.QueryString["status"]%>'+"&CategoryGroup="+'<%=Request.QueryString["CategoryGroup"]%>'+"&CategoryGroupDesc="+'<%=Request.QueryString["CategoryGroupDesc"]%>'+"&Branch="+document.getElementById("ddlBranch").options[document.getElementById("ddlBranch").selectedIndex].text+"&BranchCode="+document.getElementById("ddlBranch").options[document.getElementById("ddlBranch").selectedIndex].value+"&Sort="+document.getElementById("hidSort").value;           
        var hwin=window.open("CategoryDayReportPreview.aspx?"+url,"CategoryDayReportPreview" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1020/2))+',resizable=No',"");
        hwin.focus();
    } 
    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=DayInventoryReport",'CategoryHelp','height=710,width=1020,scrollbars=no,status=no,top=0,left='+((screen.width/2) - (1020/2))+',resizable=no',"");
    }    
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td colspan="2" valign="top">
                    <asp:ScriptManager ID="MyScript" EnablePartialRendering="true" runat="server">
                    </asp:ScriptManager>
                </td>
            </tr>
            <tr>
                <td valign="top" colspan="2">
                    <uc4:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" colspan="2" style="height: 30px">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                <td width="100%" height="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 30px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td style="height: 30px" width="75%">
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
                            <td class="subPageHead" style="height: 25px">
                                <span class="Left5pxPadd BannerText small">Cat Grp -
                                    <%=Request.QueryString["CategoryGroup"]%>
                                    <%=Request.QueryString["CategoryGroupDesc"]%>
                                </span><span class="BlackBold">Branch&nbsp;&nbsp;
                                    <asp:UpdatePanel ID="udpBranch" UpdateMode="Conditional" RenderMode="Inline" runat="server">
                                        <contenttemplate>
                        <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="150px"
                            AutoPostBack="true" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged">
                        </asp:DropDownList>
                     </contenttemplate>
                                    </asp:UpdatePanel>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="udpReportContent" UpdateMode="Conditional" RenderMode="Inline"
                                    runat="server">
                                    <contenttemplate>
                    <div id="PrintDG2">                    
                        <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
                            position: relative; top: 0px; left: 0px; width: 1020px; height: 493px; border: 0px solid;">
                            <asp:DataGrid ID="dgDayReport" Width="100%" runat="server" GridLines="both" BorderWidth="1px"
                                ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false" BorderColor="#DAEEEF"
                                AllowPaging="true" PageSize="18" PagerStyle-Visible="false" OnItemDataBound="dgDayReport_ItemDataBound"
                                OnPageIndexChanged="dgDayReport_PageIndexChanged" OnSortCommand="dgDayReport_SortCommand">
                                <HeaderStyle CssClass="GridHead" />
                                <ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White"
                                    Height="20px" HorizontalAlign="Left" />
                                <AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                    HorizontalAlign="Left" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                <Columns>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Item No."
                                        FooterStyle-HorizontalAlign="right" DataField="ItemNo" SortExpression="ItemNo"
                                        ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Qty O/H "
                                        FooterStyle-HorizontalAlign="right" DataField="OnHand" DataFormatString="{0:#,##0}"
                                        SortExpression="OnHand" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="$ O/H "
                                        FooterStyle-HorizontalAlign="right" DataField="OnHandValue" DataFormatString="{0:#,##0}"
                                        SortExpression="OnHandValue" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Daily Usg $ @ Avg Cost"
                                        FooterStyle-HorizontalAlign="right" DataField="DailySalesValue" DataFormatString="{0:#,##0.00}"
                                        SortExpression="DailySalesValue" ItemStyle-Wrap="false" ItemStyle-Width="80"
                                        HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Days Supply "
                                        FooterStyle-HorizontalAlign="right" DataField="DaysOnHand" DataFormatString="{0:#,##0.000}"
                                        SortExpression="DaysOnHand" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="$ Value Days Supply > 150D "
                                        FooterStyle-HorizontalAlign="right" DataField="OHgt150Days" DataFormatString="{0:#,##0}"
                                        SortExpression="OHgt150Days" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="$ Value Days Supply > 365D "
                                        FooterStyle-HorizontalAlign="right" DataField="OHgt365Days" DataFormatString="{0:#,##0}"
                                        SortExpression="OHgt365Days" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="200" ItemStyle-HorizontalAlign="left" HeaderText="Item Description "
                                        ItemStyle-CssClass="LeftPadding" FooterStyle-HorizontalAlign="left" DataField="ItemDesc"
                                        SortExpression="ItemDesc" ItemStyle-Wrap="false" ItemStyle-Width="300" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn></asp:BoundColumn>
                                </Columns>
                            </asp:DataGrid>
                            <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle"  Text="No Records Found"
                                    Visible="False"></asp:Label></center>
                        </div>
                        <uc3:pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged" />
                        <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                    <input type="hidden" runat="server" id="hidSort" />
                    </div>
                        </contenttemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%" cellpadding="0" cellspacing="0" class="BluBg">
                                    <tr>
                                        <td width="50%" align="left">
                                            <asp:UpdateProgress ID="upPanel" runat="server">
                                                <ProgressTemplate>
                                                    <span style="padding-left: 5px" class="TabHead">Loading...</span>
                                                </ProgressTemplate>
                                            </asp:UpdateProgress>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <uc2:BottomFrame ID="BottomFrame1" runat="server" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
