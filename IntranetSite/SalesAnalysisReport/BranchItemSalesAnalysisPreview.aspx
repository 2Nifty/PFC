<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BranchItemSalesAnalysisPreview.aspx.cs" Inherits="Sales_Analysis_Report_BranchItemSalesAnalysisPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Branch Item Sales Analysis Report</title>
   <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
   
   <Script> 
</Script>

</head>
<body  bottommargin="0" onload="javascript:print_header()">
    <form id="form1" runat="server">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td style="height: 23px" bgcolor=#EFF9FC>
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
    <td colspan="2" style="height: 314px">

    
    <table width="100%"  border="0" cellspacing="1" cellpadding="0">
        <tr>
            <td class="PageHead" colspan="2" valign="middle">
                <div id="PrintDG1">                  
                    <div align="left" class="LeftPadding">Branch Item Sales Analysis</div>
                </div>
            </td>
        </tr>
      <tr>
        <td colspan=2 align="center" class="PageBg">
        <div id="PrintDG2">              
            <table width=100% cellpadding=0 cellspacing=0>
                <tr>
                    <td  height="22px"  class=TabHead ><span class=LeftPadding>Period : <%=Request.QueryString["MonthName"].ToString() + " " + Request.QueryString["Year"].ToString()%></span></td>
                    <td  class=TabHead ><span class=LeftPadding>Branch : <%=Request.QueryString["BranchName"].ToString() %></span></td>
                    <td class=TabHead height="22px"><span class=LeftPadding>Category : </span><span>
                    <%=(Request.QueryString["CategoryFrom"] == "" && Request.QueryString["CategoryTo"] == "") ? "All" :Request.QueryString["CategoryFrom"].ToString()+" - " +Request.QueryString["CategoryTo"].ToString() %>
                    </span>
                    </td>
                    <td class=TabHead ><span class=LeftPadding>Variance : </span><span>
                    <%=(Request.QueryString["VarianceFrom"] == "" && Request.QueryString["VarianceTo"] == "") ? "All" : Request.QueryString["VarianceFrom"].ToString() + " - " + Request.QueryString["VarianceTo"].ToString()%>
                    </span></td>


                    <td align="Left" class="TabHead"><span class="LeftPadding">
                                        Run By : <%= Session["UserName"].ToString()%></span>
                                        </td>                    
                    <td align=right class=TabHead><span class=LeftPadding>Run Date : <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
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
                <asp:DataGrid ID=dgAnalysis  BackColor=#f4fbfd runat=server BorderColor="#c9c6c6" Width=2000px AutoGenerateColumns=false PagerStyle-Visible="false" OnItemDataBound="dgAnalysis_ItemDataBound"  BorderWidth=1 GridLines=both ShowFooter="true" >
                    <HeaderStyle CssClass="GridHead" BackColor="#dff3f9" />
                    <ItemStyle CssClass="GridItem" BackColor="#f4fbfd" />
                    <FooterStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9"   />
                    <AlternatingItemStyle CssClass=GridItem BackColor="#FFFFFF" />
                    <Columns>
                        <asp:BoundColumn HeaderText="Item" DataField="Item" SortExpression="Item" ItemStyle-Wrap=false FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="ItemDesc" DataField="ItemDesc" SortExpression="ItemDesc" ItemStyle-Wrap=false FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem>
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="UOM" DataField="UOM" SortExpression="UOM" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  HeaderStyle-Wrap=false></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_InvQty" DataFormatString="{0:#,##0}" DataField="CM_InvQty" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false 
                                                            SortExpression="CM_InvQty" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_sales" DataFormatString="{0:#,##0}" DataField="CM_sales" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  HeaderStyle-Wrap=false
                                                            SortExpression="CM_sales" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_GM$" DataFormatString="{0:#,##0}" DataField="CM_GM$" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CM_GM$" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_GMPer" DataFormatString="{0:0.0}" DataField="CM_GMPer" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CM_GMPer" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_SellWgt" DataFormatString="{0:#,##0}" DataField="CM_SellWgt" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false 
                                                            SortExpression="CM_SellWgt" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_Lb" DataFormatString="{0:0.00}" DataField="CM_Lb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CM_Lb" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_order" DataField="CM_order" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  HeaderStyle-Wrap=false
                                                            SortExpression="CM_order" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_InvQty" DataField="CY_InvQty" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_InvQty" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_InvQty" DataField="PY_InvQty" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_InvQty" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_Sales" DataField="CY_Sales" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_Sales" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_Sales" DataField="PY_Sales" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_Sales" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_GM$" DataField="CY_GM$" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_GM$" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_GM$" DataField="PY_GM$" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_GM$" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_GMPer" DataField="CY_GMPer" DataFormatString="{0:0.0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_GMPer" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_GMPer" DataField="PY_GMPer" DataFormatString="{0:0.0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_GMPer" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_Sellwgt" DataField="CY_Sellwgt" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_Sellwgt" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_Sellwgt" DataField="PY_Sellwgt" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_Sellwgt" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_Lb" DataField="CY_Lb" DataFormatString="{0:0.00}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_Lb" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_Lb" DataField="PY_Lb" DataFormatString="{0:0.00}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_Lb" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_Order" DataField="CY_Order" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead  ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_Order" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_Order" DataField="PY_Order" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead  ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_Order" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
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
  </tr><tr><td style="height: 20px" bgcolor=#EFF9FC ></td></tr>
 
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
