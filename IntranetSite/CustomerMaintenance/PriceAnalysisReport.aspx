<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PriceAnalysisReport.aspx.cs" Inherits="PFC.Intranet.DailySalesReports.PriceAnalysisReport" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Price Analysis Report</title>
    <link href="../DailySalesReport/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />    

    <script>
        function PrintReport()
        {  
            var WinPrint = window.open('print.aspx','Print','height=10,width=10,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");       
        }   

        //Javascript Function To Call Server Side Function Using Ajax
        function DeleteFiles(session)
        {
            PriceAnalysisReport.DeleteExcel('PriceAnalysisReport'+session).value
            window.close();
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
                document.getElementById('div-datagrid').style.width='990px';
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
                                            Price Analysis Report
                                        </td>
                                        <td align="right" style="width: 30%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="conditional" runat="server">
                                                            <ContentTemplate>
                                                                <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnPrint" ImageUrl="~/Common/Images/Print.gif"
                                                                    ImageAlign="middle" OnClick="ibtnPrint_Click" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
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
                            <table cellspacing="2" cellpadding="2" height="40px" width="100%">
                                <tr>
                                    <td width="175px">
                                        <asp:Label ID="lblBeginDate" runat="server" Text=""></asp:Label></td>
                                    <td width="175px">
                                        <asp:Label ID="lblEndDate" runat="server" Text=""></asp:Label></td>
                                    <td width="175px">
                                        <asp:Label ID="lblBranch" runat="server" Text=""></asp:Label></td>
                                    <td width="175px">
                                        <asp:Label ID="lblCustomerNumber" runat="server" Text="" Width=280px></asp:Label></td>
                                    <td width="*">&nbsp;</td>
                                    <td align="right" rowspan="2">
                                        <img src="../InvoiceAnalysis/Common/Images/btn_showcal.gif" id="imgShow" onclick="ShowPanel();" />
                                        <img src="../InvoiceAnalysis/Common/Images/btn_hidecal.gif" style="display: none;" id="imgHide" onclick="javascript: document.getElementById('leftPanel').style.display='none';document.getElementById('imgShow').style.display='';this.style.display='none';document.getElementById('div-datagrid').style.width='1020px';hidShowMode.value='Hide';" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblHistExtSell" runat="server"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblHistExtGM" runat="server"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblHistGMPct" runat="server"></asp:Label></td>
                                    <td>
                                        <table border=0 cellpadding=0 cellspacing=0>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblSuggGMPct" runat="server" Width=140px></asp:Label> 
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblSAvgSuggGMPct" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                        </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblHistExtLbs" runat="server" Text=""></asp:Label></td>
                                    <td colspan="1">
                                        <asp:Label ID="lblHistSellPerLb" runat="server" Text=""></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblHistGMPerLb" runat="server" Text=""></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblCategory" runat="server" Text=""></asp:Label>
                                    </td>
                                </tr>
                            </table>
                            <asp:HiddenField ID="hidShowAvgCost" runat="server" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <asp:UpdatePanel ID="upnlCalendar" UpdateMode="conditional" RenderMode="inline" runat="server">
                        <ContentTemplate>
                            <table cellspacing="0" cellpadding="0" id="leftPanel" style="display: none;" height="505px">
                                <tr>
                                    <td valign="top" style="background-color: #F4FBFD; border-right-width: 1px; border-right-style: solid;
                                        border-right-color: #8CD5EA;" height="505px">
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
                                                <td>
                                                    &nbsp;</td>
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
                                                <td>
                                                    &nbsp;</td>
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
                                top: 0px; left: 0px; height: 475px; width: 1020px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" PageSize="20"
                                    Width="1020px" ID="dvInvoiceAnalysis" runat="server" AllowPaging="true" ShowHeader="true"
                                    ShowFooter="false" AllowSorting="true" AutoGenerateColumns="false" 
                                    OnSorting="dvInvoiceAnalysis_Sorting">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White"
                                        Height="19px" HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass="Left5pxPadd GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:TemplateField  SortExpression="ItemNo" HeaderText="Item No">
                                            <ItemTemplate>
                                                <asp:Label ID="lblItemNo" runat=server Text='<%#DataBinder.Eval(Container.DataItem,"ItemNo") %>'
                                                ToolTip='<%#DataBinder.Eval(Container.DataItem,"ItemDesc") %>'></asp:Label>
                                            </ItemTemplate>
                                           <ItemStyle HorizontalAlign="Center" Width="85px" />    
                                           <HeaderStyle HorizontalAlign="Center" Width="85px" />                                 
                                        </asp:TemplateField>                                        
                                        <asp:BoundField HtmlEncode="false" HeaderText="Sugg Price Alt" DataField="SuggestedPriceAlt" 
                                            SortExpression="SuggestedPriceAlt" DataFormatString="{0:#,##0.00}">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="SellUM" HeaderText="Hist Sell Price Alt" SortExpression="SellUM">
                                            <ItemStyle CssClass="Left2pxPadd" HorizontalAlign="Right" Width="55px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="55px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="SuggestedPriceMethod" HeaderText="Sugg Price Method" 
                                            SortExpression="SuggestedPriceMethod">
                                            <ItemStyle HorizontalAlign="Left" Width="200px" Wrap="False" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="200px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="AVGSuggGMPct" HeaderText="Avg Sugg GM Pct" 
                                            SortExpression="AVGSuggGMPct" DataFormatString="{0:0.0%}">
                                            <ItemStyle HorizontalAlign="Right" Width="55px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" Width="55px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="SMTHAVGSuggGMPct" HeaderText="SAvg Sugg GM Pct" 
                                            SortExpression="SMTHAVGSuggGMPct" DataFormatString="{0:0.0%}">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="GMPct" HeaderText="Hist GM Pct" 
                                            SortExpression="GMPct" DataFormatString="{0:0.0%}">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="QtyShipped" HeaderText="Qty Shipped" 
                                            SortExpression="QtyShipped" DataFormatString="{0:#,##}">
                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="40px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="ExtLines" HeaderText="Ext. Lines" 
                                            SortExpression="ExtLines">
                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="40px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="ExtSell" HeaderText="Ext. Sell" 
                                            SortExpression="ExtSell"  DataFormatString="{0:#,##0.00}">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="ExtGM" HeaderText="Ext. GM" 
                                            SortExpression="ExtGM" DataFormatString="{0:#,##0.00}">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>                                        
                                        <asp:BoundField HtmlEncode="false" DataField="ExtLbs" HeaderText="Ext. Lbs" 
                                            SortExpression="ExtLbs" DataFormatString="{0:#,##0.00}">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="SellPerLb" HeaderText="Sell Per Lb" 
                                            SortExpression="SellPerLb" DataFormatString="{0:#,##0.000}" >
                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="40px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="GMPerLb" HeaderText="GM Per Lb" 
                                            DataFormatString="{0:#,##0.000}" SortExpression="GMPerLb">
                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="40px" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <div align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>
                                <input type="hidden" runat="server" id="hidSortExpression" />                                
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
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <table width="100%">
                        <uc2:BottomFooter ID="ucFooter" Title="Price Analysis Report" runat="server" />
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
