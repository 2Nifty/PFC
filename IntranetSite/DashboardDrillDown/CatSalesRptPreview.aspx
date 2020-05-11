<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CatSalesRptPreview.aspx.cs" Inherits="CatSalesRptPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Dashboard Performance Drilldown - Sales Report By Category Preview</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
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
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                                <div id="PrintDG2">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="right" class="TabHead">
                                                <span class="LeftPadding">Run Date :
                                                    <%=DateTime.Now.Month%>
                                                    /<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
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
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                height: 590px; width: 1000px; border: 0px solid;">
                                                <div id="PrintDG3">
                                                    <table class="GridHead" width="1170px" border="0" cellspacing="0" cellpadding="0"
                                                        style="position: relative; top: 0px; left: 0px; height: 20px; width: 1170px;">
                                                        <tr style="background-color: #DFF3F9;">
                                                            <td class="GridHead">
                                                                <table width="226px">
                                                                    <tr>
                                                                        <td>
                                                                            &nbsp;</td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td class="GridHead" style="border-left: 1px solid #e1e1e1;" align="center">
                                                                <table width="279px">
                                                                    <tr>
                                                                        <td>
                                                                            - - - - - Current Month To Date - - - - -
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td class="GridHead" style="border-left: 1px solid #e1e1e1;" align="center">
                                                                <table width="282px">
                                                                    <tr>
                                                                        <td>
                                                                            - - - - - Last Closed Month - - - - -
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td class="GridHead" style="border-left: 1px solid #e1e1e1;" align="center">
                                                                <table width="280px">
                                                                    <tr>
                                                                        <td>
                                                                            - - - - - Previous Closed Month - - - - -
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px" width="1170px"
                                                        ShowFooter="True" AutoGenerateColumns="False" OnItemDataBound="ItemDataBound">
                                                        <HeaderStyle CssClass="GridHead" Wrap="false" BackColor="#DFF3F9" Height="20px" HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" />
                                                        <AlternatingItemStyle CssClass="Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF" />
                                                        <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                            HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:BoundColumn HeaderText="Cust No" DataField="CustNo" SortExpression="CustNo">
                                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                                                                <FooterStyle HorizontalAlign="Left" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Cust Name" DataField="CustName" SortExpression="CustName">
                                                                <HeaderStyle CssClass="GridHead" Width="250px" Font-Bold="True" />
                                                                <ItemStyle HorizontalAlign="Left" Width="250px" />
                                                                <FooterStyle HorizontalAlign="Left" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Sales $" DataField="SalesDollars" SortExpression="SalesDollars">
                                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Pounds" DataField="Lbs" SortExpression="Lbs">
                                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Price/Lb" DataField="SalesPerLb" SortExpression="SalesPerLb"
                                                                DataFormatString="{0:C}">
                                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Mgn %" DataField="MarginPct" SortExpression="MarginPct"
                                                                DataFormatString="{0:N2}%">
                                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Mgn $" DataField="MarginDollars" Visible="false"></asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Sales $" DataField="LMSalesDollars" SortExpression="LMSalesDollars">
                                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Pounds" DataField="LMLbs" SortExpression="LMLbs">
                                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Price/Lb" DataField="LMSalesPerLb" SortExpression="LMSalesPerLb"
                                                                DataFormatString="{0:C}">
                                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Mgn %" DataField="LMMarginPct" SortExpression="LMMarginPct"
                                                                DataFormatString="{0:N2}%">
                                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Mgn $" DataField="LMMarginDollars" Visible="false"></asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Sales $" DataField="PMSalesDollars" SortExpression="PMSalesDollars">
                                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Pounds" DataField="PMLbs" SortExpression="PMLbs">
                                                                <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="80px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Price/Lb" DataField="PMSalesPerLb" SortExpression="PMSalesPerLb"
                                                                DataFormatString="{0:C}">
                                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Mgn %" DataField="PMMarginPct" SortExpression="PMMarginPct"
                                                                DataFormatString="{0:N2}%">
                                                                <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="60px" />
                                                                <FooterStyle CssClass="Left5pxPadd" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Mgn $" DataField="PMMarginDollars" Visible="false"></asp:BoundColumn>
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

