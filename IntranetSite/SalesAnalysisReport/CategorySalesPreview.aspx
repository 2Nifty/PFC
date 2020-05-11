<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CategorySalesPreview.aspx.cs" Inherits="SalesAnalysisReport_ReportPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Preview</title>
    <link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
</head>
<body  >
 <form id="form1" runat="server">
 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td bgcolor=#EFF9FC style="height: 23px">
                </td>
                <td bgcolor=#EFF9FC style="height: 23px">
                
                    <div align="right">
                        <span>&nbsp;<img style="cursor:hand"  src="../Common/images/print.gif"  onclick="javascript:CallPrint('PrintDG1','PrintDG2','PrintDG3');" />
                             <img style="cursor:hand"  src="../Common/images/close.gif"  onclick="javascript:window.close();" />
                            </span></div>                            
                </td>
            </tr>
        </table>      
 
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2">
    <table width="100%"  border="0" cellspacing="1" cellpadding="0">
      <tr>
        <td colspan="2" valign="middle" class="PageHead">
        <div id="PrintDG1">
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td style="height: 26px"><div align="left" class="LeftPadding">Category Sales Analysis</div></td>
                </tr>
            </table>
            </div>
        </td>
      </tr>
      <tr>
        <td colspan=2 align="left" class="PageBg">
        <div id="PrintDG2">
        <table width=100% cellpadding=0 cellspacing=0>
                <tr>
                    <td class=TabHead height="22px"><span class=LeftPadding>Category : </span><span>
                    <%=(Request.QueryString["CategoryFrom"] == "" && Request.QueryString["CategoryTo"] == "") ? "All" :Request.QueryString["CategoryFrom"].ToString()+" - " +Request.QueryString["CategoryTo"].ToString() %>
                    </span>
                    </td>
                    <td class=TabHead ><span class=LeftPadding>Variance : </span><span>
                    <%=(Request.QueryString["VarianceFrom"] == "" && Request.QueryString["VarianceTo"] == "") ? "All" : Request.QueryString["VarianceFrom"].ToString() + " - " + Request.QueryString["VarianceTo"].ToString()%>
                    </span></td>
                    <td class=TabHead ><span class=LeftPadding>Fiscal Period : </span><span><%=Request.QueryString["Period"].ToString()%></span></td>
                    <td align="left" class="TabHead"><span class="LeftPadding">Run By : <%= Session["UserName"].ToString()%></span>
                    </td>                                        

                    <td class=TabHead ><span class=LeftPadding>Run Date : </span><span><%=DateTime.Now.ToShortDateString()%></span></td>
                </tr>
            </table>
        </div>
        </td>    </tr>
      <tr>
        <td colspan="2" id=tdGrid runat=server>
        <table class="BluBordAll" width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="top">
                  <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px; left: 0px; bottom:0px; width: 1010px; height: 590px; border: 0px solid;">                                                             
                  <div id="PrintDG3">
                    <asp:DataGrid ShowHeader=false PagerStyle-Visible=false BorderColor=#c9c6c6  ID=dgReport AllowSorting=true AllowPaging=false AutoGenerateColumns=false BorderWidth=1  runat=server   GridLines=both>
                    <HeaderStyle CssClass=GridHead BackColor="#DFF3F9" HorizontalAlign="right"/>
                        <Columns>
                            <asp:TemplateColumn>
                                <ItemTemplate>
                                    <table cellpadding=0 cellspacing=0 border=0>
                                        <tr runat=server id=trHead bgcolor="#F4FBFD"><td class=TabHead height=20 width="100%">
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID=lblHead Text="Category :" runat=server CssClass=TabHead></asp:Label>
                                             <asp:Label CssClass=TabHead ID=lblCategory runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Category")%>'></asp:Label>&nbsp;
                                                 <asp:Label ID=lblItemDescription CssClass=TabHead  runat=server Text='<%#GetDescription(Container)%>'></asp:Label>
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td colspan=2 align=left>                                               
                                                <asp:DataGrid width="910px" AutoGenerateColumns=false ID=dgAnalysis runat=server BorderWidth=1 OnItemCreated="dgAnalysis_ItemCreated" OnItemDataBound="dgAnalysis_ItemDataBound" ShowFooter="True" GridLines=both BorderColor="#c9c6c6">
                                                <HeaderStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                                <ItemStyle CssClass="GridItem" BorderStyle=Solid Wrap=false BackColor="#f4fbfd" />
                                                <FooterStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                                <AlternatingItemStyle CssClass="GridItem"  BackColor="#FFFFFF" />
                                                <Columns>
                                                   <asp:BoundColumn HeaderText="Brn" DataField="Brn"  SortExpression="Brn" HeaderStyle-HorizontalAlign=right FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Category" DataField="Category" SortExpression="Category" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false> </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CM_YYSales" DataFormatString="{0:#,##0}" DataField="CM_YYSales" SortExpression="CM_YYSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CM_GMPer"  DataField="CM_GMPer" SortExpression="CM_GMPer" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CM_Total" ItemStyle-Width=90  DataField="CM_Total" SortExpression="CM_Total" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>                                                    
                                                    <asp:BoundColumn HeaderText="CM_LB"  DataField="CM_LB" DataFormatString="{0:0.00}" SortExpression="CM_LB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CM_GMLB" DataField="CM_GMLB" DataFormatString="{0:0.00}" SortExpression="CM_GMLB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CY_YYSales" DataFormatString="{0:#,##0}" DataField="CY_YYSales" SortExpression="CY_YYSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CY_GMPer"  DataField="CY_GMPer" SortExpression="CY_GMPer" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CY_Tot"   ItemStyle-Width=120 DataField="CY_Tot" SortExpression="CY_Tot" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CY_LB" DataField="CY_LB" DataFormatString="{0:0.00}" SortExpression="CY_LB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CY_GMLB" DataField="CY_GMLB" DataFormatString="{0:0.00}" SortExpression="CY_GMLB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>                                                    
                                                    <asp:BoundColumn HeaderText="PY_YYSales" DataFormatString="{0:#,##0}" DataField="PY_YYSales"  SortExpression="PY_YYSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="PY_GMPer" DataField="PY_GMPer"  SortExpression="PY_GMPer" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="PY_Total" ItemStyle-Width=120 DataField="PY_Total" SortExpression="PY_Total" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="PY_LB" DataField="PY_LB" DataFormatString="{0:0.00}" SortExpression="PY_LB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="PY_GMLB" DataField="PY_GMLB" DataFormatString="{0:0.00}" SortExpression="PY_GMLB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                </Columns>
                                                </asp:DataGrid>         
                                                
                                            
                                            </td>
                                        </tr>
                                        <tr bgcolor="#F4FBFD"><td colspan=4 height=20></td></tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <PagerStyle Visible="False" />
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
        //function print_header() 
            // { 
            // var table = document.getElementById("dgAnalysis"); // the id of your DataGrid
            // var str = table.outerHTML; 
            // str = str.replace(/<TBODY>/i, ""); 
            // str = str.replace(/<TR/i, "<THEAD style='display:table-header-group;'><TR"); 
            // str = str.replace(/<\/TR>/i, "</TR></THEAD><TBODY>"); 
            //table.outerHTML = str; 
        //} 
</script>
</html>
