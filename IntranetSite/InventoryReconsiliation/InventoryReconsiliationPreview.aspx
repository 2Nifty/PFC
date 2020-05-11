<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InventoryReconsiliationPreview.aspx.cs"
    Inherits="InventoryReconsiliation_InventoryReconsiliationPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Inventory Reconciliation Report Preview</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
</head>
<body onload="javascript:print_header()">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <div id="pagePrint">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="100%" height="100%" valign="top" colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="2">
                            <tr>
                                <td class="PageHead" colspan="3" style="height: 40px">
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td class="LeftPadding" width="70%">
                                                Inventory Reconciliation Report Preview
                                            </td>
                                            <td valign="middle" width="30%" align="right">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td align="right" width="70%" style="padding: 5px;">
                                                            <img onclick="javascript:PrintReport('trHead','PrintDG2');" src="../Common/Images/Print.gif"
                                                                style="cursor: hand" /></td>
                                                        <td align="left" width="30%">
                                                            <img src="Common/Images/Buttons/Close.gif" style="cursor: hand" onclick="javascript:window.close();" /></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>                        
                             <tr id="trHead" class="PageBg" >
                                <td class="LeftPadding TabHead"  style="height: 15px" valign="top">
                                    <asp:Label ID="lblBranch" runat="server" Width="214px"></asp:Label>
                                </td>                                                                  
                                <td class="TabHead" style="width:130px">
                                    Run By : <%= Session["UserName"].ToString() %>
                                </td>
                                <td class="TabHead" style="width:130px">
                                    Run Date : <%=DateTime.Now.ToShortDateString()%>
                                </td>
                            </tr>                            
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
                            position: relative; top: 0px; left: 0px; width: 100%; height: 625px; border: 0px solid;">
                            <div id="PrintDG2">
                                <asp:DataGrid ID="dgReconsiliation" BackColor="#f4fbfd" runat="server" AutoGenerateColumns="false"
                                    ShowFooter="true" PagerStyle-Visible="false" BorderWidth="1" GridLines="both"
                                    BorderColor="#c9c6c6" OnItemDataBound="dgReconsiliation_ItemDataBound">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Center" />
                                    <ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White"
                                        Height="20px" HorizontalAlign="Left" />
                                    <AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:BoundColumn HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="left" HeaderText="Item"
                                            DataField="ItemNo" SortExpression="ItemNo" ItemStyle-Wrap="false" ItemStyle-Width="100px"
                                            HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        <asp:BoundColumn HeaderStyle-Width="220px" ItemStyle-HorizontalAlign="left" FooterStyle-HorizontalAlign="right"
                                            HeaderText="Description" DataField="ItemDesc" SortExpression="ItemDesc" ItemStyle-Wrap="false"
                                            ItemStyle-Width="220px" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        <asp:BoundColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="center" FooterStyle-HorizontalAlign="right"
                                            HeaderText="UOM" DataField="UOM" SortExpression="UOM" ItemStyle-Wrap="false"
                                            ItemStyle-Width="70px" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        <asp:BoundColumn HeaderStyle-Width="70px" DataFormatString="{0:#,##0}"  ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                            HeaderText="WMS Qty" DataField="Qty" SortExpression="Qty" ItemStyle-Wrap="false"
                                            ItemStyle-Width="70px" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        <asp:BoundColumn HeaderStyle-Width="70px" DataFormatString="{0:#,##0}"  ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                            HeaderText="ERP Qty" DataField="BookedQty" SortExpression="BookedQty" ItemStyle-Wrap="false"
                                            ItemStyle-Width="70px" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        <asp:BoundColumn HeaderStyle-Width="70px" DataFormatString="{0:#,##0}"  ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                            HeaderText="Variance " DataField="variance" SortExpression="variance" ItemStyle-Wrap="false"
                                            ItemStyle-Width="70px" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        <asp:BoundColumn HeaderText="Super UOM" ItemStyle-HorizontalAlign=center  ItemStyle-Width="60"  DataField="SuperEquiv" SortExpression="SuperEquiv">                                                
                                                <FooterStyle HorizontalAlign="Right" />                                               
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Equivelant Qty" DataFormatString="{0:#,##0}"   ItemStyle-HorizontalAlign=right  ItemStyle-Width="60" HeaderStyle-Width="120px"  DataField="SuperEquivQty" SortExpression="SuperEquivQty">                                               
                                                <FooterStyle HorizontalAlign="Right" />                                                
                                            </asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <center>
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></center>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" runat="server" id="hidSort" />
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
     var prtContent = "<html><head><link href='common/StyleSheet/Styles.css' rel='stylesheet' type='text/css' /><style>.BluBordAll {border: 1px solid #000000;} .splitBorder {border-bottom:1px Solid #efefef;border-top:0px Solid #ffffff;}</style> </head><body>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td ><h3>Inventory Reconciliation Report</h3></td></tr><tr>";
     prtContent = prtContent + document.getElementById(strid1).innerHTML+"</table>"; 
     prtContent = prtContent + document.getElementById(strid2).innerHTML;     
     prtContent = prtContent + "</body></html>";
     var WinPrint = window.open('','','letf=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');
     WinPrint.document.write(prtContent);
     WinPrint.document.close();
     WinPrint.focus();
     WinPrint.print();
     WinPrint.close();
}
 function print_header() 
{ 
    var table = document.getElementById("dgReconsiliation"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/g, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
} 
</script>

