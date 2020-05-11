<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UnProcessPreview.aspx.cs" Inherits="ReadyToShip_UnProcessPreview" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc2" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/newfooter.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Goods En Route Ready to Ship V1.0.0</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    
    <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
</head>
<body onload="javascript:print_header()">
    <form id="form1" runat="server">
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="100%" height="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                        <tr>
                            <td class="PageHead" colspan="5" style="height: 40px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                <tr>
                                <td>
                                 <uc2:Header ID="Header1" runat="server" />
                                </td>
                                </tr>
                                    <tr>                                        
                                        <td valign="middle" width="100%" align="right">
                                            <table border="0" align="right" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                <td width="80%"></td>
                                                    <td align="right"  style="padding: 5px;">
                                                        <img onclick="javascript:PrintReport('trHead','div-datagrid');" src="../Common/Images/Print.gif"
                                                            style="cursor: hand" /></td>
                                                    <td align="left">
                                                        <img src="../Common/Images/Close.gif" style="cursor: hand" onclick="javascript:window.close();" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr id="trHead" class="PageBg" height="20px">
                            <td class="TabHead" width=300px >&nbsp;
                               <span> Vendor/Port of Lading:</span>&nbsp;<%= Request.QueryString["Vendor"]%>&nbsp;-&nbsp; <%=Request.QueryString["Port"]%> 
                            </td>                           
                            <td class="TabHead" width=150px>
                                Run By : <%= Session["UserName"].ToString()%>
                            </td>
                            <td class="TabHead"  colspan=2 align=left width=150px>
                                Run Date : <%=DateTime.Now.ToShortDateString()%>
                            </td> 
                            <td>&nbsp;</td>                           
                        </tr>
                    </table>
                </td>
            </tr>           
            <tr>
                <td>
                    <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
                        position: relative; top: 0px; left: 0px; width: 100%; height: 560px; border: 0px solid;">
                        <%--<div id="PrintDG2">--%>
                            <asp:DataGrid ID="dgReview" BackColor="#f4fbfd" runat="server" 
                                AutoGenerateColumns="false" UseAccessibleHeader=true ShowFooter="false" PagerStyle-Visible="false" BorderWidth="1"
                                GridLines="both" BorderColor="#c9c6c6">
                               <HeaderStyle HorizontalAlign="center" CssClass="GridHead" BackColor="#DFF3F9" />
                                <ItemStyle CssClass="Left2pxPadd GridItem" BackColor="#F4FBFD" />
                                <AlternatingItemStyle CssClass="Left2pxPadd GridItem" BackColor="White" />
                                <FooterStyle HorizontalAlign="Right" BackColor="#DFF3F9" />
                                 <Columns>
                                    <asp:BoundColumn ItemStyle-CssClass="Left2pxPadd" DataField="PONo" HeaderText="PO #" ItemStyle-Width="60px" ItemStyle-HorizontalAlign=left></asp:BoundColumn>
                                    <asp:BoundColumn ItemStyle-CssClass="Left2pxPadd" DataField="ItemNo" HeaderText="Item No" ItemStyle-Width="130px" ItemStyle-HorizontalAlign=left></asp:BoundColumn>
                                    <asp:BoundColumn ItemStyle-CssClass="Right2pxPadd" DataField="Qty" HeaderText="Qty" ItemStyle-Width="50px" DataFormatString="{0:#,##0}" ItemStyle-HorizontalAlign=right></asp:BoundColumn>
                                    <asp:BoundColumn ItemStyle-CssClass="Right2pxPadd" DataField="GrossWght" HeaderText="Gross Weight" ItemStyle-Width="80px" DataFormatString="{0:#,##0.00}" ItemStyle-HorizontalAlign=right></asp:BoundColumn>
                                    <asp:BoundColumn ItemStyle-CssClass="Left2pxPadd" DataField="GERRTSStatCd" HeaderText="Priority Code" ItemStyle-Width="80px" ItemStyle-HorizontalAlign=left></asp:BoundColumn>
                                </Columns>
                            </asp:DataGrid>
                            <center>
                                <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                    Visible="False"></asp:Label></center>
                        <%--</div>--%>
                    </div>
                   
                    <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                    <input type="hidden" runat="server" id="hidSort" /></td>
            </tr>
            <tr>
                <td >
                    <uc2:BottomFooter ID="BottomFrame2"  Title="Ready to Ship - Unprocessed Records"   runat="server" />
                </td>
            </tr>
            
        </table>
    </form>
</body>
</html>
<script type="text/javascript">
function PrintReport(strid1,strid2)
{
  var prtContent = "<html><head><link href='common/StyleSheet/styles.css' rel='stylesheet' type='text/css' /></head><body>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 style='width:100%'><tr><td style='width:50%;word-break:keep-all;'><h3 style='word-break:keep-all;'>Ready to Ship - Unprocessed Records</h3></td></tr><tr>";
     prtContent = prtContent + document.getElementById(strid1).innerHTML+"</table>"; 
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
    var table = document.getElementById("dgReview"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/i, ""); 
    str = str.replace(/<TR/i, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/i, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
} 

</script>