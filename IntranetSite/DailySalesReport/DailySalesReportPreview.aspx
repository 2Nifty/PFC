<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DailySalesReportPreview.aspx.cs" Inherits="PFC.Intranet.DailySalesReports.DailySalesReportPreview" %>

<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="Footer" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Daily Sales Analysis Report Preview</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
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
                                            <td class="Left5pxPadd BannerText"  width=90%>
                                            <asp:Label Text="Daily Sales Report" style="word-wrap:normal" ID="lblReportCap" runat=server Width="350px"></asp:Label>                                                
                                            </td>
                                            <td valign="middle"  align="right">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td align="right" width="70%" style="padding:5px;">
                                                            <img onclick="javascript:PrintReport();" src="../Common/Images/Print.gif"
                                                                style="cursor: hand" id="IMG1" /></td>
                                                        <td align="left" width="30%">
                                                            <img src="../Common/Images/Close.gif" style="cursor: hand" onclick="javascript:window.close();" /></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                                  <tr id="trHead" class="PageBg" >
                                <td class="LeftPadding TabHead" style="width:110px">
                                   Branch :
                                    <%=Request.QueryString["BranchName"].ToString()%>
                                </td>
                                 <td class="LeftPadding TabHead" style="width:300px">
                                 Period :
                                    <%=Request.QueryString["StartDate"].ToString() + " to " + Request.QueryString["EndDate"].ToString()%>
                                 </td>
                                 <td class="TabHead" width="400px">
                                    &nbsp;
                                </td>
                                <td class="TabHead" style="width:130px">
                                    Run By : <%= Session["UserName"]%>
                                </td>
                                <td class="TabHead" style="width:130px">
                                    Run Date : <%=DateTime.Now.ToShortDateString()%>
                                </td>
                        </tr>
                        </table>
                    </td>
                </tr>
                 
                <tr>
                    <td valign="top" align="left">
                        <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto;
                            position: relative; top: 0px; left: 0px; width: 1010px; height: 610px; border: 0px solid;">
                            <div id="PrintDG2">
                            <asp:GridView PagerSettings-Visible="false"  Width="1200px" ID="dvDailySales"
                            runat="server" AllowPaging="false" ShowHeader="true" ShowFooter="true"  AllowSorting="false" AutoGenerateColumns="false"
                            OnRowDataBound="dvDailySales_RowDataBound">
                            <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                HorizontalAlign="Center" />
                            <RowStyle CssClass=" GridItem Left5pxPadd" BackColor="White" BorderColor="White" Height="20px"
                                HorizontalAlign="Left" />
                            <AlternatingRowStyle CssClass=" GridItem Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                HorizontalAlign="Left" />
                            <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                HorizontalAlign="Center" />
                            <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9"  
                                HorizontalAlign="Center" />
                            <Columns>
                                <asp:BoundField  HeaderText="Sales Person" DataField="SalesPerson" SortExpression="SalesPerson" ItemStyle-CssClass="Left5pxPadd">
                                    <ItemStyle HorizontalAlign="Left" Width="150px"  />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle HorizontalAlign="center" Width="150px" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesDol" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesDolLB" DataFormatString="{0:#,##0.000}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesGP" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesGPPct" DataFormatString="{0:#,##0.00}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesGPDolLB" DataFormatString="{0:#,##0.000}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesOrders" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesLines" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesPounds" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditDol" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditDolLB" DataFormatString="{0:#,##0.000}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditGP" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditGPPct" DataFormatString="{0:#,##0.00}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditGPDolLB" DataFormatString="{0:#,##0.000}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditOrders" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditLines" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditPounds" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
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
        

  
</td>
</tr>
</table>
    </form>
</body>
</html>

<script>
 function PrintReport()
{
     var prtContent = "<html><head><link href='common/StyleSheet/styles.css' rel='stylesheet' type='text/css' /></head><body>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:350px;'colspan=3><h3>Daily Sales Analysis Report</h3></td></tr>";
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
    var table = document.getElementById("dvDailySales"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/g, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
} 
</script>
