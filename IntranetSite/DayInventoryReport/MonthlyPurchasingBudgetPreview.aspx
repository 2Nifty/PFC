<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MonthlyPurchasingBudgetPreview.aspx.cs" Inherits="MonthlyPurchasingBudget_Preview" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Monthly Purchasing Budget</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
</head>
<body onload="javascript:print_header()">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="100%" height="100%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="4">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td style="height: 40px;" >
                                            <div id="PrintDG1" class="Left5pxPadd">
                                                <div align="left" class="BannerText">
                                                    <asp:Label ID="lblMenuName" CssClass="BannerText" runat="server" Text=""></asp:Label></div>
                                            </div>
                                        </td>
                                        
                                        <td valign="middle" align="right" >
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td align="left" width="70%" style="padding: 5px;">
                                                        <img align="right" onclick="javascript:PrintReport('PrintDG2','trHead');" src="../Common/Images/Print.gif"
                                                            style="cursor: hand" /></td>
                                                    <td align="left" width="30%">
                                                        <img align="right" src="Common/Images/Buttons/Close.gif" style="cursor: hand" onclick="javascript:window.close();" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                         <tr id="trHead" class="PageBg" height="20px">
                            <td class="LeftPadding TabHead" style="width:400px">
                                Fiscal Period : <%= MnthlyPrchasingBdgtData.GetDateCondition()%>
                            </td>                           
                            <td class="TabHead" style="width:200px">
                                Run By : <%= Session["UserName"].ToString()%>
                            </td>
                            <td class="TabHead" style="width:300px" colspan=2 align=left>
                                Run Date : <%=DateTime.Now.ToString()%>
                            </td>                            
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="div-datagrid" class="Sbar" style="overflow-x: hidden; overflow-y: auto;
                        position: relative; top: 0px; left: 0px; bottom: 0px; width: 100%; height: 615px;
                        border: 0px solid;">
                        <div id="PrintDG2">
                            <asp:DataGrid ID="dgPurchBudget"  BackColor="#f4fbfd" runat="server"
                                AutoGenerateColumns="false" ShowFooter="true" PagerStyle-Visible="false" BorderWidth="1"
                                GridLines="both" BorderColor="#c9c6c6" OnItemDataBound="dgPurchBudget_ItemDataBound">                                
                                <HeaderStyle HorizontalAlign="center" CssClass="GridHead" BackColor="#DFF3F9" />
                                <ItemStyle CssClass="GridItem" BackColor="#F4FBFD" />
                                <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                <Columns>
                                    <asp:BoundColumn ItemStyle-HorizontalAlign="center" HeaderText="Cat Grp"
                                        FooterStyle-HorizontalAlign="center" DataField="RecordKey" SortExpression="RecordKey"
                                        ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Usage"
                                        FooterStyle-HorizontalAlign="right" DataField="MonthlyUseLbs" DataFormatString="{0:#,##0}"
                                        SortExpression="MonthlyUseLbs" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Avail "
                                        FooterStyle-HorizontalAlign="right" DataField="AvailableLbs" DataFormatString="{0:#,##0}"
                                        SortExpression="AvailableLbs" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="OTW"
                                        FooterStyle-HorizontalAlign="right" DataField="OWLbs" DataFormatString="{0:#,##0}"
                                        SortExpression="OWLbs" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="In Transit "
                                        FooterStyle-HorizontalAlign="right" DataField="TransferLbs" DataFormatString="{0:#,##0}"
                                        SortExpression="TransferLbs" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="SubTotal "
                                        FooterStyle-HorizontalAlign="right" DataField="AvailTransferOWLbs" DataFormatString="{0:#,##0}"
                                        SortExpression="AvailTransferOWLbs" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="On Order "
                                        FooterStyle-HorizontalAlign="right" DataField="OnOrderLbs" DataFormatString="{0:#,##0}"
                                        SortExpression="OnOrderLbs" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    
																		<asp:BoundColumn DataField="AvailTransferOWOnOrderLbs" DataFormatString="{0:#,##0}" FooterStyle-HorizontalAlign="right"
																			HeaderStyle-Width="80" HeaderStyle-Wrap="false" HeaderText="Total" ItemStyle-HorizontalAlign="right"
																			ItemStyle-Width="80" ItemStyle-Wrap="false" SortExpression="AvailTransferOWOnOrderLbs"></asp:BoundColumn>
																		<asp:BoundColumn DataField="AvailableMonths" DataFormatString="{0:#,##0.0}" FooterStyle-HorizontalAlign="right"
																			HeaderStyle-Width="50" HeaderStyle-Wrap="false" HeaderText="Avail " ItemStyle-HorizontalAlign="right"
																			ItemStyle-Width="50" ItemStyle-Wrap="false" SortExpression="AvailableMonths"></asp:BoundColumn>
																		<asp:BoundColumn DataField="OWMonths" DataFormatString="{0:#,##0.0}" FooterStyle-HorizontalAlign="right"
																			HeaderStyle-Width="50" HeaderStyle-Wrap="false" HeaderText="OTW" ItemStyle-HorizontalAlign="right"
																			ItemStyle-Width="50" ItemStyle-Wrap="false" SortExpression="OWMonths"></asp:BoundColumn>
																		<asp:BoundColumn DataField="TransferMonths" DataFormatString="{0:#,##0.0}" FooterStyle-HorizontalAlign="right"
																			HeaderStyle-Width="50" HeaderStyle-Wrap="false" HeaderText="In Transit " ItemStyle-HorizontalAlign="right"
																			ItemStyle-Width="50" ItemStyle-Wrap="false" SortExpression="TransferMonths"></asp:BoundColumn>
																		<asp:BoundColumn DataField="AvailTransferOWMonths" DataFormatString="{0:#,##0.0}" FooterStyle-HorizontalAlign="right"
																			HeaderStyle-Width="50" HeaderStyle-Wrap="false" HeaderText="SubTot" ItemStyle-HorizontalAlign="right"
																			ItemStyle-Width="50" ItemStyle-Wrap="false" SortExpression="AvailTransferOWMonths">
																		</asp:BoundColumn>
																		<asp:BoundColumn DataField="OnOrderMonths" DataFormatString="{0:#,##0.0}" FooterStyle-HorizontalAlign="right"
																			HeaderStyle-Width="50" HeaderStyle-Wrap="false" HeaderText="On Order " ItemStyle-HorizontalAlign="right"
																			ItemStyle-Width="50" ItemStyle-Wrap="false" SortExpression="OnOrderMonths"></asp:BoundColumn>
																	<asp:BoundColumn DataField="AvailTransferOWOnOrderMonths" DataFormatString="{0:#,##0.0}" FooterStyle-HorizontalAlign="right"
																		HeaderStyle-Width="50" HeaderStyle-Wrap="false" HeaderText="Total " ItemStyle-HorizontalAlign="right"
																		ItemStyle-Width="50" ItemStyle-Wrap="false" SortExpression="AvailTransferOWOnOrderMonths"></asp:BoundColumn>
																	<asp:BoundColumn DataField="CPRFactor" DataFormatString="{0:#,##0.0}"
																		FooterStyle-HorizontalAlign="right" HeaderStyle-Width="50" HeaderStyle-Wrap="false"
																		HeaderText="Factor " ItemStyle-HorizontalAlign="right" ItemStyle-Width="50" ItemStyle-Wrap="false"
																		SortExpression="CPRFactor"></asp:BoundColumn>
																	<asp:BoundColumn DataField="CPRBuyCartons" DataFormatString="{0:#,##0}"
																		FooterStyle-HorizontalAlign="right" HeaderStyle-Width="80" HeaderStyle-Wrap="false"
																		HeaderText="Cartons" ItemStyle-HorizontalAlign="right" ItemStyle-Width="80" ItemStyle-Wrap="false"
																		SortExpression="CPRBuyCartons"></asp:BoundColumn>
																	<asp:BoundColumn DataField="CPRBuyMonths" DataFormatString="{0:#,##0.0}" FooterStyle-HorizontalAlign="right"
																		HeaderStyle-Width="50" HeaderStyle-Wrap="false" HeaderText="Buy Months " ItemStyle-HorizontalAlign="right"
																		ItemStyle-Width="50" ItemStyle-Wrap="false" SortExpression="CPRBuyMonths"></asp:BoundColumn>
																	<asp:BoundColumn HeaderStyle-Width="300" ItemStyle-HorizontalAlign="left" HeaderText="Description "
                                        ItemStyle-CssClass="LeftPadding" FooterStyle-HorizontalAlign="left" DataField="RecordDesc"
                                        SortExpression="RecordDesc" ItemStyle-Wrap="false" ItemStyle-Width="300" HeaderStyle-Wrap="false">
                                    </asp:BoundColumn>
                                    
                                </Columns>
                            </asp:DataGrid>
                             <center><asp:Label ID="Label1" runat="server" CssClass="redtitle"  Text="No Records Found"
                                    Visible="False"></asp:Label></center>   
                        </div>
                    </div>
                    <center>
                    <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                    <input type="hidden" runat="server" id="hidSort" />
                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found" Visible="False"></asp:Label></center>
                </td>
            </tr>
            <tr>
                <td>
                    <uc1:Footer ID="Footer1" runat="server" />
                </td>
            </tr>
                 
        </table>
    </form>
</body>
</html>

<script type="text/javascript">
function PrintReport(strid2,strid3)
{
  
     var prtContent = "<html><head><link href='Common/StyleSheet/Styles.css' rel='stylesheet' type='text/css'/></head><body><h5>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:600px;padding-left:20px;height:30px;'colspan=4><h3>"+document.getElementById("lblMenuName").innerHTML+"</h3></td></tr><tr>";
     prtContent = prtContent + document.getElementById(strid3).innerHTML+"</table><br>"; 
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
    var table = document.getElementById("dgDayReport"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/i, ""); 
    str = str.replace(/<TR/i, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/i, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
} 
</script>

