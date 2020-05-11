<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QuoteAnalysisDtlRptPreview.aspx.cs" Inherits="QuoteAnalysisDtlRptPreview" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Quote Analysis Detail Report</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .list
        {
	        line-height:23px;
	        background:#FFFFCC;
	        padding:0px 10px;
	        border:1px solid #FAEE9A;
	        position:relative;
	        z-index:1;
	        top:0px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="pagePrint">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="100%" height="100%" valign="top" colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="PageHead" colspan="5" style="height: 40px">
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 1010px">
                                        <tr>
                                            <td class="Left5pxPadd BannerText" width="90%">
                                                <asp:Label Text="Quote Analysis Detail Report" style="word-wrap:normal" ID="lblReportCap" runat="server" />                                                
                                            </td>
                                            <td valign="middle"  align="right">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td align="right" width="70%" style="padding:5px;">
                                                            <img onclick="javascript:PrintReport('trHead','PrintDG2');" src="../Common/Images/Print.gif"
                                                                style="cursor: hand" id="btnPrint" /></td>
                                                        <td align="left" width="30%">
                                                            <img src="../Common/images/close.gif" style="cursor: hand" onclick="javascript:window.close();" /></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="trHead" class="PageBg" style="height:20px;">
                                <td>
                                    <table cellpadding="1" cellspacing="0" width="1010px">
                                        <tr class="PageBg">
                                            <td class="LeftPadding TabHead" style="width: 175px">
                                                <asp:Label ID="lblSourceType" runat="server" Text=""></asp:Label>
                                            </td>
                                            <td class="TabHead" style="width: 125px">
                                                Quote # :
                                                <%=Request.QueryString["QuoteNumber"].ToString()%>
                                            </td>
                                            <td class="TabHead" style="width: 150px">
                                                Customer # :
                                                <%=Request.QueryString["CustomerNumber"].ToString() %>
                                            </td>
                                            <td class="TabHead" style="width: 310px">
                                                Customer Name :
                                                <%=Request.QueryString["CustomerName"].ToString() %>
                                            </td>
                                            <td class="TabHead" style="width: 125px">
                                                Run By :
                                                <%= Session["UserName"].ToString() %>
                                            </td>
                                            <td class="TabHead" style="width: 125px">
                                                Run Date :
                                                <%=DateTime.Now.ToShortDateString()%>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto;
                            position: relative; top: 0px; left: 0px; width: 1010px; height: 610px; border: 0px solid;">
                            <div id="PrintDG2">
                                <asp:DataGrid ID="dgQuoteAnalysis" BackColor="#f4fbfd" runat="server" Width="1230px"
                                    AutoGenerateColumns="false" ShowFooter="true" PagerStyle-Visible="false" BorderWidth="1"
                                    GridLines="both" BorderColor="#c9c6c6" OnItemDataBound="dgQuoteAnalysis_ItemDataBound">
                                <HeaderStyle HorizontalAlign="center" Height="25px" CssClass="GridHead" BackColor="#DFF3F9" />
                                <ItemStyle CssClass="GridItem" BackColor="#F4FBFD" Wrap="false" />
                                <AlternatingItemStyle CssClass="GridItem" BackColor="White" Wrap="false" />
                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" Height="20px" BackColor="#DFF3F9" />
                                    <Columns>                                    
                                    <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" HeaderText="Quote Method" FooterStyle-HorizontalAlign="center"
                                        DataField="QuoteMethod" SortExpression="QuoteMethod" ItemStyle-Width="100" />
                                        
                                    <asp:BoundColumn HeaderStyle-Width="70" ItemStyle-HorizontalAlign="center" HeaderText="Quotation Date"
                                        DataField="QuotationDate" DataFormatString="{0:MM/dd/yyyy}" SortExpression="QuotationDate" ItemStyle-Width="70" />
                                        
                                    <asp:BoundColumn HeaderStyle-Width="70" ItemStyle-HorizontalAlign="center" HeaderText="Expiry Date"
                                        DataField="ExpiryDate" DataFormatString="{0:MM/dd/yyyy}" SortExpression="ExpiryDate" ItemStyle-Width="70" />
                                        
                                    <asp:BoundColumn ItemStyle-HorizontalAlign="left" HeaderText="User Item #" DataField="UserItemNo" SortExpression="UserItemNo"
                                        DataFormatString="{0:#,##0.00}" FooterStyle-HorizontalAlign="right" ItemStyle-Width="100" />
                                        
                                    <asp:BoundColumn HeaderStyle-Width="120" ItemStyle-HorizontalAlign="left" HeaderText="PFC Item #"
                                        DataField="PFCItemNo" DataFormatString="{0:#,##0.00}" SortExpression="PFCItemNo" ItemStyle-Width="120" />

                                    <asp:BoundColumn HeaderStyle-Width="280" ItemStyle-HorizontalAlign="Left" HeaderText="Description"
                                        DataField="Description" DataFormatString="{0:#,##0.00}" SortExpression="Description" ItemStyle-Width="280" />

                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="Center" HeaderText="Sls Brn"
                                        DataField="SalesBranchofRecord" DataFormatString="{0:#,##0}" SortExpression="SalesBranchofRecord" ItemStyle-Width="40" />

                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="right" HeaderText="Req Qty"
                                        DataField="RequestQuantity" DataFormatString="{0:#,##0}" SortExpression="RequestQuantity" ItemStyle-Width="40" />

                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="right" HeaderText="Avl Qty"
                                        DataField="RunningAvailQty" DataFormatString="{0:#,##0}" SortExpression="RunningAvailQty" ItemStyle-Width="40" />
                                                                            
                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="right" HeaderText="Unit Price"
                                        DataField="UnitPrice" DataFormatString="{0:c}" SortExpression="UnitPrice" ItemStyle-Width="40" />
                                        
                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="right" HeaderText="Mgn %"
                                        DataField="MarginPercentage" DataFormatString="{0:#,##0.0}" SortExpression="Margin" ItemStyle-Width="40" />
                                        
                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="right" HeaderText="Avg Cost"
                                        DataField="AvgCost" DataFormatString="{0:c}" SortExpression="AvgCost" ItemStyle-Width="40" />                                        
                                        
                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="Left" HeaderText="Price UOM"
                                        DataField="PriceUOM" DataFormatString="{0:#,##0}" SortExpression="PriceUOM" ItemStyle-Width="40" />
                                        
                                     <asp:BoundColumn HeaderStyle-Width="70" ItemStyle-HorizontalAlign="right" HeaderText="Total Price"
                                        DataField="TotalPrice" DataFormatString="{0:c}" SortExpression="TotalPrice" ItemStyle-Width="70"  />
                                        
                                    <asp:BoundColumn HeaderStyle-Width="70" ItemStyle-HorizontalAlign="right" HeaderText="Total Weight"
                                        DataField="GrossWeight" DataFormatString="{0:#,##0.00}" SortExpression="GrossWeight" ItemStyle-Width="70" />
                                    </Columns>
                                </asp:DataGrid>
                                <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found" Visible="False" /></center>
                            </div>
                        </div>
                    </td>
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
function PrintReport(strid1,strid2)
{
    var prtContent = "<html><head><link href='common/StyleSheet/stylesheet.css' rel='stylesheet' type='text/css' /></head><body>";
    prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:350px;'colspan=3><h3>Quote Analysis Report</h3></td></tr>";
    prtContent = prtContent +"</table><br>"; 
    prtContent = prtContent + document.getElementById(strid1).innerHTML ; 
    prtContent = prtContent + document.getElementById(strid2).innerHTML;      
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
}
</script>

