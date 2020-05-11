<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvoiceAnalysisPreview.aspx.cs" Inherits="PFC.Intranet.DailySalesReports.InvoiceAnalysisPreview" %>

<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="Footer" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Invoice Analysis Report Preview</title>
    <link href="../DailySalesReport/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
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
                                                <asp:Label Text="Invoice Analysis Report" Style="word-wrap: normal" ID="lblReportCap"
                                                    runat="server" Width="350px"></asp:Label>
                                            </td>
                                            <td valign="middle" align="right">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td align="right" width="70%" style="padding: 5px;">
                                                            <img onclick="javascript:PrintReport();" src="../Common/Images/Print.gif" style="cursor: hand"
                                                                id="IMG1" /></td>
                                                        <td align="left" width="30%">
                                                            <img src="../Common/Images/Close.gif" style="cursor: hand" onclick="javascript:window.close();" /></td>
                                                    </tr>
                                                </table>
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
                                                <asp:Label ID="lblBeginDate" runat="server" Text=""></asp:Label></td>
                                            <td width="175px">
                                                <asp:Label ID="lblEndDate" runat="server" Text=""></asp:Label></td>
                                            <td width="175px">
                                                <asp:Label ID="lblOrderType" runat="server" Text=""></asp:Label></td>
                                            <td width="175px">
                                                <asp:Label ID="lblBranch" runat="server" Text=""></asp:Label></td>
                                            <td width="175px">
                                                <asp:Label ID="lblChain" runat="server" Text=""></asp:Label></td>
                                            <td style="width: 130px">
                                                Run By: <%= Session["UserName"]%></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblCustomerNumber" runat="server" Text=""></asp:Label></td>
                                            <td>
                                                <asp:Label ID="lblWeight" runat="server" Text=""></asp:Label></td>
                                            <td>
                                                <asp:Label ID="lblState" runat="server" Text=""></asp:Label></td>
                                            <td>
                                                <asp:Label ID="lblShipment" runat="server" Text=""></asp:Label></td>
                                            <td>
                                                <asp:Label ID="lblSalesPerson" runat="server" Text=""></asp:Label></td>
                                            <td style="width: 130px">
                                                Run Date: <%=DateTime.Now.ToShortDateString()%></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblPriceCd" runat="server" Text=""></asp:Label></td>
                                            <td colspan="2">
                                                <asp:Label ID="lblOrderSource" runat="server" Text=""></asp:Label></td>
                                            <td colspan="2">
                                                <asp:Label ID="lblSubTot" runat="server" Text=""></asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" align="left">
                        <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                            top: 0px; left: 0px; width: 1010px; height: 580px; border: 0px solid;">
                            <div id="PrintDG2">
                                <asp:GridView PagerSettings-Visible="false" PageSize="19" Width="1590px" ID="dvInvoiceAnalysis"
                                    runat="server" AllowPaging="false" ShowHeader="true" ShowFooter="true" AllowSorting="true"
                                    AutoGenerateColumns="false" OnRowDataBound="dvInvoiceAnalysis_RowDataBound">
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
                                        <asp:BoundField HtmlEncode="false" HeaderText="Date" DataField="ARDate" SortExpression="ARDate">
                                            <ItemStyle HorizontalAlign="Center" Width="55px" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle HorizontalAlign="Center" Width="55px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" HeaderText="Branch" DataField="Branch" SortExpression="Branch">
                                            <ItemStyle HorizontalAlign="Center" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="OrderType" HeaderText="Order Type" SortExpression="OrderType">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="ShipToCity" HeaderText="Ship To City" SortExpression="ShipToCity">
                                            <ItemStyle HorizontalAlign="Left" Width="70px" Wrap="False" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="70px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="ShipToState" HeaderText="Ship To State" SortExpression="ShipToState">
                                            <ItemStyle HorizontalAlign="Center" Width="45px" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" Width="45px" />
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
                                            <ItemStyle HorizontalAlign="Center" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="PriceCd" HeaderText="Price Code" SortExpression="PriceCd">
                                            <ItemStyle HorizontalAlign="Center" Width="35px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="35px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="DocNo" HeaderText="DocNo" SortExpression="DocNo">
                                            <ItemStyle HorizontalAlign="Center" Width="70px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="70px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="CustPO" HeaderText="Cust PO" SortExpression="CustPO">
                                            <ItemStyle HorizontalAlign="Left" Width="70px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="70px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="NetSales" HeaderText="Net Sales" DataFormatString="{0:c}" SortExpression="NetSales">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="NetExp" HeaderText="Net Exp" DataFormatString="{0:c}" SortExpression="NetExp">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="TotAR" HeaderText="Tot A/R" DataFormatString="{0:c}" SortExpression="TotAR">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="GMDollar" HeaderText="GM$" DataFormatString="{0:c}" SortExpression="GMDollar">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="GMPct" HeaderText="GM %" DataFormatString="{0:#,##0.0}" SortExpression="GMPct">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="TotWgt" HeaderText="Total Weight" DataFormatString="{0:#,##0.0}" SortExpression="TotWgt">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="ShipMethod" HeaderText="Ship Method" SortExpression="ShipMethod">
                                            <ItemStyle HorizontalAlign="Left" Width="100px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="100px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="InsideSalesPerson" HeaderText="Inside Sales Person" SortExpression="InsideSalesPerson">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="SalesPerson" HeaderText="Sales Person" SortExpression="SalesPerson">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="ShipToName" HeaderText="Ship To Name" SortExpression="ShipToName">
                                            <ItemStyle HorizontalAlign="Left" Width="180px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="180px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="OrderSource" HeaderText="Order Source" SortExpression="OrderSource">
                                            <ItemStyle HorizontalAlign="Center" Width="45px" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="45px" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <center>
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></center>
                            </div>
                        </div>
                        <input type="hidden" runat="server" id="hidSort" /></td>
                </tr>
                <tr>
                    <td>
                        <uc1:Footer ID="Footer1" runat="server" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>

<script>
 function PrintReport()
{
     var prtContent = "<html><head><link href='common/StyleSheet/styles.css' rel='stylesheet' type='text/css' /></head><body>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:350px;'colspan=3><h3>Invoice Analysis Report</h3></td></tr>";
     prtContent = prtContent +"</table><br>"; 
     prtContent = prtContent + document.getElementById('trHead').innerHTML;  
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

