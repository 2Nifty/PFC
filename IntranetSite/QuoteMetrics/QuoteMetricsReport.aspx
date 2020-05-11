<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="QuoteMetricsReport.aspx.cs"
    EnableEventValidation="false" ValidateRequest="false" Inherits="QuoteMetricsReport" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Quote Metrics Report </title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function PrintReport()
    {  
        var WinPrint = window.open('print.aspx','Print','height=10,width=10,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");       
    }   
    
    function BindValue(sortExpression)
    {     
        if(document.getElementById("hidSortExpression") !=null)
            document.getElementById("hidSortExpression").value= sortExpression;
        document.getElementById("btnSort").click();
    }
    // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {
        QuoteMetricsReport.DeleteExcel('QuoteMetricsReport'+session).value
        parent.window.close();           
    }
    </script>

</head>
<body scroll="no" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="360000"
            EnablePartialRendering="true">
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
                                            Quote Metrics
                                        </td>
                                        <td align="right" style="width: 30%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/InvoiceRegister/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="conditional" runat="server">
                                                            <ContentTemplate>
                                                                <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnPrint" ImageUrl="~/InvoiceRegister/Common/Images/Print.gif"
                                                                    ImageAlign="middle" OnClick="ibtnPrint_Click" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td>
                                                        <img align="right" src="Common/Images/Close.gif" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            style="cursor: hand; padding-right: 2px;" />
                                                    </td>
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
                            <table cellspacing="0" cellpadding="0" height="40" width="100%">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td valign="top" style="width: 220px">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left" colspan="3">
                                                                <asp:Label ID="Label1" runat="server" Text="Beginning Date: " Width="88px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblStartDt" runat="server" Width="80px" Height="20px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3">
                                                                <asp:Label ID="Label4" runat="server" Text="Branch:" Height="20px" Width="45px"></asp:Label><asp:Label
                                                                    ID="lblBranch" runat="server" Width="120px" Height="20px"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 10px; width: 220px;" valign="bottom">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td colspan="3" style="height: 14px">
                                                                <asp:Label ID="Label3" runat="server" Text="Ending Date:" Width="75px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblEndDt" runat="server" Width="60px" Height="20px"></asp:Label></td>                                                            
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3" valign="middle" style="padding-right: 5px">
                                                                <asp:Label ID="Label7" runat="server" Text="Sales Person:" Width="80px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblSalesPerson" runat="server" Height="20px"></asp:Label></td>                                                            
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td valign=bottom style="padding-bottom:6px;">
                                                    <asp:CheckBox ID="chkOnlySubTotal" runat="server" Text="Show Only Sub-Totals" Width="140px" AutoPostBack="True" OnCheckedChanged="chkOnlySubTotal_CheckedChanged" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" style="padding-right: 10px;" valign="bottom">
                                        <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter="10" DynamicLayout="false">
                                            <ProgressTemplate>
                                                <span style="padding-left: 5px; font-weight: bold; padding-top: 0px; color: Red;">Loading...</span>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 510px; width: 1018px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" Width="1018px"
                                    ID="gvQuoteMetrics" runat="server" ShowHeader="true" ShowFooter="true" AllowSorting="True"
                                    AutoGenerateColumns="false" OnRowDataBound="gvQuoteMetrics_RowDataBound" OnSorting="gvQuoteMetrics_Sorting"
                                    AllowPaging="true">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <RowStyle CssClass="GridItem " BackColor="White" BorderColor="White" Height="19px"
                                        HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass="GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <EmptyDataRowStyle VerticalAlign="Top" BorderWidth="0px" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:BoundField HeaderText="ItemNo" DataField="PFCItemNo" SortExpression="PFCItemNo">
                                            <ItemStyle HorizontalAlign="Left" CssClass="Left5pxPadd" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" HeaderText="Sales Loc" DataField="SalesLocationCode"
                                            SortExpression="SalesLocationCode" DataFormatString="{0:00}">
                                            <ItemStyle HorizontalAlign="Center" Width="35px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="35px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="CustomerName" HeaderText="Customer Name"
                                            SortExpression="CustomerName">
                                            <ItemStyle HorizontalAlign="Left" Width="155px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="160px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="RequestQuantity" HeaderText="ReqQty"
                                            SortExpression="RequestQuantity" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="35px" Wrap="False" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="35px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="AvailableQuantity" HeaderText="AvailQty"
                                            SortExpression="AvailableQuantity" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="35px" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" Width="35px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="QuotationDate" HeaderText="Quote Date"
                                            SortExpression="QuotationDate" DataFormatString="{0:MM/dd/yy}">
                                            <ItemStyle HorizontalAlign="Right" Width="35px" Wrap="true" />
                                            <HeaderStyle Wrap="true" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="InitialRequestQty" HeaderText="InitialReqQty"
                                            SortExpression="InitialRequestQty" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="InitialAvailableQty" HeaderText="InitialAvailableQty"
                                            SortExpression="InitialAvailableQty" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="30px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="InitialLocationCode" HeaderText="Loc"
                                            SortExpression="InitialLocationCode">
                                            <ItemStyle HorizontalAlign="Center" Wrap="False" Width="35px" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Name" HeaderText="Name" SortExpression="Name">
                                            <ItemStyle HorizontalAlign="Left" Width="75px" Wrap="True" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="OELoc" HeaderText="OELoc" SortExpression="OELoc">
                                            <ItemStyle HorizontalAlign="Center" Width="40px" Wrap="True" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Quote" HeaderText="Quote $" DataFormatString="{0:#,##0.00}"
                                            SortExpression="Quote">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="True" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="MadeOrd" HeaderText="Ordered $" DataFormatString="{0:#,##0.00}"
                                            SortExpression="MadeOrd">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="LineCnt" HeaderText="LineCnt" DataFormatString="{0:#,##}"
                                            SortExpression="LineCnt">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="AvlShort" HeaderText="AvlShort" DataFormatString="{0:#,##0}"
                                            SortExpression="SellPerLb">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="MadeOrder" HeaderText="Made Order"
                                            SortExpression="MadeOrder">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
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
                                <uc3:pager ID="pager" runat="server" OnBubbleClick="Pager_PageChanged" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">                    
                        <uc2:BottomFooter ID="ucFooter" Title="Quote Metrics" runat="server" />
                        <asp:HiddenField ID="hidShowMode" runat="server" />
                        <asp:HiddenField ID="hidFileName" Value="" runat="server" />                  
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
