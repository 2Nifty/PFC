<%@ Page Language="C#" AutoEventWireup="true" CodeFile="eCommerceQuoteAndOrderPreview.aspx.cs"
    Inherits="eCommerceQuoteAndOrderPreview" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>eCommerce Quote and Order Report Preview</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
   
</head>
<body onload="javascript:print_header()">
    <form id="form1" runat="server">
        <div id="pagePrint">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="100%" height="100%" valign="top">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="PageHead" colspan="4" style="height: 40px">
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td class="Left5pxPadd BannerText"  width=90%>
                                            <asp:Label Text="eCommerce Quote and Order Report" style="word-wrap:normal" ID="lblReportCap" runat=server Width="350px"></asp:Label>                                                
                                            </td>
                                            <td valign="middle"  align="right">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td align="right" width="70%" style="padding:5px;">
                                                            <img onclick="javascript:PrintReport('trHead','PrintDG2');" src="../Common/Images/Print.gif"
                                                                style="cursor: hand" id="IMG1" /></td>
                                                        <td align="left" width="30%">
                                                            <img src="Common/Images/Buttons/Close.gif" style="cursor: hand" onclick="javascript:window.close();" /></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                   <tr id="trHead" class="PageBg" >
              <td><table cellpadding=1 cellspacing=0 width="100%"><tr><td class="LeftPadding TabHead" style="width:130px">
                                Customer # :
                                <%=(Request.QueryString["CustNo"].ToString() == "") ? "All" : Request.QueryString["CustNo"].ToString()%>
                            </td>
                             <td class="LeftPadding TabHead" style="width:180px">
                             Branch :
                                <%=Request.QueryString["BranchName"].ToString()%>
                             </td>
                             <td class="TabHead"  style="width:200px">
                               Period :
                                <%=Request.QueryString["MonthName"].ToString()%><%=Request.QueryString["StartDate"].ToString()%> -  <%=Request.QueryString["Year"].ToString()%><%=Request.QueryString["EndDate"].ToString()%>
                            </td>
                            <td>&nbsp;</td>
                            <td class="TabHead" style="width:130px">
                                Run By : <%= Session["UserName"].ToString() %>
                            </td>
                            <td class="TabHead" style="width:130px">
                                Run Date : <%=DateTime.Now.ToShortDateString()%>
                            </td></tr>
                  <tr>
                      <td class="LeftPadding TabHead" colspan=2>
                            CSR Name: <%=Request.QueryString["RepName"].ToString()%>
                      </td>
                      <td class="TabHead" style="width: 200px">
                      </td>
                      <td>
                      </td>
                      <td class="TabHead" style="width: 130px">
                      </td>
                      <td class="TabHead" style="width: 130px">
                      </td>
                  </tr>
              </table></td>
                            
                        </tr> 
                <tr>
                    <td >
                        <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
                            position: relative; top: 0px; left: 0px; width: 100%; height: 575px; border: 0px solid;">
                            <div id="PrintDG2">
                                <asp:DataGrid ID="dgQuote2Order" BackColor="#f4fbfd" runat="server" 
                                AutoGenerateColumns="false" ShowFooter="true" PagerStyle-Visible="false" BorderWidth="1"
                                GridLines="both" BorderColor="#c9c6c6" OnItemDataBound="dgQuote2Order_ItemDataBound">
                                <HeaderStyle HorizontalAlign="center" Height=25px CssClass="GridHead" BackColor="#DFF3F9" />
                                <ItemStyle CssClass="GridItem" BackColor="#F4FBFD" />
                                <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" Height=20px BackColor="#DFF3F9" />
                                    <Columns>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="left" HeaderText="Cust #" FooterStyle-HorizontalAlign=center
                                        DataField="customerNumber" SortExpression="customerNumber" ItemStyle-Wrap="false" HeaderStyle-Width="40"
                                        ItemStyle-Width="40" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="Left" HeaderText="Name"
                                            FooterStyle-HorizontalAlign="Left" DataField="CustomerName"
                                            SortExpression="CustomerName" ItemStyle-Wrap="false" HeaderStyle-Width="100" ItemStyle-Width="200" HeaderStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn HeaderStyle-Width="20" ItemStyle-HorizontalAlign="left" HeaderText="Brn" FooterStyle-HorizontalAlign="right"
                                        DataField="SalesLocationCode" SortExpression="SalesLocationCode" ItemStyle-Wrap="false"
                                        ItemStyle-Width="20" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="# of Quotes"
                                            FooterStyle-HorizontalAlign="right" DataField="NoOfQuotes" DataFormatString="{0:#,##0}"
                                            SortExpression="NoOfQuotes" ItemStyle-Wrap="false" HeaderStyle-Width="35" ItemStyle-Width="35" HeaderStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="Extended $ Amnt"
                                            FooterStyle-HorizontalAlign="right" DataField="ExtAmount" DataFormatString="{0:#,##0.00}"
                                            SortExpression="ExtAmount" ItemStyle-Wrap="false" HeaderStyle-Width="100" ItemStyle-Width="100" HeaderStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="Extended Weight"
                                            FooterStyle-HorizontalAlign="right" DataField="ExtWeight" DataFormatString="{0:#,##0.00}"
                                            SortExpression="ExtWeight" ItemStyle-Wrap="false" HeaderStyle-Width="100" ItemStyle-Width="100" HeaderStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="# of Orders"
                                            FooterStyle-HorizontalAlign="right" DataField="NoOfOrders" DataFormatString="{0:#,##0}"
                                            SortExpression="NoOfOrders" ItemStyle-Wrap="false" HeaderStyle-Width="35" ItemStyle-Width="35" HeaderStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="Extended $ Amnt" FooterStyle-HorizontalAlign="right"
                                        DataField="ExtOrdAmount" DataFormatString="{0:#,##0.00}" SortExpression="ExtOrdAmount" ItemStyle-Wrap="false"
                                        ItemStyle-Width="100" HeaderStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="right" HeaderText="Extended Weight" FooterStyle-HorizontalAlign="right"
                                        DataField="ExtOrdWeight" DataFormatString="{0:#,##0.00}" SortExpression="ExtOrdWeight" ItemStyle-Wrap="false"
                                        ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <center>
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></center>
                            </div>
                        </div>
                        <input type="hidden" runat="server" id="hidSort" /></td>
                </tr>
                <tr>
                    <td >
                        <uc1:Footer ID="Footer1" runat="server" />
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
     var prtContent = "<html><head><link href='common/StyleSheet/stylesheet.css' rel='stylesheet' type='text/css' /></head><body>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='70%'><tr><td style='width:350px;'colspan=3><h3>eCommerce Quote and Order Report</h3></td></tr>";
     prtContent = prtContent +"</table><br>"; 
     prtContent = prtContent + document.getElementById(strid1).innerHTML; 
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
    var table = document.getElementById("dgQuote2Order"); // the id of your DataGrid
    var str = table.outerHTML; 
  //  alert(str);
      str = str.replace(/<TBODY>/g, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
} 
</script>

