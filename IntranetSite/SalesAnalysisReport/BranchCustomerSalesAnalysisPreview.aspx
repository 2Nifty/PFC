<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BranchCustomerSalesAnalysisPreview.aspx.cs" Inherits="Sales_Analysis_Report_BranchCustomerSalesAnalysisPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Branch Customer Sales Analysis Report</title>
   <link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
   <Script> 
</Script>

</head>
<body bottommargin="0" onload="javascript:print_header()">
    <form id="form1" runat="server">
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td style="height: 23px">
                </td>
                <td bgcolor=#EFF9FC style="height: 23px">
                    <div align="right">
                        <span>&nbsp;<img src="../Common/images/print.gif" style="cursor:hand"  onclick="javascript:CallPrint('PrintDG1','PrintDG2');" />
                             <img src="../Common/images/close.gif" style="cursor:hand" onclick="javascript:window.close();" />
                            </span></div>                            
                </td>
            </tr>
        </table>    
    <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
  <tr valign="top">
    <td colspan="2" valign=top >
    <table width="100%"  border="0" cellspacing="1" cellpadding="0">
        <tr>
            <td class="PageHead" colspan="2" valign="middle">
             <div id="PrintDG1">
                    <div align="left" class="LeftPadding">Branch Customer Sales Analysis</div>
            </div>
            </td>
        </tr>
        <tr>
        <td><div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px; left: 0px; bottom:0px; width: 1000px;height:620px; border: 0px solid;">                                                             
                  <div id="PrintDG2">   <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        
                       
        
      <tr>
        <td colspan=2 align="center" class="PageBg">
            <table width="100%" cellpadding="0" cellspacing="0" >
                <tr>
                   <td height="22px" class="TabHead"><span class="LeftPadding">Period : <%=Request.QueryString["MonthName"].ToString() + " " + Request.QueryString["Year"].ToString()%></span></td>
                                        <td class="TabHead">
                                            <span class="LeftPadding">Branch :
                                                <%=Request.QueryString["BranchName"].ToString() %>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span class="LeftPadding">Item :
                                                <%=Request.QueryString["Item"].ToString() %>
                                            </span>
                                        </td>

                                        <td class="TabHead">
                                            <span class="LeftPadding">Fiscal Year :
                                                <% if (Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) %>
                                                <%{ %>
                                                <%=Request.QueryString["Year"].ToString()%>
                                                Vs
                                                <%=Convert.ToInt16(Request.QueryString["Year"].ToString()) - 1%>
                                                <%}
                                                else
                                                {%>
                                                <%=Convert.ToInt16(Request.QueryString["Year"].ToString()) + 1%>
                                                        Vs
                                                <%=Request.QueryString["Year"].ToString()%>
                                                <%} %>
                                            </span>
                                        </td>
                                        <td align="left" class="TabHead"><span class="LeftPadding">
                                        Run By : <%= Session["UserName"].ToString()%></span>
                                        </td>                                        
                                        <td align="left" class="TabHead">
                                            <span class="LeftPadding">Run Date : <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                </tr>
            </table>
        </td>
    </tr>
      <tr>
        <td colspan="2"><table class="BluBordAll" width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="top" width="100%" >
                
                <asp:DataGrid ID=dgAnalysis  BackColor=#f4fbfd runat=server BorderColor="#c9c6c6" Width=2000px AutoGenerateColumns=false PagerStyle-Visible="false"  BorderWidth="1" GridLines=Both ShowFooter="true" OnItemDataBound="dgAnalysis_ItemDataBound">
                    <HeaderStyle CssClass="GridHead" BackColor="#dff3f9" />
                    <ItemStyle CssClass="GridItem" BackColor="#f4fbfd" />
                    <FooterStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                    <AlternatingItemStyle CssClass=GridItem BackColor="#FFFFFF" />
                         <Columns>
                            <asp:BoundColumn HeaderText="CustNo" DataField="CustNo" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem SortExpression="CustNo" ItemStyle-Wrap=false FooterStyle-Wrap=false HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustName" DataField="CustName" SortExpression="CustName" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem ItemStyle-Wrap=false HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustCity" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem       DataField="CustCity" SortExpression="CustCity" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="SalesLoc" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataField="SalesLoc" SortExpression="SalesLoc" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Chain"    FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataField="Chain" SortExpression="Chain" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMSales"  FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:#,##0}" DataField="CMSales" SortExpression="CMSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMSales"  FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:#,##0}" DataField="LMSales" SortExpression="LMSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CGM"      FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:#,##0}" DataField="CGM" SortExpression="CGM"  ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CGMPct"   FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:0.0}" DataField="CGMPct"  SortExpression="CGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMGM"     FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:#,##0}" DataField="LMGM" SortExpression="LMGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMGMPct"  FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:0.0}" DataField="LMGMPct"  SortExpression="LMGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMWgt"    FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:#,##0}"  DataField="CMWgt" SortExpression="CMWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:0.00}" DataField="CMDollarLb" SortExpression="CMDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMWgt"      FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}"  DataField="LMWgt" SortExpression="LMWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:0.00}"  DataField="LMDollarLb" SortExpression="LMDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDSales"   FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}"  DataField="YTDSales" SortExpression="YTDSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDSales"  FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}" DataField="LYTDSales" SortExpression="LYTDSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDGM"      FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}"  DataField="YTDGM" SortExpression="YTDGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDGMPct"   FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:0.0}" DataField="YTDGMPct" SortExpression="YTDGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDGM"     FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}"  DataField="LYTDGM" SortExpression="LYTDGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDGMPct"  FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:0.0}"  DataField="LYTDGMPct" SortExpression="LYTDGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDWgt"     FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}"  DataField="YTDWgt" SortExpression="YTDWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem   DataFormatString="{0:0.00}"  DataField="YTDDollarLb" SortExpression="YTDDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDWgt"     FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem   DataFormatString="{0:#,##0}" DataField="LYTDWgt" SortExpression="LYTDWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  DataFormatString="{0:0.00}" DataField="LYTDDollarLb" SortExpression="LYTDDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustRep"      FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  DataField="CustRep" SortExpression="CustRep" ItemStyle-HorizontalAlign="left" ItemStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustGroup"    FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  DataField="CustGroup" SortExpression="CustGroup" ItemStyle-HorizontalAlign="left" ItemStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Zip"          FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  DataField="CustZip" SortExpression="CustZip" ItemStyle-HorizontalAlign="left" ItemStyle-Wrap=false></asp:BoundColumn>
                          </Columns>                    
                </asp:DataGrid>        
                
              </td>
            </tr>
        </table></td>
      </tr>
      
     
      </table> </div>
      </div>
      </td>
      </tr>

    </table>
	  </td>
  </tr><tr><td style="height: 20px" bgcolor=#EFF9FC ></td></tr>
 
</table>
</form>
</body>
<script>
function CallPrint(strid1,strid2)
        {
             var prtContent = "<html><head><link href='StyleSheet/Styles.css' rel='stylesheet' type='text/css' /></head><body>"
             prtContent = prtContent + document.getElementById(strid1).innerHTML;
             prtContent = prtContent + document.getElementById(strid2).innerHTML;
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
            var table = document.getElementById("dgAnalysis"); // the id of your DataGrid
            var str = table.outerHTML; 
            str = str.replace(/<TBODY>/i, ""); 
            str = str.replace(/<TR/i, "<THEAD style='display:table-header-group;'><TR"); 
            str = str.replace(/<\/TR>/i, "</TR></THEAD><TBODY>"); 
            table.outerHTML = str; 
        } 
</script>
</html>
