<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvoiceAnalysisByCustNo.aspx.cs" Inherits="PFC.Intranet.DailySalesReports.InvoiceAnalysisByCustNoReport" %>

<%@ Register Src="../PrintUtility/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc4" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sales Performance by Filter Report</title>
    <link href="../DailySalesReport/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script src="../Common/JavaScript/Common.js" type="text/javascript"></script>

    <script>
//        function PrintReport(url)
//        {
//            var hwin=window.open('InvoiceAnalysisByCustNoPreview.aspx?'+url, 'InvoiceAnalysisPreview', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
//            hwin.focus();
//        }

        //Javascript Function To Call Server Side Function Using Ajax
        function DeleteFiles(session)
        {
            InvoiceAnalysisByCustNoReport.DeleteExcel('SalesPerformanceReport'+session).value
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
                                            Sales Performance by Filter Report
                                        </td>
                                        <td align="right" style="width: 20%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                <%--<td>
                                                        <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="conditional" runat="server" Visible="False">
                                                            <ContentTemplate>
                                                                <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnPrint" ImageUrl="~/Common/Images/Print.gif"
                                                                    ImageAlign="middle" OnClick="ibtnPrint_Click" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>--%>
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
                                        <asp:Label ID="lblBeginDate" runat="server" Text=""></asp:Label></td>
                                    <td width="175px">
                                        <asp:Label ID="lblEndDate" runat="server" Text=""></asp:Label></td>
                                    <td width="175px">
                                        <asp:Label ID="lblOrderType" runat="server" Text=""></asp:Label></td>
                                    <td width="175px">
                                        <asp:Label ID="lblBranch" runat="server" Text=""></asp:Label></td>
                                    <td width="175px">
                                        <asp:Label ID="lblChain" runat="server" Text=""></asp:Label></td>
                                    <td width="*">&nbsp;</td>
                                    <td align="right" rowspan="2">
                                        <img src="Common/Images/btn_showcal.gif" id="imgShow" onclick="ShowPanel();" />
                                        <img src="Common/Images/btn_hidecal.gif" style="display: none;" id="imgHide" onclick="javascript: document.getElementById('leftPanel').style.display='none';document.getElementById('imgShow').style.display='';this.style.display='none';document.getElementById('div-datagrid').style.width='1010px';hidShowMode.value='Hide';" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblCustomerNumber" runat="server" Text=""></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblTerritory" runat="server"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblCSR" runat="server"></asp:Label></td>
                                <%--<td>
                                        <asp:Label ID="lblState" runat="server" Text=""></asp:Label></td>--%>
                                    <td>
                                        <asp:Label ID="lblSalesPerson" runat="server" Text=""></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblRegionalMgr" runat="server" Text=""></asp:Label></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblShipment" runat="server" Text=""></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblPriceCd" runat="server" Text=""></asp:Label></td>
                                    <td colspan="2">
                                        <asp:Label ID="lblOrderSource" runat="server" Text=""></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblBuyGroup" runat="server" Text=""></asp:Label></td>
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
                                                    <asp:ImageButton runat="server" ID="ibtnRunReport" ImageUrl="~/DailySalesReport/Common/Images/runreport.gif"
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
                                top: 0px; left: 0px; height: 475px; width: 1015px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="false" PagerSettings-Visible="false" PageSize="19"
                                    Width="1220px" ID="dvInvoiceAnalysis" runat="server" AllowPaging="true" ShowHeader="true"
                                    ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false" OnRowDataBound="dvInvoiceAnalysis_RowDataBound"
                                    OnSorting="dvInvoiceAnalysis_Sorting">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px" HorizontalAlign="Center" />
                                    <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White" Height="19px" HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass="Left5pxPadd GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF" HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px" HorizontalAlign="Right" />
                                    <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9" HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:BoundField HtmlEncode="false" HeaderText="Branch" DataField="Branch" SortExpression="Branch">
                                            <ItemStyle HorizontalAlign="Center" Width="40px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="40px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="CustNo" HeaderText="No" SortExpression="CustNo">
                                            <ItemStyle HorizontalAlign="Center" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="CustName" HeaderText="Name" SortExpression="CustName">
                                            <ItemStyle HorizontalAlign="Left" Width="180px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="180px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="Chain" HeaderText="Chain" SortExpression="Chain">
                                            <ItemStyle HorizontalAlign="Left" Width="45px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="45px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="PriceCd" HeaderText="Price Code" SortExpression="PriceCd">
                                            <ItemStyle HorizontalAlign="Center" Width="45px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="45px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="NetSales" HeaderText="Net Sales" DataFormatString="{0:c}" SortExpression="NetSales">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="GMDollar" HeaderText="GM$" DataFormatString="{0:c}" SortExpression="GMDollar">
                                            <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="70px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="GMPct" HeaderText="GM %" DataFormatString="{0:#,##0.0}" SortExpression="GMPct">
                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="40px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="GoalGMDol" HeaderText="Goal Sales $" DataFormatString="{0:c}" SortExpression="GoalGMDol">
                                            <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="70px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="GoalGMPct" HeaderText="Goal GM %" DataFormatString="{0:#,##0.0}" SortExpression="GoalGMPct">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="TotWgt" HeaderText="Total Weight" DataFormatString="{0:#,##0.0}" SortExpression="TotWgt">
                                            <ItemStyle HorizontalAlign="Right" Width="80px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="ECommGMDollar" HeaderText="eCom GM$" DataFormatString="{0:c}" SortExpression="ECommGMDollar">
                                            <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="70px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="ECommGMPct" HeaderText="eCom GM %" DataFormatString="{0:#,##0.0}" SortExpression="ECommGMPct">
                                            <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="70px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="State" HeaderText="State Code" DataFormatString="{0:c}" SortExpression="State">
                                            <ItemStyle HorizontalAlign="Center" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="SalesTerritory" HeaderText="Terrritory Code" DataFormatString="{0:c}" SortExpression="SalesTerritory">
                                            <ItemStyle HorizontalAlign="Left" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="InsideRep" HeaderText="Inside Rep" DataFormatString="{0:c}" SortExpression="InsideRep">
                                            <ItemStyle HorizontalAlign="Left" Width="90px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="90px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="OutsideRep" HeaderText="Outside Rep" DataFormatString="{0:c}" SortExpression="OutsideRep">
                                            <ItemStyle HorizontalAlign="Left" Width="90px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="90px" />
                                        </asp:BoundField>
                                        
                                        <asp:BoundField HtmlEncode="false" DataField="WebUserCnt" HeaderText="# Web" DataFormatString="{0:#,##0}" SortExpression="WebUserCnt">
                                            <ItemStyle HorizontalAlign="Right" Width="20px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center"  Width="20px"/>
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="InxsUserCnt" HeaderText="# IxS" DataFormatString="{0:#,##0}" SortExpression="InxsUserCnt">
                                            <ItemStyle HorizontalAlign="Right" Width="20px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="20px"/>
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="DCUserCnt" HeaderText="# DC" DataFormatString="{0:#,##0}" SortExpression="DCUserCnt">
                                            <ItemStyle HorizontalAlign="Right" Width="20px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="20px"/>
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="SDKUserCnt" HeaderText="# SDK" DataFormatString="{0:#,##0}" SortExpression="SDKUserCnt">
                                            <ItemStyle HorizontalAlign="Right" Width="20px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="20px"/>
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="XrefCnt" HeaderText="# Xref" DataFormatString="{0:#,##0}" SortExpression="XrefCnt">
                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="30px"/>
                                        </asp:BoundField>
                                    </Columns>
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
                                <asp:UpdatePanel ID="pnlPrint" runat="server" UpdateMode="conditional">
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
                        <uc2:BottomFooter ID="ucFooter" Title="Sales Performance by Filter Report" runat="server" />
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
