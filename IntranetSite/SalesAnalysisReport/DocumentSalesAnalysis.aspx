<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DocumentSalesAnalysis.aspx.cs" Inherits="DocumentSalesAnalysis" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
   
   <title>Document Sales Analysis Report</title>
   <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
   <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
   
   <Script> 

        // Javascript to show the preview page
        function PrintReport(version)
        {
             var url="version="+version+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>' +
                      "&Year=" + '<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "" %>' +
                      "&Branch=" + '<%= (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() :"" %>' +
                      "&Chain=" + '<%=(Request.QueryString["Chain"] != null) ? Request.QueryString["Chain"].ToString().Trim() : "" %>' +
                      "&CustNo=" +'<%=(Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "" %>'+
                      "&Item=" +'<%=(Request.QueryString["Item"] != null) ? Request.QueryString["Item"].ToString().Trim() : "" %>'+
                      "&MonthName=" +'<%=(Request.QueryString["MonthName"] != null) ? Request.QueryString["MonthName"].ToString().Trim() : "" %>'+
                      "&SalesRep=" +'<%=(Request.QueryString["SalesRep"] != null) ? Request.QueryString["SalesRep"].ToString().Trim() : "" %>'+
                      "&ZipFrom=" +'<%=(Request.QueryString["ZipFrom"] != null) ? Request.QueryString["ZipFrom"].ToString().Trim() : "" %>'+
                      "&ZipTo=" +'<%=(Request.QueryString["ZipTo"] != null) ? Request.QueryString["ZipTo"].ToString().Trim() : "" %>'+
                      "&OrdType=" +'<%=(Request.QueryString["OrdType"] != null) ? Request.QueryString["OrdType"].ToString().Trim() : "" %>';
            
            var a=window.screen.availWidth-60;
            window.open('DocumentSalesAnalysisPreview.aspx?'+url, '', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
        }

        // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
           
           var str=DocumentSalesAnalysis.DeleteExcel('DocumentSalesAnalysis'+session).value.toString();
           parent.window.close();
       }

</Script>

</head>
<body bottommargin="0" >
    <form id="form1" runat="server">
        
    <table width="100%"  border="0" cellspacing="0" cellpadding="0" runat=server id="BodyTable">
  <tr>
    <td colspan="2"><table width="100%"  border="0" cellspacing="1" cellpadding="0">
      <tr>
        <td colspan="2" valign="middle" class="PageHead">
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign=middle><div align="left" class="LeftPadding">Document Sales Analysis</div></td>
                  <td valign=middle align=right>
                        
                              <a href='<%= GetFileURL() %>'><img  border=0  src="../common/images/ExporttoExcel.gif" /></a>
                              <asp:ImageButton  ImageUrl="../common/images/Print.gif" runat=server id="btnPrint"  OnClick="btnPrint_Click"/>
                              <img style="cursor:hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"/>
                        
                    </td>
                </tr>
            </table>
        </td>
      </tr>
      <tr>
        <td colspan=2 align="center" class="PageBg">
        <table width=100% cellpadding=0 cellspacing=0>
                <tr>
                    <td class=TabHead style="height: 20px" ><span >Period : <%=Request.QueryString["MonthName"].ToString() + " " + Request.QueryString["Year"].ToString()%></span></td>
                     <td height="15px" class="TabHead">
                                            <span>Order Type :
                                                <%=((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") %>
                                            </span>
                                        </td>
                    <td class=TabHead ><span >Branch : <%=Request.QueryString["Branch"].ToString() %></span></td>
                    <%if (Request.QueryString["CustNo"].ToString() != "")
                      { %>
                        <td class=TabHead ><span >Customer Number : <%=Request.QueryString["CustNo"].ToString()%> </span></td>
                    <%}
                      else if (Request.QueryString["Chain"].ToString() != "")
                      { %>
                        <td class=TabHead ><span >Chain : <%=Request.QueryString["Chain"].ToString().Replace('`','&')%> </span></td>
                    <%}%>
                    <td class="TabHead">
                                        <span class="LeftPadding">Sales Rep :
                                               <%=(Request.QueryString["SalesRep"]!="") ? Request.QueryString["SalesRep"].ToString().Replace("|","''") : "All"%> 
                                            </span>
                                        </td>
                                        <td class=TabHead><span class=LeftPadding>Zip : </span><span>
                    <%=(Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()%>
                    </span></td>
                    <td class=TabHead><span>Item : <%=Request.QueryString["Item"].ToString() %></span></td>
                    <td align="left" class="TabHead">Run By : <%= Session["UserName"].ToString()%>
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
              <td valign="top" style="width: 99%" >
                <div class="Sbar" id="div-datagrid" style="overflow:auto;position:relative;top:0px; left:0px; width:1000px; height:465px; border:0px solid;">
                <asp:DataGrid PageSize=19 ID=dgAnalysis  BackColor=#f4fbfd AllowPaging=true runat=server Width=1600px AutoGenerateColumns=false PagerStyle-Visible="false"  BorderWidth=1 AllowSorting="true" OnSortCommand="dgAnalysis_SortCommand" GridLines=Both OnItemDataBound="dgAnalysis_ItemDataBound" >
                    <HeaderStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#dff3f9" />
                    <ItemStyle CssClass="GridItem" BackColor="#f4fbfd" Wrap="false"/>
                    <FooterStyle  HorizontalAlign="Right" CssClass="GridHead" BackColor="#dff3f9" />
                    <AlternatingItemStyle CssClass=GridItem BackColor="#FFFFFF" />
                    <Columns>
                            <asp:BoundColumn HeaderText="SO#" DataField="SO#" SortExpression="SO#" ItemStyle-Wrap=false HeaderStyle-Wrap=false FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem></asp:BoundColumn>
                            <asp:BoundColumn HeaderText="INV#" DataField="INV#" SortExpression="INV#" ItemStyle-Wrap=false HeaderStyle-Wrap=false FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem></asp:BoundColumn>
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
              </td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td colspan="2" class="BluBg"><table width="100%" id=tblPager runat="SERVER"><tr><td>
            <uc1:pager ID="Pager1" runat="server" /></td></tr></table> 
             <input type=hidden runat=server id=hidSort/>               
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
