<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HistSalesByPackageGroup.aspx.cs" Inherits="PFC.Intranet.SalesByPackageGroupDashboard.SalesByPackageGroup" %>

<%@ Register Src="../PrintUtility/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc4" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Hisory Sales by Package Grouping Report</title>
    <link href="../SalesByPackageGrouping/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script src="../Common/JavaScript/Common.js" type="text/javascript"></script>

    <script>

        //Javascript Function To Call Server Side Function Using Ajax
        function DeleteFiles(session)
        {
            SalesByPackageGroup.DeleteExcel('SalesByPackageGroup'+session).value
            parent.window.close();
        }

        function BindValue(sortExpression)
        {
            if(document.getElementById("hidSortExpression") !=null)
                document.getElementById("hidSortExpression").value = sortExpression;
            document.getElementById("btnSort").click();
        }
        
        function ShowHide(SHMode)
        {
            if (SHMode == "Show")
            {
                document.getElementById("HideLabel").style.display = "";
                document.getElementById("LeftMenu").style.display = "";
                document.getElementById("LeftMenuContainer").style.width = "200px";	
                document.getElementById('div-datagrid').style.width='810px';
                document.getElementById('hidShowMode').value='Show';
                document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='../Common/Images/HidButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Hide');\">";		
            }
            if (SHMode== "Hide")
            {
                document.getElementById("HideLabel").style.display = "none";
                document.getElementById("LeftMenu").style.display = "none";
                document.getElementById("LeftMenuContainer").style.width = "28px";		
                document.getElementById('div-datagrid').style.width='980px';
                document.getElementById('hidShowMode').value='HideL';
                document.getElementById("SHButton").innerHTML = "<img ID='Show' style='cursor:hand' src='../Common/Images/ShowButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Show');\">";
            }	
        }

        function ShowPanel()
        {
            if(document.getElementById('leftPanel')!=null)
            {
                document.getElementById('leftPanel').style.display="";
                document.getElementById("HideLabel").style.display = "";
                document.getElementById("LeftMenu").style.display = "";
                document.getElementById('imgHide').style.display="";
                document.getElementById('imgShow').style.display='none';
                document.getElementById('div-datagrid').style.width='810px';
                document.getElementById('hidShowMode').value='Show';
                document.getElementById('LeftMenuContainer').style.width = '200px';
                document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='../Common/Images/HidButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Hide');\">";		
            }
        }
        
        function excelfileTest()
        {
           ducument.getElementById.show.window.alert('Test');
        }
    </script>

