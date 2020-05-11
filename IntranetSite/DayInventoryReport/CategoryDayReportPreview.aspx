<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CategoryDayReportPreview.aspx.cs" Inherits="DayInventoryReport_CategoryDayReportPreview" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head id="Head1" runat="server">
    <title>365 Day Inventory Report</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
</head>
<body onload="javascript:print_header()">
    <form id="form1" runat="server">       
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
           
            <tr>
                <td width="100%" height="100%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
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
                            <td class="LeftPadding TabHead" style="width:400px;padding-left:15px;">
                                Fiscal Period : <%= DayInventoryReport.GetDateCondition()%>
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
                    </table>
                </td>
            </tr>
            <tr id="trHeader">
                <td bgcolor="#EFF9FC" height="25px">
                    <span class="BlackBold">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cat Grp -
                        <%=Request.QueryString["CategoryGroup"]%>
                        <%=Request.QueryString["CategoryGroupDesc"]%>
                    </span>                
                    <span class="BlackBold">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Branch : 
                    <%=Request.QueryString["Branch"]%></span>
                </td>
            </tr>
            <tr id="trHeader1">
                <td width="100%">                    
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">                               
                                <tr>
                                    <td>
                                        <div id="div-datagrid" class="Sbar" style="overflow-x: hidden; overflow-y: auto;
                        position: relative; top: 0px; left: 0px; bottom: 0px; width: 100%; height: 580px;
                        border: 0px solid;">
                                                <div id="PrintDG2">
                                                <asp:DataGrid ID="dgDayReport"  BackColor="#f4fbfd" runat="server" 
                                                AutoGenerateColumns="false" ShowFooter="true" PagerStyle-Visible="false" BorderWidth="1"
                                                GridLines="both" BorderColor="#c9c6c6" OnItemDataBound="dgDayReport_ItemDataBound">
                                                    <HeaderStyle HorizontalAlign="center" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <ItemStyle CssClass="GridItem" BackColor="#F4FBFD" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <Columns>
                                                        <asp:BoundColumn HeaderStyle-Width="120" ItemStyle-HorizontalAlign="center" HeaderText="Item No."
                                                            FooterStyle-HorizontalAlign="right" DataField="ItemNo" SortExpression="ItemNo"
                                                            ItemStyle-Wrap="false" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="60" ItemStyle-HorizontalAlign="right" HeaderText="Qty O/H "
                                                            FooterStyle-HorizontalAlign="right" DataField="OnHand" DataFormatString="{0:#,##0}"
                                                            SortExpression="OnHand" ItemStyle-Wrap="false" HeaderStyle-Wrap="false">
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="60" ItemStyle-HorizontalAlign="right" HeaderText="$ O/H "
                                                            FooterStyle-HorizontalAlign="right" DataField="OnHandValue" DataFormatString="{0:#,##0}"
                                                            SortExpression="OnHandValue" ItemStyle-Wrap="false" HeaderStyle-Wrap="false">
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Daily Usg $ @ Avg Cost"
                                                            FooterStyle-HorizontalAlign="right" DataField="DailySalesValue" DataFormatString="{0:#,##0.00}"
                                                            SortExpression="DailySalesValue" ItemStyle-Wrap="false" ItemStyle-Width="80"
                                                            HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="Days Supply "
                                                            FooterStyle-HorizontalAlign="right" DataField="DaysOnHand" DataFormatString="{0:#,##0.000}"
                                                            SortExpression="DaysOnHand" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="$ Value Days Supply > 150D "
                                                            FooterStyle-HorizontalAlign="right" DataField="OHgt150Days" DataFormatString="{0:#,##0}"
                                                            SortExpression="OHgt150Days" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="right" HeaderText="$ Value Days Supply > 365D "
                                                            FooterStyle-HorizontalAlign="right" DataField="OHgt365Days" DataFormatString="{0:#,##0}"
                                                            SortExpression="OHgt365Days" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="250" ItemStyle-HorizontalAlign="left" HeaderText="Item Description " ItemStyle-CssClass="LeftPadding"
                                                            FooterStyle-HorizontalAlign="left" DataField="ItemDesc" SortExpression="ItemDesc"
                                                            ItemStyle-Wrap="false"  HeaderStyle-Wrap="false"></asp:BoundColumn>                                                      
                                                    </Columns>
                                                </asp:DataGrid>
                                                <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle"  Text="No Records Found"
                                    Visible="False"></asp:Label></center>   
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </table>                    
                    <input type="hidden" runat="server" id="hidSort" /></td>
            </tr>            
            <tr>
                <td width="100%">
                    <uc1:Footer ID="Footer1" runat="server" />
                </td>
            </tr>
           
        </table>
    </form>
</body>
</html>
 <script type="text/javascript">
function PrintReport(strid2,strid1)
{  
     var prtContent = "<html><head><link href='Common/StyleSheet/Styles.css' rel='stylesheet' type='text/css' /></head><body><h5>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:600px;height:30px;padding-left:20px;'colspan=4><h3>"+document.getElementById("lblMenuName").innerHTML+"</h3></td></tr><tr>";
     prtContent = prtContent + document.getElementById(strid1).innerHTML+"</table>";     
     prtContent = prtContent + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cat Grp - "+'<%=Request.QueryString["CategoryGroup"]%>'+" "+'<%=Request.QueryString["CategoryGroupDesc"]%>';                        
     prtContent = prtContent + "&nbsp;&nbsp;&nbsp;&nbsp; Branch : "+'<%=Request.QueryString["Branch"]%>'+""; 
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
            var table = document.getElementById("dgDayReport"); 
            var str = table.outerHTML; 
            str = str.replace(/<TBODY>/i, ""); 
            str = str.replace(/<TR/i, "<THEAD style='display:table-header-group;'><TR"); 
            str = str.replace(/<\/TR>/i, "</TR></THEAD><TBODY>"); 
            table.outerHTML = str; 
        } 
</script>