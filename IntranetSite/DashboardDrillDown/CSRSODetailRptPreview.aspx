<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CSRSODetailRptPreview.aspx.cs" Inherits="SODetailRptPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Dashboard Performance Drilldown - Sales Order Detail Report Preview</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

<style type="text/css"> 
    .LeftPad {padding-left: 5px;}
</style> 

</head>
<body bottommargin="0" onload="javascript:print_header()">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td style="height: 23px" bgcolor="#EFF9FC">
                </td>
                <td bgcolor="#EFF9FC" style="height: 23px">
                    <div align="right">
                        <span>&nbsp;<img src="../Common/images/print.gif" style="cursor: hand" onclick="javascript:CallPrint('PrintDG1','PrintDG2','PrintDG3');" />
                            <img src="../Common/images/close.gif" style="cursor: hand" onclick="javascript:window.close();" />
                        </span>
                    </div>
                </td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr valign="top">
                <td colspan="2" style="height: 314px">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="2" valign="middle">
                                <div id="PrintDG1">
                                    <div align="left" class="LeftPadding">
                                        <asp:Label ID="lblRangeHd" runat="server"></asp:Label>
                                        <asp:Label ID="lblBranchHd" runat="server"></asp:Label>
                                        <asp:Label ID="lblInvHd" runat="server"></asp:Label>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                                <div id="PrintDG2">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="right" class=TabHead><span class=LeftPadding>Run Date : <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" width="100%">
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative;
                                                top: 0px; left: 5px; bottom: 0px; height: 590px; width: 1000px; border: 0px solid;">
                                                <div id="PrintDG3">
                                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px" width="1100px"
                                                    ShowFooter="True" OnItemDataBound="ItemDataBound" AutoGenerateColumns="False">
                                                <HeaderStyle CssClass="GridHead" Wrap=false BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                    HorizontalAlign="Center" />
                                                <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" />
                                                <AlternatingItemStyle CssClass="Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF" />
                                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                    HorizontalAlign="Right" />
                                                <Columns>
                                                    <asp:BoundColumn HeaderText="Invoice" DataField="InvoiceNo" SortExpression="InvoiceNo">
                                                        <HeaderStyle CssClass="GridHead" Width="65px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Center" Width="65px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Cust No" DataField="CustNo" SortExpression="CustNo">
                                                        <HeaderStyle CssClass="GridHead" Width="65px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Center" Width="65px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Customer Name" DataField="CustName" SortExpression="CustName">
                                                        <HeaderStyle CssClass="GridHead" Width="250px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Left" Width="250px" />
                                                        <FooterStyle HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderText="Loc" DataField="Location" SortExpression="Location">
                                                        <HeaderStyle CssClass="GridHead" Width="30px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Center" Width="30px" />
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderText="Post Date" DataField="ARPostDt" SortExpression="ARPostDt" DataFormatString="{0:MM/dd/yyyy}">
                                                        <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Center" Width="75px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Item No" DataField="ItemNo" SortExpression="ItemNo">
                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Center" Width="100px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Line" DataField="LineNumber" SortExpression="LineNumber">
                                                        <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Center" Width="60px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Ship Qty" DataField="QtyShipped" SortExpression="QtyShipped">
                                                        <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                        <FooterStyle CssClass="Left5pxPadd" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Sales $" DataField="SalesDollars" SortExpression="SalesDollars">
                                                        <HeaderStyle CssClass="GridHead" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="70px" />
                                                        <FooterStyle CssClass="Left5pxPadd" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Pounds" DataField="Lbs" SortExpression="Lbs">
                                                        <HeaderStyle CssClass="GridHead" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="70px" />
                                                        <FooterStyle CssClass="Left5pxPadd" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Price/Lb" DataField="SalesPerLb" SortExpression="SalesPerLb" DataFormatString="{0:C}">
                                                        <HeaderStyle CssClass="GridHead LeftPad" Width="50px" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="50px" />
                                                        <FooterStyle CssClass="Left5pxPadd" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Mgn $" DataField="MarginDollars" SortExpression="MarginDollars">
                                                        <HeaderStyle CssClass="GridHead" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="70px" />
                                                        <FooterStyle CssClass="Left5pxPadd" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Mgn/Lb" DataField="MarginPerLb" SortExpression="MarginPerLb" DataFormatString="{0:C}">
                                                        <HeaderStyle CssClass="GridHead LeftPad" Width="50px" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="50px" />
                                                        <FooterStyle CssClass="Left5pxPadd" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Mgn %" DataField="MarginPct" SortExpression="MarginPct" DataFormatString="{0:N2}%">
                                                        <HeaderStyle CssClass="GridHead LeftPad" Width="50px" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="50px" />
                                                        <FooterStyle CssClass="Left5pxPadd" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Src" DataField="OrderSource" SortExpression="OrderSource">
                                                        <HeaderStyle CssClass="GridHead" Width="35px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Center" Width="35px" />
                                                    </asp:BoundColumn>
                                                </Columns>
                                                </asp:DataGrid>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height: 20px" bgcolor="#EFF9FC">
                </td>
            </tr>
        </table>
    </form>
</body>

<script>

function CallPrint(strid1,strid2,strid3)
        {
             var prtContent = "<html><head><link href='StyleSheet/Styles.css' rel='stylesheet' type='text/css' /></head><body>"
             
             prtContent = prtContent + document.getElementById(strid1).innerHTML;
             prtContent = prtContent + document.getElementById(strid2).innerHTML;
             prtContent = prtContent + document.getElementById(strid3).innerHTML;
             
             prtContent = prtContent + "</body></html>";
             var WinPrint = window.open('','','letf=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');
             WinPrint.document.write(prtContent);
             WinPrint.document.close();
             WinPrint.focus();
             WinPrint.print();
             WinPrint.close();
             //prtContent.innerHTML=strOldOne;
        }
      function print_header() 
        { 
            var table = document.getElementById("GridView1"); // the id of your DataGrid
            var str = table.outerHTML; 
            str = str.replace(/<TBODY>/i, ""); 
            str = str.replace(/<TR/i, "<THEAD style='display:table-header-group;'><TR"); 
            str = str.replace(/<\/TR>/i, "</TR></THEAD><TBODY>"); 
            table.outerHTML = str; 
        } 
</script>

</html>