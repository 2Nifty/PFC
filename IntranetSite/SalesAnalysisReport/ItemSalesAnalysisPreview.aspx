<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemSalesAnalysisPreview.aspx.cs" Inherits="Sales_Analysis_Report_ItemSalesAnalysisPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Item Sales Analysis Report</title>
   <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
   <Script> 
</Script>

</head>
<body >
    <form id="form1" runat="server">
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td bgcolor=#EFF9FC style="height: 23px">
                </td>
                <td bgcolor=#EFF9FC style="height: 23px">
                    <div align="right">
                        <span>&nbsp;<img src="../Common/images/print.gif" style="cursor:hand"  onclick="javascript:CallPrint('PrintDG1','PrintDG2','PrintDG3');" />
                             <img src="../Common/images/close.gif" style="cursor:hand" onclick="javascript:window.close();" />
                            </span></div>                            
                            
                            
                </td>
            </tr>
        </table>   
    <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
  <tr valign="top">
    <td colspan="2" valign=top>
    
    <table width="100%"  border="0" cellspacing="1" cellpadding="0">
        <tr>
            <td class="PageHead" colspan="2" valign="middle">
            <div id="PrintDG1">
                <div align="left" class="LeftPadding">Item Sales Analysis</div>
            </div>
            </td>
        </tr>
        <tr><td colspan=2 align="center">
        <table width=100% cellpadding=0 cellspacing=0>
      <tr>
        <td colspan=2 align="center" class="PageBg">
        <div id="PrintDG2">
            <table width=100% cellpadding=0 cellspacing=0>
                <tr>
                    <td height="22px"  class=TabHead ><span class=LeftPadding>Period : <%=Request.QueryString["MonthName"].ToString() + " " + Request.QueryString["Year"].ToString()%></span></td>
                    <td height="15px" class="TabHead">
                        <span class=LeftPadding>Order Type :
                            <%=((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") %>
                        </span>
                    </td>
                    <td class=TabHead ><span class=LeftPadding>Branch : <%=Request.QueryString["BranchName"].ToString() %></span></td>
                    <%if (Request.QueryString["CustNo"].ToString() != "")
                      { %>
                        <td class=TabHead><span class=LeftPadding>Customer : <%=Request.QueryString["CustNo"].ToString()%> - <%=Request.QueryString["CustName"].ToString().Replace("|","'")%>  </span></td>
                    <%}
                      if (Request.QueryString["Chain"].ToString() != "")
                      { %>
                        <td class=TabHead><span class=LeftPadding>Chain : <%=Request.QueryString["Chain"].ToString()%> </span></td>
                    <%}%>
                    <td align="right" class="TabHead" width="200"><span class="LeftPadding">
                                        Run By : <%= Session["UserName"].ToString()%></span>
                                        </td>
                    <td width=130px align=right class=TabHead><span class=LeftPadding>Run Date : <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                </tr>
            </table>
            </div>
       </td>
    </tr>
      <tr>
        <td colspan="2"><table  width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="top" width="100%" align=left >
                
                <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px; left: 0px; bottom:0px; width: 1000px; height: 590px; border: 0px solid;">                                                             
                <div id="PrintDG3">                
                <asp:DataGrid ID=dgAnalysis  runat=server Width=2000px BorderColor="#c9c6c6" AutoGenerateColumns=false PagerStyle-Visible="false" BorderWidth=1 GridLines=both ShowFooter="true" OnItemDataBound="dgAnalysis_ItemDataBound">
                    <HeaderStyle CssClass="GridHead" BackColor="#dff3f9" />
                    <ItemStyle CssClass="GridItem" BackColor="#f4fbfd" />
                    <AlternatingItemStyle CssClass=GridItem BackColor="#FFFFFF" />
                    <Columns>
                         <asp:BoundColumn HeaderText="Item" DataField="Item" SortExpression="Item" ItemStyle-Width=100 ItemStyle-Wrap=false FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="ItemDesc" DataField="ItemDesc" SortExpression="ItemDesc" ItemStyle-Width=240 ItemStyle-Wrap=false FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="UOM" DataField="UOM" SortExpression="UOM" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="CM_InvQty" DataField="CM_InvQty" SortExpression="CM_InvQty" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="CM_sales" ItemStyle-Width=75px DataFormatString="{0:#,##0}" DataField="CM_sales" SortExpression="CM_sales" ItemStyle-HorizontalAlign="Right"  FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        
                        <asp:BoundColumn HeaderText="CM_GM$"  DataFormatString="{0:#,##0}" DataField="CM_GM$" SortExpression="CM_GM$" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="CM_GMPer"  DataFormatString="{0:0.0}" DataField="CM_GMPer" SortExpression="CM_GMPer" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="CM_SellWgt"   DataFormatString="{0:#,##0}" DataField="CM_SellWgt" SortExpression="CM_SellWgt" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="CM_Lb" ItemStyle-Width=50px DataFormatString="{0:0.00}" DataField="CM_Lb" SortExpression="CM_Lb"  ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="CM_order" DataFormatString="{0:#,##0}" DataField="CM_order"  SortExpression="CM_order" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        
                        <asp:BoundColumn HeaderText="CY_InvQty" DataFormatString="{0:#,##0}" DataField="CY_InvQty"  SortExpression="CY_InvQty" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="PY_InvQty" DataFormatString="{0:#,##0}" DataField="PY_InvQty"  SortExpression="PY_InvQty" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        
                        <asp:BoundColumn HeaderText="CY_Sales" DataField="CY_Sales" DataFormatString="{0:#,##0}"  SortExpression="CY_Sales" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="PY_Sales" DataField="PY_Sales" DataFormatString="{0:#,##0}"  SortExpression="PY_Sales" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        
                        <asp:BoundColumn HeaderText="CY_GM$" DataFormatString="{0:#,##0}" DataField="CY_GM$"  SortExpression="CY_GM$" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="PY_GM$" DataFormatString="{0:#,##0}" DataField="PY_GM$"  SortExpression="PY_GM$" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        
                        <asp:BoundColumn HeaderText="CY_GMPer" DataFormatString="{0:0.0}" DataField="CY_GMPer"  SortExpression="CY_GMPer" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="PY_GMPer" DataFormatString="{0:0.0}" DataField="PY_GMPer"  SortExpression="PY_GMPer" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        
                        <asp:BoundColumn HeaderText="CY_Sellwgt" DataFormatString="{0:#,##0}" DataField="CY_Sellwgt"  SortExpression="CY_Sellwgt" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="PY_Sellwgt" DataFormatString="{0:#,##0}" DataField="PY_Sellwgt"  SortExpression="PY_Sellwgt" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        
                        <asp:BoundColumn HeaderText="CY_Lb" DataFormatString="{0:0.00}" DataField="CY_Lb"  SortExpression="CY_Lb" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="PY_Lb"  DataFormatString="{0:0.00}" DataField="PY_Lb"  SortExpression="PY_Lb" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        
                        <asp:BoundColumn HeaderText="CY_Order" DataField="CY_Order"  SortExpression="CY_Order" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="PY_Order" DataField="PY_Order"  SortExpression="PY_Order" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                        
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
