<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemBranchActivityPreview.aspx.cs" Inherits="AC_ItemBranchActivity_ItemBranchActivityPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>AC Item Branch Activity Preview</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
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
                                        Avg Cost Item Branch Activity</div>
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
                                            top: 0px; left: 5px; height: 555px; width: 1010px; border: 0px solid;">
                                                <div id="PrintDG3">
                                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px"
                                                    ShowFooter="False" AutoGenerateColumns="False">
                                                <HeaderStyle CssClass="GridHead" Wrap=false BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                    HorizontalAlign="Center" />
                                                <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" />
                                                <AlternatingItemStyle CssClass="Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF" />
                                                <Columns>
                                                    <asp:BoundColumn HeaderText="Cur Date" DataField="CurDate" SortExpression="CurDate" DataFormatString="{0:MM/dd/yyyy}">
                                                        <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Center" Width="75px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Branch" DataField="Branch">
                                                        <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Center" Width="50px" />
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderText="Item No" DataField="ItemNo">
                                                        <HeaderStyle CssClass="GridHead" Width="125px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Center" Width="125px" />
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderText="Qty On Hand" DataField="QOH" SortExpression="QOH" DataFormatString="{0:N0}">
                                                        <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                                        <ItemStyle HorizontalAlign="Right" Width="75px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Rcpt Qty" DataField="RcptQty" SortExpression="RcptQty" DataFormatString="{0:N0}">
                                                        <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="75px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Iss Qty" DataField="IssQty" SortExpression="IssQty" DataFormatString="{0:N0}">
                                                        <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="75px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Adj Qty" DataField="AdjQty" SortExpression="AdjQty" DataFormatString="{0:N0}">
                                                        <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="75px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Doc No" DataField="DocNo" SortExpression="DocNo">
                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Center" Width="100px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Parent Doc No" DataField="ParentDocNo" SortExpression="ParentDocNo">
                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Center" Width="100px" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Source ID" DataField="SourceID" SortExpression="SourceID">
                                                        <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Center" Width="75px" />
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
             var prtContent = "<html><head><link href='Common/StyleSheet/Styles.css' rel='stylesheet' type='text/css' /></head><body>"
             
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
