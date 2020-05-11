<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OpenOrderRptPreview.aspx.cs" Inherits="OpenOrderRptPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Open Order Report Preview</title>
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
                                       <span style="font-size: 16px;font-weight: bold;color: #3A3A56;">Open Order Report</span></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                                <div id="PrintDG2">
                                    <table border="0" class="TabHead" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td style="width: 55px">
                                            <asp:Label ID="Label1" runat="server" Height="20px" Text="Cust No:" Width="50px"></asp:Label></td>
                                        <td style="width: 160px">
                                            <asp:Label ID="lblCustNo" runat="server" Height="20px" Width="80px"></asp:Label></td>
                                        <td style="width: 58px">
                                            <asp:Label ID="Label3" runat="server" Height="20px" Text="Order Type:" Width="70px"></asp:Label></td>
                                        <td style="width: 160px">
                                            <asp:Label ID="lblOrderType" runat="server" Height="20px" Width="160px"></asp:Label></td>
                                        <td style="width: 55px">
                                            <asp:Label ID="Label7" runat="server" Height="20px" Text="Salesperson:" Width="80px"></asp:Label></td>
                                        <td style="width: 202px">
                                            <asp:Label ID="lblSalesPerson" runat="server" Height="20px" Width="99px"></asp:Label></td>
                                        <td colspan="1" rowspan="2" valign="top">
                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td align="right" class=TabHead>
                                                        <span class=LeftPadding>Run Date :
                                                            <%=DateTime.Now.Month%>
                                                            /<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 55px">
                                            <asp:Label ID="Label2" runat="server" Height="20px" Text="Sales Loc:" Width="60px"></asp:Label></td>
                                        <td style="width: 160px">
                                            <asp:Label ID="lblSalesLoc" runat="server" Height="20px" Width="160px"></asp:Label></td>
                                        <td style="width: 58px">
                                            <asp:Label ID="Label5" runat="server" Height="20px" Text="Ship Loc:" Width="60px"></asp:Label></td>
                                        <td style="width: 160px">
                                            <asp:Label ID="lblShipLoc" runat="server" Height="20px" Width="160px"></asp:Label></td>
                                        <td colspan="2">
                                            <table  class="TabHead" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label9" runat="server" Height="20px" Text="Show:" Width="40px"></asp:Label></td>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="lblLineType" runat="server" Height="20px" Width="202px"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
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
                                            <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; bottom: 0px; width: 1015px; height: 575px; border: 0px solid;">
                                                <div id="PrintDG3">
                                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" Width="1500" runat="server" BorderWidth="1px"
                                                    ShowFooter="False" AutoGenerateColumns="False">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" Height=18px />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" Height=18px />
                                                   <Columns>
                                                        <asp:BoundColumn DataField="CustNo" HeaderText="Cust No" SortExpression="CustNo">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CustName" HeaderText="Cust Name" SortExpression="CustName">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="200px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="200px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SONumber" HeaderText="SO Number" SortExpression="SONumber">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="PONumber" HeaderText="PO Number" SortExpression="PONumber">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="90px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="90px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Ref" HeaderText="Reference" SortExpression="Ref">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="95px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="95px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Item" HeaderText="Item No" SortExpression="Item">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Description" HeaderText="Description" SortExpression="Description">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="250px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="250px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Quantity" HeaderText="Quantity" SortExpression="Quantity" DataFormatString="{0:0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="UOM" HeaderText="UOM" SortExpression="UOM">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="40px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="40px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="UnitPrice" HeaderText="Unit Price" SortExpression="UnitPrice" DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Mgn%" HeaderText="Mgn %" SortExpression="Mgn%" DataFormatString="{0:0.00%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OrderDt" HeaderText="Order Date" SortExpression="OrderDt" DataFormatString="{0:MM/dd/yyyy}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="80px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ShipDt" HeaderText="Ship Date" SortExpression="ShipDt" DataFormatString="{0:MM/dd/yyyy}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="80px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SalesLoc" HeaderText="Sell Loc" SortExpression="SalesLoc">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="20px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="20px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ShipLoc" HeaderText="Ship Loc" SortExpression="ShipLoc">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="20px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="20px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AltPrice" HeaderText="Alt Price" SortExpression="AltPrice" DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AltUOM" HeaderText="Alt UOM" SortExpression="Alt UOM">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="30px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="30px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SalesPerson" HeaderText="Salesperson" SortExpression="SalesPerson">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="120px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="120px" Font-Bold="True" HorizontalAlign="Center" />
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
