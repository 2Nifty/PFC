<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DocumentSalesAnalysisPreview.aspx.cs" Inherits="Sales_Analysis_Report_DocumentSalesAnalysisPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Document Sales Analysis Report</title>
   <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
   <Script> 

</Script>

</head>
<body bottommargin="0" onload="javascript:print_header()">
    <form id="form1" runat="server">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td >
                </td>
                <td bgcolor=#EFF9FC style="height: 23px">
                <div align="right">
                        <span>&nbsp;<img src="../Common/images/print.gif" style="cursor:hand" onclick="javascript:CallPrint('PrintDG1','PrintDG2','PrintDG3');" />
                             <img src="../Common/images/close.gif" style="cursor:hand" onclick="javascript:window.close();" />
                            </span>
                </div>                            
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
                <div align="left" class="LeftPadding">Document Sales Analysis</div>
            </div>
            </td>
        </tr>
      <tr>
        <td colspan=2 align="center" class="PageBg">
        
        <div id="PrintDG2">
          <table width=100% cellpadding=0 cellspacing=0>
                <tr>
                    <td class=TabHead style="height: 22px" ><span >Period : <%=Request.QueryString["MonthName"].ToString() + " " + Request.QueryString["Year"].ToString()%></span></td>
                    <td height="15px" class="TabHead">
                                            <span>Order Type :
                                                <%=((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") %>
                                            </span>
                                        </td>
                    <td class=TabHead style="height: 22px" ><span >Branch : <%=Request.QueryString["Branch"].ToString() %></span></td>
                    <%if (Request.QueryString["CustNo"].ToString() != "")
                      { %>
                        <td class=TabHead style="height: 22px"><span >Customer Number : <%=Request.QueryString["CustNo"].ToString()%> </span></td>
                    <%}
                      else if (Request.QueryString["Chain"].ToString() != "")
                      { %>
                        <td class=TabHead style="height: 22px"><span >Chain : <%=Request.QueryString["Chain"].ToString().Replace('`','&')%> </span></td>
                    <%}%>
                    <td class="TabHead">
                                        <span class="LeftPadding">Sales Rep :
                                               <%=(Request.QueryString["SalesRep"] != "") ? Request.QueryString["SalesRep"].ToString().Replace("|", "'") : "All"%> 
                                            </span>
                                        </td>
                                        <td class=TabHead ><span class=LeftPadding>Zip : </span><span>
                    <%=(Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()%>
                    </span></td>
                    <td class=TabHead style="height: 22px" ><span>Item : <%=Request.QueryString["Item"].ToString() %></span></td>
                    <td align="left" class="TabHead" style="height: 22px" >Run By : <%= Session["UserName"].ToString()%>
                    </td>
                    <td align=left class=TabHead style="height: 22px"><span class=LeftPadding>Run Date : <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                </tr>
            </table>
            </div>
        </td>
    </tr>
      <tr>
        <td colspan="2"><table class="BluBordAll" width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="top" width="100%" >
                
                <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px; left: 0px; bottom:0px; width: 1000px; height: 590px; border: 0px solid;">                                                             
                <div id="PrintDG3">                
                <asp:DataGrid ID=dgAnalysis  BackColor=#f4fbfd runat=server BorderColor="#c9c6c6" Width=2000px AutoGenerateColumns=false PagerStyle-Visible="false" BorderWidth=1 GridLines=both OnItemDataBound="dgAnalysis_ItemDataBound" ShowFooter="true">
                    <HeaderStyle CssClass="GridHead" BackColor="#dff3f9" />
                    <ItemStyle CssClass="GridItem" BackColor="#f4fbfd" />
                    <AlternatingItemStyle CssClass=GridItem BackColor="#FFFFFF" />
                        <Columns>
                            <asp:BoundColumn HeaderText="SO#" DataField="SO#" SortExpression="SO#" ItemStyle-Wrap=false HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="INV#" DataField="INV#" SortExpression="INV#" ItemStyle-Wrap=false HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="TYPE" DataField="TYPE" SortExpression="TYPE" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="Date" DataField="Date" SortExpression="Date" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="Sale Brn" DataField="Sale Brn" SortExpression="Sale Brn" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="Ship Brn" DataField="Ship Brn" SortExpression="Ship Brn" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="Salesperson" DataField="Salesperson" SortExpression="Salesperson" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="Qty" DataField="Qty" SortExpression="Qty"  ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="Price Per Unit $"  DataFormatString="{0:#,##0}" DataField="Price Per Unit"  SortExpression="Price Per Unit" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="Cost Per Unit $" DataFormatString="{0:#,##0}"  DataField="Cost Per Unit" SortExpression="Cost Per Unit" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="ExtPrice $" DataFormatString="{0:#,##0}"  DataField="ExtPrice"  SortExpression="ExtPrice" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="ExtGM$" DataFormatString="{0:#,##0}"  DataField="ExtGM$" SortExpression="ExtGM$" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="GM%"  DataFormatString="{0:0.0}" DataField="GM%" SortExpression="GM%" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="Wgt Per Unit"  DataFormatString="{0:#,##0}" DataField="Wgt Per Unit" SortExpression="Wgt Per Unit" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="ExtWgt"  DataFormatString="{0:#,##0}" DataField="ExtWgt" SortExpression="ExtWgt" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="$/Lb"  DataFormatString="{0:0.00}" DataField="$/Lb" SortExpression="$/Lb" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="Cust PO" DataField="Cust PO" SortExpression="Cust PO" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                    </Columns>                    
                </asp:DataGrid>        
    </div>
    </div>                
              </td>
            </tr>
        </table></td>
      </tr>
    </table>

	  </td>
  </tr><tr><td bgcolor=#EFF9FC  style="height: 20px"></td></tr>
 
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
            var table = document.getElementById("dgAnalysis"); // the id of your DataGrid
            var str = table.outerHTML; 
            str = str.replace(/<TBODY>/i, ""); 
            str = str.replace(/<TR/i, "<THEAD style='display:table-header-group;'><TR"); 
            str = str.replace(/<\/TR>/i, "</TR></THEAD><TBODY>"); 
            table.outerHTML = str; 
        } 
</script>
</html>
