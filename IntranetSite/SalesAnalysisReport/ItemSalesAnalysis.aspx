<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemSalesAnalysis.aspx.cs" Inherits="ItemSalesAnalysis" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Item Sales Analysis Report</title>
   <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
   <Script> 
        
        // Javascript Function To Show The Preview Page
        function PrintReport(version,period)
        {
             var url= "period="+period+"&version="+version+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>' +
                      "&Year=" + '<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "" %>' +
                      "&Branch=" + '<%= (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() :"" %>' +
                      "&BranchName=" + '<%= (Request.QueryString["BranchName"] != null) ? Request.QueryString["BranchName"].ToString().Trim() :"" %>' +
                      "&Chain=" + '<%=(Request.QueryString["Chain"] != null) ? Request.QueryString["Chain"].ToString().Trim() : "" %>' +
                      "&CustNo=" +'<%=(Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "" %>'+
                      "&MonthName=" +'<%=(Request.QueryString["MonthName"] != null) ? Request.QueryString["MonthName"].ToString().Trim() : "" %>'+
                      "&CustName=" +'<%=GetCustomerName()%>'+
                      "&SalesRep=" +'<%=(Request.QueryString["SalesRep"] != null) ? Request.QueryString["SalesRep"].ToString().Trim() : "" %>'+
                      "&ZipFrom=" +'<%=(Request.QueryString["ZipFrom"] != null) ? Request.QueryString["ZipFrom"].ToString().Trim() : "" %>'+
                      "&ZipTo=" +'<%=(Request.QueryString["ZipTo"] != null) ? Request.QueryString["ZipTo"].ToString().Trim() : "" %>'+
                      "&OrdType=" +'<%=(Request.QueryString["OrdType"] != null) ? Request.QueryString["OrdType"].ToString().Trim() : "" %>';
            
            window.open('ItemSalesAnalysisPreview.aspx?'+url, '', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
        }

         // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
           var str=ItemSalesAnalysis.DeleteExcel('ItemSalesAnalysis'+session).value.toString();
           parent.window.close();
       }

</Script>


