<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesReportByCatGroupPreview.aspx.cs"
    Inherits="ROISalesReport_SalesReportByCatGroupPreview" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>ROI Sales Report by Category Group Preview</title>
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
                                <td class="PageHead" colspan="4" style="height: 40px">
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td class="Left5pxPadd BannerText"  width=90%>
                                            <asp:Label Text="ROI Sales Report by Category Group" style="word-wrap:normal" ID="lblReportCap" runat=server Width="350px"></asp:Label>                                                
                                            </td>
                                            <td valign="middle"  align="right">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td align="right" width="70%" style="padding:5px;">
                                                            <img onclick="javascript:PrintReport('trHead','PrintDG2');" src="../Common/Images/Print.gif"
                                                                style="cursor: hand" id="IMG1" /></td>
                                                        <td align="left" width="30%">
                                                            <img src="Common/Images/Buttons/Close.gif" style="cursor: hand" onclick="javascript:window.close();" /></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="trHead" class="PageBg" height="15px">
                            <td class="LeftPadding TabHead" style="width:400px">
                                Fiscal Period : <%= ROISalesReport.GetDate(Request.QueryString["Month"])%>&nbsp;<%=Request.QueryString["Year"]%> 
                            </td>                           
                            <td class="TabHead" style="width:200px">
                                Run By : <%= Session["UserName"].ToString()%>
                            </td>
                            <td class="TabHead" style="width:300px" colspan=2 align=left>
                                Run Date : <%=DateTime.Now.ToShortDateString()%>
                            </td>                            
                        </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
                            position: relative; top: 0px; left: 0px; width: 100%; height: 610px; border: 0px solid;">
                            <div id="PrintDG2">
                                <asp:DataGrid ID="dgCategoryGroup" BackColor="#f4fbfd" runat="server" 
                                AutoGenerateColumns="false" ShowFooter="true" PagerStyle-Visible="false" BorderWidth="1"
                                GridLines="both" BorderColor="#c9c6c6" OnItemDataBound="dgCategoryGroup_ItemDataBound">
                                <HeaderStyle HorizontalAlign="center" Height=25px CssClass="GridHead" BackColor="#DFF3F9" />
                                <ItemStyle CssClass="GridItem" BackColor="#F4FBFD" />
                                <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                    <Columns>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="left" HeaderText="Cat Group" FooterStyle-HorizontalAlign="right"
                                        DataField="CatGroup" SortExpression="CatGroup" ItemStyle-Wrap="false"
                                        ItemStyle-Width="250" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="Inv $"
                                            FooterStyle-HorizontalAlign="right" DataField="ExtAvgCost" DataFormatString="{0:#,##0}"
                                            SortExpression="ExtAvgCost" ItemStyle-Wrap="false" ItemStyle-Width="60" HeaderStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="12 Mos Sales"
                                            FooterStyle-HorizontalAlign="right" DataField="Roll12Sales" DataFormatString="{0:#,##0}"
                                            SortExpression="Roll12Sales" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="M_OH"
                                            FooterStyle-HorizontalAlign="right" DataField="AvgCostSales" DataFormatString="{0:#,##0.0}"
                                            SortExpression="AvgCostSales" ItemStyle-Wrap="false" ItemStyle-Width="60" HeaderStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="$/Lb"
                                            FooterStyle-HorizontalAlign="right" DataField="SalesLbs" DataFormatString="{0:#,##0.000}"
                                            SortExpression="SalesLbs" ItemStyle-Wrap="false" ItemStyle-Width="60" HeaderStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn HeaderStyle-Width="60" ItemStyle-HorizontalAlign="right" HeaderText="GM/Lb"
                                            FooterStyle-HorizontalAlign="right" DataField="GMLbs" DataFormatString="{0:#,##0.000}"
                                            SortExpression="GMLbs" ItemStyle-Wrap="false" ItemStyle-Width="60" HeaderStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="% Corp $" FooterStyle-HorizontalAlign="right"
                                        DataField="Roll12PctTotSalesCorpAvg" DataFormatString="{0:#,##0.0}" SortExpression="Roll12PctTotSalesCorpAvg" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="% Corp GM $" FooterStyle-HorizontalAlign="right"
                                        DataField="Roll12GMPctCorpAvg" DataFormatString="{0:#,##0.0}" SortExpression="Roll12GMPctCorpAvg" ItemStyle-Wrap="false"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="ROI" DataField="ROI"
                                            SortExpression="ROI" DataFormatString="{0:#,##0.000}" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="right"
                                            ItemStyle-Width="60" HeaderStyle-Wrap="false"></asp:BoundColumn>                                       
                                    </Columns>
                                </asp:DataGrid>
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
 function PrintReport(strid1,strid2)
{
     var prtContent = "<html><head><link href='common/StyleSheet/stylesheet.css' rel='stylesheet' type='text/css' /></head><body>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:350px;'colspan=3><h3>ROI Sales Report by Category Group</h3></td></tr><tr>";
     prtContent = prtContent + document.getElementById(strid1).innerHTML+"</table><br>"; 
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
 function print_header() 
{ 
    var table = document.getElementById("dgCategoryGroup"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/i, ""); 
    str = str.replace(/<TR/i, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/i, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
} 
</script>

