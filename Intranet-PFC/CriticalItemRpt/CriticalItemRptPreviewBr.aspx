<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CriticalItemRptPreviewBr.aspx.cs" Inherits="CriticalItemRptPreviewBr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Branch Critical Item Report Summary</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body bottommargin="0" onload="javascript:print_header()">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td style="height: 23px" bgcolor="#EFF9FC">
                </td>
                <td bgcolor="#EFF9FC" style="height: 23px">
                    <div align="right">
                        <span>&nbsp;<img src="images/print.gif" style="cursor: hand" onclick="javascript:CallPrint('PrintDG1','PrintDG2','PrintDG3');" />
                            <img src="images/close.gif" style="cursor: hand" onclick="javascript:window.close();" />
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
                                        Branch Critical Item Report Summary</div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                                <div id="PrintDG2">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td height="22px" class="TabHead">
                                                <span class="LeftPadding"><asp:Label ID="lblVelocityType" runat="server" Text="Label"></asp:Label> : 
                                                     <%=Request.QueryString["VelocityCode"]%>
                                                </span>
                                            </td>
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
                                            <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; bottom: 0px; width: 1000px; height: 590px; border: 0px solid;">
                                                <div id="PrintDG3">
                                                 <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px" 
                                                    AutoGenerateColumns="False" ShowFooter="True" OnItemDataBound="Total_ItemDataBound">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="Location" HeaderText="Location" SortExpression="Location">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="200px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="200px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TotCount" HeaderText="Item Count" SortExpression="TotCount">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="TotCount" Visible="false" />

                                                        <asp:BoundColumn DataField="CriticalCount" HeaderText="Critical Item Count" SortExpression="CriticalCount">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn DataField="CriticalCount" Visible="false" />
                                                        
                                                        <asp:BoundColumn DataField="CriticalCountPct" HeaderText="% Critical" SortExpression="CriticalCountPct"
                                                            DataFormatString="{0:0.0%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TotWght" HeaderText="30D Usage Lbs" SortExpression="TotWght">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TotWghtCritical" HeaderText="Critical Pounds" SortExpression="TotWghtCritical">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CriticalWghtPct" HeaderText="% Critical (Pounds)" SortExpression="CriticalWghtPct"
                                                            DataFormatString="{0:0.0%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NonCriticalWghtPct" HeaderText="% Non Critical (Pounds)"
                                                            SortExpression="NonCriticalWghtPct" DataFormatString="{0:0.0%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TargetPct" HeaderText="Target %" SortExpression="TargetPct"
                                                            DataFormatString="{0:0.0%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
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
