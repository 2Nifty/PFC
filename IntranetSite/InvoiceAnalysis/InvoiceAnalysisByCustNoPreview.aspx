<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvoiceAnalysisByCustNoPreview.aspx.cs" Inherits="PFC.Intranet.DailySalesReports.InvoiceAnalysisPreview" %>

<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="Footer" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Sales Performance by Filter Report</title>
    <link href="../DailySalesReport/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../DailySalesReport/Common/StyleSheet/Styles.css" rel="stylesheet" media="print" type="text/css" />
</head>
<body onload="javascript:print_header()">
    <form id="form1" runat="server">
        <div id="pagePrint">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="100%" height="100%" valign="top" colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="PageHead" colspan="5" style="height: 40px">
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td class="Left5pxPadd BannerText" width="90%">
                                                <asp:Label Text="Sales Performance by Filter Report" Style="word-wrap: normal" ID="lblReportCap"
                                                    runat="server" Width="350px"></asp:Label>
                                            </td>
                                            <td valign="middle" align="right">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="trHead" class="PageBg">
                                <td class="LeftPadding TabHead" style="height: 10px" colspan="2">
                                    <table cellspacing="0" cellpadding="0" height="40px" width="100%">
                                        <tr>
                                            <td width="175px">
                                                <asp:Label ID="lblBeginDate" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                            <td width="175px">
                                                <asp:Label ID="lblEndDate" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                            <td width="175px">
                                                <asp:Label ID="lblOrderType" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                            <td width="175px">
                                                <asp:Label ID="lblBranch" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                            <td width="175px">
                                                <asp:Label ID="lblChain" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                            <td width="*">&nbsp;</td>
                                            <td align="right" rowspan="2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblCustomerNumber" Style="font-family: Arial, Helvetica, sans-serif;
                                                    font-size: 11px; font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                            <td>
                                                <asp:Label ID="lblTerritory" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server"></asp:Label></td>
                                            <td>
                                                <asp:Label ID="lblCSR" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server"></asp:Label></td>
                                            <%--<td>
                                                <asp:Label ID="lblState" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server" Text=""></asp:Label></td>--%>
                                            <td>
                                                <asp:Label ID="lblSalesPerson" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                            <td>
                                                <asp:Label ID="lblRegionalMgr" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblShipment" Style="font-family: Arial, Helvetica, sans-serif;
                                                    font-size: 11px; font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                            <td>
                                                <asp:Label ID="lblPriceCd" Style="font-family: Arial, Helvetica, sans-serif; font-size: 11px;
                                                    font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                            <td colspan="2">
                                                <asp:Label ID="lblOrderSource" Style="font-family: Arial, Helvetica, sans-serif;
                                                    font-size: 11px; font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                            <td>
                                                <asp:Label ID="lblBuyGroup" Style="font-family: Arial, Helvetica, sans-serif;
                                                    font-size: 11px; font-weight: bold;" runat="server" Text=""></asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" align="left">
                        <asp:GridView UseAccessibleHeader="false" PagerSettings-Visible="false" PageSize="19"
                            Width="1220px" ID="dvInvoiceAnalysis" runat="server" AllowPaging="false" ShowHeader="true"
                            ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false" OnRowDataBound="dvInvoiceAnalysis_RowDataBound">
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
                        <center>
                            <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                Visible="False"></asp:Label></center>
                        <input type="hidden" runat="server" id="hidSort" /></td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>

<script type='text/javascript'>
function PrintReport()
{
     var prtContent = "<html><head><link href='common/StyleSheet/styles.css' rel='stylesheet' type='text/css' />" + "</head>" + "<body>";
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:350px;'colspan=3><h3>Invoice Analysis Report</h3></td></tr>";
     prtContent = prtContent +"</table><br>"; 
     prtContent = prtContent + document.getElementById('trHead').innerHTML + "<br>";  
     prtContent = prtContent + document.getElementById('PrintDG2').innerHTML;     
     prtContent = prtContent + "</body></html>";
     var WinPrint = window.open('','','letf=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');
     prtContent = prtContent.replace(/BORDER-COLLAPSE: collapse;/i,"border-collapse:separate;");
     prtContent = prtContent.replace(/BORDER-LEFT: #c9c6c6 1px solid;/i,"BORDER-LEFT: #c9c6c6 0px solid;");
     prtContent = prtContent.replace(/BORDER-RIGHT: #c9c6c6 1px solid;/i,"BORDER-RIGHT: #c9c6c6 0px solid;");
     prtContent = prtContent.replace(/BORDER-TOP: #c9c6c6 1px solid;/i,"BORDER-TOP: #c9c6c6 0px solid;");
     prtContent = prtContent.replace(/BORDER-BOTTOM: #c9c6c6 1px solid;/i,"BORDER-BOTTOM: #c9c6c6 0px solid;");
     WinPrint.document.write(prtContent);
     WinPrint.document.close();
     WinPrint.focus();
     WinPrint.print();
     WinPrint.close();
     window.close();
}

function print_header() 
{ 
    var table = document.getElementById("dvInvoiceAnalysis"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/g, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
}
</script>