</head>
<body onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
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
                                            Historical Sales by Package Grouping Report</td>
                                        <td align="right" style="width: 20%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td> 
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <img align="right" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            src="Common/Images/Close.gif" style="cursor: hand; padding-right: 2px;" /></td>
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
            <tr id="trHead" class="PageBg">
                <td class="LeftPadding TabHead" style="height: 10px" colspan="2">
                    <asp:UpdatePanel ID="pnlBranch" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <table cellspacing="0" cellpadding="0" height="40px" width="100%">
                                <tr>                                    
                                    <td width="175px">
                                        <asp:Label ID="lblSalesGrp" runat="server" Text=""></asp:Label></td>
                                    <td width="175px">
                                        <asp:Label ID="lblBranch" runat="server" Text=""></asp:Label></td>                                                                    
                                    <td width="*">&nbsp;</td>
                                    <td align="right" rowspan="2">
                                        </td>                                     
                                </tr>                              
                                <tr>                                                               
                                    <td colspan="1">
                                        <asp:Label ID="lblOrderSource" runat="server" Text=""></asp:Label></td>   
                                    <td colspan="1">
                                        <asp:Label ID="lblPkgType" runat="server" Text=""></asp:Label></td>                                      
                                </tr>                                                               
                                
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <asp:UpdatePanel ID="upnlCalendar" UpdateMode="conditional" RenderMode="inline" runat="server">
                        <ContentTemplate>
                            <table cellspacing="0" cellpadding="0" id="leftPanel" style="display: none;" height="515px">
                                <tr>
                                    <td valign="top" style="background-color: #F4FBFD; border-right-width: 1px; border-right-style: solid;
                                        border-right-color: #8CD5EA;" height="515px">
                                        <table id="LeftMenuContainer" width="200" border="0" cellspacing="0" cellpadding="2">
                                            <tr>
                                                <td class="ShowHideBarBk" id="HideLabel">
                                                    <div align="right">
                                                        Select Date Range</div>
                                                </td>
                                                <td width="1" class="ShowHideBarBk">
                                                    <div align="right" id="SHButton">
                                                        <img id="Hide" style="cursor: hand" src="../Common/Images/HidButton.gif" width="22"
                                                            height="21" onclick="ShowHide('Hide')"></div>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                            </tr>
                                        </table>
                                        <table id="LeftMenu" width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="redhead Left5pxPadd">
                                                    Beginning Date</td>
                                            </tr>
                                            <tr valign="top">
                                                <td width="100%" valign="top" class="Left5pxPadd">
                                                    <asp:Calendar BorderColor="#DAEEEF" ID="cldStartDt" runat="server" Visible="true"
                                                        Width="100%"></asp:Calendar>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="redhead Left5pxPadd">
                                                    Ending Date</td>
                                            </tr>
                                            <tr valign="top">
                                                <td width="100%" valign="top" class="Left5pxPadd">
                                                    <asp:Calendar SelectionMode="Day" BorderColor="#DAEEEF" ID="cldEndDt" runat="server"
                                                        Visible="true" Width="100%"></asp:Calendar>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr valign="top">
                                                <td width="100%" align="center" class=" Left5pxPadd">
                                                    <asp:ImageButton runat="server" ID="ibtnRunReport" ImageUrl="~/SalesByPackageGrouping/Common/Images/runreport.gif"
                                                        ImageAlign="middle" OnClick="ibtnRunReport_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 475px; width: 1020px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="False" PagerSettings-Visible="false" PageSize="19"
                                    Width="1020px" ID="dvInvoiceAnalysis" runat="server" AllowPaging="True"
                                    ShowFooter="True" AllowSorting="True" AutoGenerateColumns="False" OnRowDataBound="dvInvoiceAnalysis_RowDataBound"
                                    OnSorting="dvInvoiceAnalysis_Sorting">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px" HorizontalAlign="Center" />
                                    <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White" Height="19px" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="Left5pxPadd GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF" HorizontalAlign="Right" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px" HorizontalAlign="Right" />
                                    <EmptyDataRowStyle VerticalAlign="Top" BorderWidth="0px" CssClass="GridHead" BackColor="#DFF3F9" HorizontalAlign="Center" />
                                    <Columns>

                                        <asp:BoundField HtmlEncode="False" HeaderText="Start Week" DataField="StartWkCurDt" SortExpression="StartWkCurDt" DataFormatString="{0:d}">
                                            <ItemStyle HorizontalAlign="Center" Width="120px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="120px" />
                                        </asp:BoundField>                                                                         
                                        <asp:BoundField HtmlEncode="False" DataField="Per1Dol" HeaderText="Sales $" DataFormatString="{0:c0}" SortExpression="Per1Dol">
                                            <ItemStyle HorizontalAlign="Right" Width="120px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="120px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Per1GM" HeaderText="GM $" DataFormatString="{0:c0}" SortExpression="Per1GM">
                                            <ItemStyle HorizontalAlign="Right" Width="120px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="120px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Per1GMpct" HeaderText="GM %" DataFormatString="{0:#,##0.0}" SortExpression="Per1GMpct">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>                                    
                                        <asp:BoundField HtmlEncode="False" DataField="Per1Lbs" HeaderText="Lbs" DataFormatString="{0:#,##0}" SortExpression="Per1Lbs">
                                            <ItemStyle HorizontalAlign="Right" Width="120px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="120px" />
                                        </asp:BoundField>
                                        
                                        <asp:BoundField HtmlEncode="False" DataField="DolPerLb" HeaderText="$ per Lb" DataFormatString="{0:c}" SortExpression="DolPerLb">
                                            <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="70px" />
                                        </asp:BoundField>                                                                                                                
                                        <asp:BoundField HtmlEncode="False" DataField="GMPerLb" HeaderText="GM$ per Lb" DataFormatString="{0:c}" SortExpression="GMPerLb">
                                            <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="70px" />
                                        </asp:BoundField>   
                                           <asp:BoundField />                                                                                                                
                                    </Columns>
                                    <PagerSettings Visible="False" />
                                </asp:GridView>
                                <div align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>
                                <input type="hidden" runat="server" id="hidSortExpression" />
                                <asp:Button ID="btnSort" runat="server" Text="" Style="display: none;" OnClick="btnSort_Click" />
                                <input type="hidden" runat="server" id="hidSort" />
                            </div>
                            <div id="divPager" runat="server">
                                <uc3:pager ID="dvPager" runat="server" OnBubbleClick="Pager_PageChanged" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="BluBg buttonBar" colspan="2" height="20px" style="border-top: solid 1px #DAEEEF">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr>
                            <td>
                                <table cellpadding="0" cellspacing="0" style="padding-top: 1px;">
                                    <tr>
                                        <td>
                                            <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                        runat="server" Text=""></asp:Label>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td>
                                            <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
                                                <ProgressTemplate>
                                                    <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                                </ProgressTemplate>
                                            </asp:UpdateProgress>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="width: 80px">
                                <asp:UpdatePanel ID="pnlPrint" runat="server" Visible="false" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <uc4:PrintDialogue ID="pdInvoice" runat="server" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <table width="100%">
                        <uc2:BottomFooter ID="ucFooter" Title="Historical Sales by Package Grouping Report" runat="server" />
                    </table>
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hidShowMode" runat="server" />
        <asp:HiddenField ID="hidFileName" Value="" runat="server" />
    </form>

    <script>
        if (document.getElementById('hidShowMode').value == "Show")
        {
            document.getElementById('leftPanel').style.display="";
            document.getElementById('imgHide').style.display="";
            document.getElementById('imgShow').style.display='none';
            document.getElementById('div-datagrid').style.width='830px';
            document.getElementById('hidShowMode').value='Show';
        }
    </script>
</body>
</html>
