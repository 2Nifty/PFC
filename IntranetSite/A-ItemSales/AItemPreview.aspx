<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AItemPreview.aspx.cs" Inherits="AItemPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>"A" Item Sales Report Preview</title>
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
                                        "A" Item Sales Report</div>
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
                                            <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; bottom: 0px; width: 1000px; height: 590px; border: 0px solid;">
                                                <div id="PrintDG3">
                                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px"
                                                    ShowFooter="False" AutoGenerateColumns="False">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="ItemNo" HeaderText="Item No" SortExpression="ItemNo">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Loc" HeaderText="Loc" SortExpression="Loc">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="30px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="30px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Description" HeaderText="Description" SortExpression="Description">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="150px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="150px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
<%--                                                        <asp:BoundColumn DataField="CorpFixedVelCode" HeaderText="Corp Fixed Velocity" SortExpression="CorpFixedVelCode">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>--%>
                                                        <asp:BoundColumn DataField="TotUse30" HeaderText="30 Day Usage" SortExpression="TotUse30"
                                                            DataFormatString="{0:N0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TotUseWgt" HeaderText="Usage Wgt" SortExpression="TotUseWgt"
                                                            DataFormatString="{0:N2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AvailQty" HeaderText="Available Qty" SortExpression="AvailQty"
                                                            DataFormatString="{0:N0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AvailWgt" HeaderText="Available Wgt" SortExpression="AvailWgt"
                                                            DataFormatString="{0:N2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Net_Wgt" HeaderText="Net Wgt" SortExpression="Net_Wgt"
                                                            DataFormatString="{0:N2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Avg_CostM" HeaderText="Avg Cost" SortExpression="Avg_CostM"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SuggSell" HeaderText="Sugg. Sell Price" SortExpression="SuggSell"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="6MthAvgSellPrice" HeaderText="6 Mo. Avg Sell Price" SortExpression="6MthAvgSellPrice"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="LastWkAvgSellPrice" HeaderText="Last Wk Avg Sell Price" SortExpression="LastWkAvgSellPrice"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="2ndWkAvgSellPrice" HeaderText="2nd Wk Avg Sell Price" SortExpression="2ndWkAvgSellPrice"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="3rdWkAvgSellPrice" HeaderText="3rd Wk Avg Sell Price" SortExpression="3rdWkAvgSellPrice"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="4thWkAvgSellPrice" HeaderText="4th Wk Avg Sell Price" SortExpression="4thWkAvgSellPrice"
                                                            DataFormatString="{0:C2}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
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