</head>
<body bottommargin="0" >
    <form id="form1" runat="server">
        
    <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td colspan="2"><table width="100%"  border="0" cellspacing="1" cellpadding="0">
      <tr>
        <td colspan="2" valign="middle" class="PageHead">
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign=middle><div align="left" class="LeftPadding">Item Sales Analysis</div></td>
                  <td><div class="TabHead" style="display:none">
                  Period Type :<asp:RadioButton ID="rdoPeriod1" runat="server"  AutoPostBack=true Text="YTD" GroupName="ReportPeriod" OnCheckedChanged="rdoPeriod1_CheckedChanged"/><asp:RadioButton ID="rdoPeriod2" AutoPostBack=true Text="MTD" runat="server" GroupName="ReportPeriod" OnCheckedChanged="rdoPeriod2_CheckedChanged"/>
                  </div></td>
                  <td><div class="TabHead" style="display:none">
                  Report Version :<asp:RadioButton ID="rdoReportVersion1" runat="server"   AutoPostBack=true Text="Long Version" GroupName="ReportVersion" OnCheckedChanged="rdoReportVersion1_CheckedChanged"/><asp:RadioButton ID="rdoReportVersion2" AutoPostBack=true Text="Short Version" runat="server" GroupName="ReportVersion" OnCheckedChanged="rdoReportVersion2_CheckedChanged"/>
                  </div></td>
                  <td valign=middle align=right>
                      
                             <a href='<%= GetFileURL() %>'><img  border=0 src="../common/images/ExporttoExcel.gif" /></a>
                              <asp:ImageButton  ImageUrl="../common/images/Print.gif" runat=server id="btnPrint" Text="Print" OnClick="btnPrint_Click"/>
                              <img style="cursor:hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"/>
                          </td>
                </tr>
            </table>

        </td>
      </tr>
      <tr>
        <td colspan=2 align="left" class="PageBg">
        <table width=100% cellpadding=0 cellspacing=0>
                <tr>
                    <td height="17px"  class=TabHead ><span class=LeftPadding>Period : <%=Request.QueryString["MonthName"].ToString() + " " + Request.QueryString["Year"].ToString()%></span></td>
                     <td height="15px" class="TabHead">
                        <span class=LeftPadding>Order Type :
                            <%=((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") %>
                        </span>
                    </td>
                    <td class=TabHead ><span class=LeftPadding>Branch : <%=Request.QueryString["BranchName"].ToString() %></span></td>
                    <%if (Request.QueryString["CustNo"].ToString() != "")
                      { %>
                        <td class=TabHead><span class=LeftPadding>Customer : <%=Request.QueryString["CustNo"].ToString()%> - <%=GetCustomerName()%> </span></td>
                    <%}
                      if (Request.QueryString["Chain"].ToString() != "")
                      { %>
                        <td class=TabHead><span class=LeftPadding>Chain : <%=Request.QueryString["Chain"].ToString().Replace('`','&')%> </span></td>
                    <%}%>
                    <td class="TabHead">
                                        <span class="LeftPadding">Sales Rep :
                                               <%=(Request.QueryString["SalesRep"] != "") ? Request.QueryString["SalesRep"].ToString().Replace("|", "'") : "All"%> 
                                            </span>
                                        </td>
                                        <td class=TabHead ><span class=LeftPadding>Zip : </span><span>
                    <%=(Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()%>
                    </span></td>
                    <td align="left" class="TabHead"><span class="LeftPadding">
                                        Run By : <%= Session["UserName"].ToString()%></span>
                                        </td>
                    <td align=left class=TabHead><span class=LeftPadding>Run Date : <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                </tr>
            </table>
        </td>
    </tr>
        <tr>
            <td align="center"  bgcolor=#EFF9FC colspan="2">
                <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                    Visible="False"></asp:Label></td>
        </tr>
      <tr>
        <td colspan="2"><table class="BluBordAll" width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="top" width="100%" >
                <div id="div-datagrid" class="Sbar" style="overflow:auto;position:relative;top:0px; left:0px; width:1000px; height:467px; border:0px solid;">
                <asp:DataGrid ID=dgAnalysis  BackColor=#f4fbfd AllowPaging=true runat=server Width=1800px AutoGenerateColumns=false PagerStyle-Visible="false" OnItemDataBound="dgAnalysis_ItemDataBound" BorderWidth=1 AllowSorting="true" OnSortCommand="dgAnalysis_SortCommand" GridLines=Both>
                    <HeaderStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                    <FooterStyle  HorizontalAlign="Right" CssClass="GridHead" BackColor="#dff3f9" />
                    <ItemStyle Wrap="false" CssClass="GridItem" BackColor="#f4fbfd" />
                    <AlternatingItemStyle CssClass=GridItem BackColor="#FFFFFF" />
                    <Columns>
                        <asp:BoundColumn HeaderText="Item" DataField="Item" SortExpression="Item" ItemStyle-Width=100 ItemStyle-Wrap=false></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="ItemDesc" DataField="ItemDesc" SortExpression="ItemDesc" ItemStyle-Width=240 ItemStyle-Wrap=false></asp:BoundColumn>
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
              </td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td colspan="2" class="BluBg"><table width="100%" id=tblPager runat="SERVER"><tr><td>
            <uc1:pager ID="Pager1" runat="server" />
        </td></tr><tr><td> <input type=hidden runat=server id=hidSort/><asp:HiddenField ID=hidReport runat=server /><asp:HiddenField ID=hidVersion runat=server /></td></tr></table>                
        </td>
      </tr>
    </table>
	  </td>
  </tr>
</table>
</form>
<script>window.parent.document.getElementById("Progress").style.display='none';</script>

</body>
</html>
