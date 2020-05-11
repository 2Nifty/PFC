<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CategoryTrendPreview.aspx.cs" Inherits="SalesAnalysisReport_ReportPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Preview</title>
    
    <link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    
</head>
<body >
    <form id="form1" runat="server">
        <table  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td colspan="2"><table   border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td colspan="2" valign="middle" class="PageHead">
                <table  border="0" cellspacing="0" cellpadding="0" width=100%>
                    <tr>
                      
                      <td style="height: 26px" width=100% align="right">
                        <div align="right" >
                            <img style="cursor:hand"  src="../Common/images/print.gif"  onclick="javascript:CallPrint('PrintDG1','PrintDG2','PrintDG3');" />
                              <img style="cursor:hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:window.close();"/>
                             
                        </div>
                        </td>
                    </tr>
                </table>
            </td>
          </tr>
            <tr>
            <td >    
            
            <table  border="0" cellspacing="1" cellpadding="0">
              <tr>
                <td colspan="2" valign="middle" class="PageHead">
                    <table   border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td>
                          <div id="PrintDG1">
                            <div align="left" class="LeftPadding">Category Trend Analysis Report</div>
                          </div>
                          </td>
                        </tr>
                    </table>
                </td>
              </tr>
      <tr>
              <td>
              <table width=100% cellpadding=0 cellspacing=0>
            <tr>
                <td align="center" class="PageBg">
                <div id="PrintDG2">
                <table width=100% cellpadding=0 cellspacing=0>
                <tr>
                     <td class=TabHead height="22px"><span>Category : <%=(Request.QueryString["CategoryFrom"] == "" && Request.QueryString["CategoryTo"] == "") ? "All" :Request.QueryString["CategoryFrom"].ToString()+" - " +Request.QueryString["CategoryTo"].ToString() %>
                    </span>
                    </td>
                    <td class=TabHead >&nbsp;&nbsp;<span>Variance : 
                    <%=(Request.QueryString["VarianceFrom"] == "" && Request.QueryString["VarianceTo"] == "") ? "All" : Request.QueryString["VarianceFrom"].ToString() + " - " + Request.QueryString["VarianceTo"].ToString()%>
                    </span></td>

                    <td class=TabHead >&nbsp;&nbsp;<span>Branch : <%=Request.QueryString["Branch"].ToString() %></span></td>
                    <td class=TabHead >&nbsp;&nbsp;<span>Fiscal Period : <%=Request.QueryString["Period"].ToString()%></span></td>
                    <td align="left" class="TabHead">&nbsp;&nbsp;<span>
                    Run By : <%= Session["UserName"].ToString()%></span>
                    </td>                                        
                    <td align="left" class="TabHead">&nbsp;&nbsp;
                        <span>Run Date : <%=DateTime.Now.ToShortDateString()%></span></td>
                    
                    
                </tr>
            </table>
            </div>
            </td>
            </tr>
    <tr><td colspan=2 align=center><asp:Label ID=lblMsg ForeColor=red Visible=true runat=server CssClass="TabHead" Text="No Records Found"></asp:Label></td></tr>
      <tr>
        <td colspan="2" id=tdGrid runat=server><table class="BluBordAll"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="top">
                
                <div id=div-datagrid class="Sbar" style="overflow: auto; position: relative; top: 0px; left: 0px;
                                                width: 835px; height: 575px; border: 0px solid;">
                <div id="PrintDG3">
                    <asp:DataGrid ShowHeader=false PagerStyle-Visible=false BorderColor="#c9c6c6"  ID=dgReport  AutoGenerateColumns=false BorderWidth=1 GridLines=both  runat=server >
                        <Columns>
                            <asp:TemplateColumn>
                                <ItemTemplate>
                                    <table width=100% cellpadding=0 cellspacing=0 >
                                        <tr bgcolor="#F4FBFD"><td colspan=4 height=5></td></tr>
                                        <tr bgcolor="#F4FBFD"><td width=7% class=TabHead height=18>Category :</td><td width=25%><asp:Label CssClass=cnt ID=lblCategory runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Category")%>'></asp:Label>&nbsp;<asp:Label CssClass=cnt ID=lblItemDescription runat=server Text='<%#GetDescription(Container)%>'></asp:Label></td>
                                        <td width=7% class=TabHead height=18>Plating &nbsp;&nbsp;&nbsp;&nbsp;:</td><td ><asp:Label CssClass=cnt ID=lblPlating runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Plating")%>'></asp:Label><span class=cnt>-</span><asp:Label CssClass=cnt ID=lblPlatingDescription runat=server Text='<%#DataBinder.Eval(Container,"DataItem.PlatingDescription")%>'></asp:Label></td></tr>
                                        <tr bgcolor="#F4FBFD"><td width=7% class=TabHead height=18>Branch &nbsp;&nbsp;&nbsp;&nbsp;:</td ><td><asp:Label CssClass=cnt ID=lblBranch runat=server Text='<%#Request.QueryString["Branch"].ToString()%>'></asp:Label></td>
                                        <td width=7% class=TabHead height=18>Variance :</td><td ><asp:Label CssClass=cnt ID=lblVariance runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Variance")%>'></asp:Label></td></tr>
                                        <tr>
                                            <td colspan=4 align=left>                                                
                                                <asp:DataGrid ID=dgAnalysis runat=server BorderWidth=1 GridLines=Both  AutoGenerateColumns=false OnItemDataBound="dgAnalysis_ItemDataBound">
                                                <HeaderStyle CssClass=GridHead BackColor=#dff3f9 BorderStyle=Solid BorderWidth=1px  />
                                                <ItemStyle CssClass=GridItem BackColor="#f4fbfd" BorderStyle=Solid BorderWidth=1px/>
                                                <AlternatingItemStyle CssClass=GridItem BackColor=#FFFFFF BorderWidth=0 />
                                                    <Columns>                                                    
                                                        <asp:TemplateColumn HeaderText="Period"  ItemStyle-HorizontalAlign="left" ItemStyle-Width=100px FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate>
                                                            <asp:Label ID=lblPeriod runat=server Text='<%#GetText(Container) %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn  HeaderText="Qty" ItemStyle-HorizontalAlign="right" SortExpression=Qty FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate>
                                                                <asp:Label ID=lblQty runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Qty","{0:#,###}")%>'></asp:Label>
                                                                <asp:Label ID=lblFiscalMonth runat=server Visible=false Text='<%#DataBinder.Eval(Container,"DataItem.FiscalMonth") %>'></asp:Label>
                                                                <asp:Label ID=lblFiscalYear runat=server Visible=false Text='<%#DataBinder.Eval(Container,"DataItem.FiscalYear") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn HeaderText="Sales" ItemStyle-HorizontalAlign="right" SortExpression=Sales FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblSales runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Sales","{0:#,###}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn HeaderText="Cost" ItemStyle-HorizontalAlign="right" SortExpression=Cost FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblPeriod runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Cost","{0:#,###}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn HeaderText="GM%" HeaderStyle-Width=50px ItemStyle-HorizontalAlign="right" SortExpression=GM FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblCost runat=server Text='<%#DataBinder.Eval(Container,"DataItem.GM","{0:0.0}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn HeaderStyle-Width=90px HeaderText="% Of Total Sales" ItemStyle-HorizontalAlign="right" SortExpression=Totsales FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblSales1 runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Totsales","{0:0.0}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn HeaderText="Ext Wgt" ItemStyle-Width=60px ItemStyle-HorizontalAlign="right" SortExpression=ExtWgt FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblExtWgt runat=server Text='<%#DataBinder.Eval(Container,"DataItem.ExtWgt","{0:#,###}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn HeaderText="Sell $/Lb" HeaderStyle-Width=70px ItemStyle-HorizontalAlign="right" SortExpression=SellLb ItemStyle-Width=70px FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblSellLb runat=server Text='<%#DataBinder.Eval(Container,"DataItem.SellLb","{0:0.00}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn HeaderText="Cost $/Lb" HeaderStyle-Width=70px ItemStyle-HorizontalAlign="right" SortExpression=CostLb ItemStyle-Width=70px FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblCostLb runat=server Text='<%#DataBinder.Eval(Container,"DataItem.CostLb","{0:0.00}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn HeaderStyle-Width=70px  HeaderText="GM $/Lb" ItemStyle-HorizontalAlign="right" SortExpression=GMLb FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblGMLb runat=server Text='<%#DataBinder.Eval(Container,"DataItem.GMLb","{0:0.00}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                    </Columns>
                                            </asp:DataGrid>       
                                            <asp:Label ID=lblMessage runat=server Text="No Records Found" CssClass=GridHead ForeColor=red Visible=true></asp:Label>
                                            </td>
                                        </tr>
                                        <tr><td colspan=4 bgcolor=#dff3f9 height=20></td></tr>
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
     <tr><td> <asp:HiddenField ID="hidEndDate" runat="server" /><asp:HiddenField ID="hidVersion" runat="server" /><input type=hidden ID="hidSort" runat="server" />
    </td></tr>
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
        //{ 
        //  var table = document.getElementById("dgAnalysis"); // the id of your DataGrid
        //            var str = table.outerHTML; 
        //          str = str.replace(/<TBODY>/i, ""); 
       //        str = str.replace(/<TR/i, "<THEAD style='display:table-header-group;'><TR"); 
       //      str = str.replace(/<\/TR>/i, "</TR></THEAD><TBODY>"); 
       //    table.outerHTML = str; 
       //} 
</script>
</html>
