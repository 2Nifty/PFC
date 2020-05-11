<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderAnalysisDtlRptPreview.aspx.cs" Inherits="OrderAnalysisDtlRptPreview" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Order Analysis Detail Report</title>
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
                                                <asp:Label Text="Order Analysis Detail Report" style="word-wrap:normal" ID="lblReportCap" runat="server" />                                                
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
                                <asp:DataGrid ID="dgOrderAnalysis" BackColor="#f4fbfd" runat="server" Width="1230px"
                                    AutoGenerateColumns="false" ShowFooter="true" PagerStyle-Visible="false" BorderWidth="1"
                                    GridLines="both" BorderColor="#c9c6c6" OnItemDataBound="dgOrderAnalysis_ItemDataBound">
                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Left" />
                                <AlternatingItemStyle CssClass="GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF" HorizontalAlign="Left" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"  HorizontalAlign="Left" />
                                <Columns>                                    
                                    <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Order Method" ItemStyle-Width="100" FooterStyle-HorizontalAlign="Center"
                                        DataField="QuoteMethod" SortExpression="QuoteMethod" />                                  
                                    <asp:BoundColumn HeaderStyle-Width="70" HeaderText="PO Number" ItemStyle-Width="70" DataField="PurchaseOrderNo" SortExpression="PurchaseOrderNo" />    
                                    <asp:BoundColumn HeaderStyle-Width="70" HeaderText="PO Date" ItemStyle-Width="70" ItemStyle-HorizontalAlign="center"
                                        DataField="PurchaseOrderDate" DataFormatString="{0:MM/dd/yyyy}" SortExpression="PurchaseOrderDate" />
                                    <asp:BoundColumn HeaderStyle-Width="150" HeaderText="User Item #" ItemStyle-Width="150" FooterStyle-HorizontalAlign="right"
                                        DataField="UserItemNo" DataFormatString="{0:#,##0.00}" SortExpression="UserItemNo" />
                                    <asp:BoundColumn HeaderStyle-Width="120" HeaderText="PFC Item #" ItemStyle-Width="120"
                                        DataField="PFCItemNo" DataFormatString="{0:#,##0.00}" SortExpression="PFCItemNo" />
                                    <asp:BoundColumn HeaderStyle-Width="300" HeaderText="Description" ItemStyle-Width="300"
                                        DataField="Description" DataFormatString="{0:#,##0.00}" SortExpression="Description" />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Sls Brn" ItemStyle-Width="40"
                                        DataField="SalesBranchofRecord" DataFormatString="{0:#,##0.00}" SortExpression="SalesBranchofRecord" ItemStyle-HorizontalAlign="center" />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Req Qty" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="RequestQuantity" DataFormatString="{0:#,##0}" SortExpression="RequestQuantity" />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Avl Qty" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="RunningAvailQty" DataFormatString="{0:#,##0}" SortExpression="RunningAvailQty" />                                                                          
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Unit Price" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="UnitPrice" DataFormatString="{0:c}" SortExpression="UnitPrice" />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Mgn %" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="MarginPercentage" DataFormatString="{0:#,##0.0}" SortExpression="MarginPercentage" />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Avg Cost" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="AvgCost" DataFormatString="{0:c}" SortExpression="AvgCost"  />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Price UOM" ItemStyle-Width="40"
                                        DataField="PriceUOM" DataFormatString="{0:#,##0.00}" SortExpression="PriceUOM" />
                                    <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Total Price" ItemStyle-Width="70" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="TotalPrice" DataFormatString="{0:c}" SortExpression="TotalPrice" />                                        
                                    <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Total Weight" ItemStyle-Width="70" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="GrossWeight" DataFormatString="{0:#,##0.00}" SortExpression="GrossWeight" />
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
    prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:350px;'colspan=3><h3>Order Analysis Report</h3></td></tr>";
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

