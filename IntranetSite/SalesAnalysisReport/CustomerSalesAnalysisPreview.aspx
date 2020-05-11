<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerSalesAnalysisPreview.aspx.cs" Inherits="Sales_Analysis_Report_CustomerSalesAnalysisPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Customer Sales Analysis Report</title>
   <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
   <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
   <Script> 
</Script>

</head>
<body  bottommargin="0" onload="javascript:print_header()">
    <form id="form1" runat="server">
    
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td >
                </td>
                <td bgcolor=#EFF9FC >
                    <div align="right">
                        <span>&nbsp;<img src="../Common/images/print.gif" style="cursor:hand"  onclick="javascript:CallPrint('PrintDG1','PrintDG2','PrintDG3');" />
                             <img src="../Common/images/close.gif" style="cursor:hand"  onclick="javascript:window.close();" />
                            </span></div>                            
                </td>
            </tr>
        </table>           
    
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr valign="top">
                <td colspan="2">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td class="PageHead"  valign="middle">
                              <div id="PrintDG1">
                                <div align="left" class="LeftPadding">
                                    Customer Sales Analysis</div>
                                    </div>
                            </td>
                        </tr>
                        <tr>
                        <td colspan="2" align="center" >
                           <table width="100%" cellpadding="0" cellspacing="0" >
                        <tr>
                            <td colspan="2" align="center" class="PageBg">
                            <div id="PrintDG2">
                                <table width="100%" cellpadding="0" cellspacing="0" >
                                    <tr>
                                        <td height="19px" class="TabHead">
                                            <span>Period :
                                                <%=Request.QueryString["MonthName"].ToString() + " " + Request.QueryString["Year"].ToString()%>
                                            </span>
                                        </td>
                                        <td height="15px" class="TabHead">
                                            <span>Order Type :
                                                <%=((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") %>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span>Branch :
                                                <%=Request.QueryString["BranchName"].ToString() %>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                        <span >Sales Rep :
                                                <%=Request.QueryString["SalesRep"].ToString().Replace("|","'")%>
                                            </span>
                                        </td>
                                        <td class=TabHead ><span>Zip : </span><span>
                    <%=(Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()%>
                    </span></td>
                                        <td class="TabHead">
                                            <span>Chain :
                                                <%=(Request.QueryString["Chain"] != "") ? Request.QueryString["Chain"].ToString().Trim() : "All"%>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span>Customer :
                                                <%=(Request.QueryString["CustNo"] != "") ? Request.QueryString["CustNo"].ToString().Trim() : "All"%>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span >Fiscal Year
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
                                        <td align="left" class="TabHead"><span >
                                        Run By : <%= Session["UserName"].ToString()%></span>
                                        </td>
                                        <td  align="left" class="TabHead">
                                            <span>Run Date : <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                                    </tr>
                                </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" >
                                <table class="BluBordAll"  width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td  valign="top" height="100%" width="100%">
                                        
                                    <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px; left: 0px; bottom:0px; width: 1000px; height: 590px; border: 0px solid;">                                                             
                                        <div id="PrintDG3">                                        

                                                    <asp:DataGrid ID="dgAnalysis" BackColor="#f4fbfd" runat="server" 
                                                    Width="2000px" AutoGenerateColumns="false" ShowFooter="true" 
                                                    OnItemDataBound="dgAnalysis_ItemDataBound" PagerStyle-Visible="false" 
                                                    BorderWidth="1" GridLines="both" BorderColor="#c9c6c6">
                                                    <HeaderStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <ItemStyle CssClass="GridItem" BackColor="#F4FBFD" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                    <asp:BoundColumn HeaderText="Cust #" DataField="CustNo" SortExpression="CustNo" ItemStyle-Wrap=false HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustName" DataField="CustName" SortExpression="CustName" ItemStyle-Wrap=false HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustCity" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-Wrap=false ItemStyle-CssClass=GridItem DataField="CustCity" SortExpression="CustCity" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="SalesLoc" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="SalesLoc" SortExpression="SalesLoc" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn ItemStyle-Width=50px FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderText="Chain" DataField="Chain" SortExpression="Chain" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CMSales" DataFormatString="{0:#,##0}" SortExpression="CMSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LMSales" DataFormatString="{0:#,##0}" SortExpression="LMSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CGM" FooterStyle-CssClass=GridHead    HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CGM" DataFormatString="{0:#,##0}" SortExpression="CGM"  ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CGMPct" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CGMPct" DataFormatString="{0:0.0}" SortExpression="CGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMGM" FooterStyle-CssClass=GridHead   HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LMGM" DataFormatString="{0:#,##0}" SortExpression="LMGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMGMPct" FooterStyle-CssClass=GridHead    HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LMGMPct"  DataFormatString="{0:0.0}"  SortExpression="LMGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMWgt" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CMWgt" DataFormatString="{0:#,##0}" SortExpression="CMWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CMDollarLb"  DataFormatString="{0:0.00}" SortExpression="CMDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMWgt" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LMWgt" DataFormatString="{0:#,##0}" SortExpression="LMWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LMDollarLb"  DataFormatString="{0:0.00}" SortExpression="LMDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDSales" FooterStyle-CssClass=GridHead   HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDSales" DataFormatString="{0:#,##0}" SortExpression="YTDSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDSales" DataFormatString="{0:#,##0}" SortExpression="LYTDSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDGM" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDGM" DataFormatString="{0:#,##0}" SortExpression="YTDGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDGMPct" FooterStyle-CssClass=GridHead   HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDGMPct"  DataFormatString="{0:0.0}" SortExpression="YTDGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                     <asp:BoundColumn HeaderText="YTDExp" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDExp" DataFormatString="{0:#,##0}" SortExpression="YTDExp" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDNP" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDNP" DataFormatString="{0:#,##0}" SortExpression="YTDNP" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="AccumNP" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="AccumNP" DataFormatString="{0:#,##0}" SortExpression="AccumNP" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDGM" FooterStyle-CssClass=GridHead     HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDGM" DataFormatString="{0:#,##0}" SortExpression="LYTDGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDGMPct" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDGMPct" DataFormatString="{0:0.0}"  SortExpression="LYTDGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDExp" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDExp" DataFormatString="{0:#,##0}" SortExpression="LYTDExp" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDNP" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDNP" DataFormatString="{0:#,##0}" SortExpression="LYTDNP" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LAccumNP" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LAccumNP" DataFormatString="{0:#,##0}" SortExpression="LAccumNP" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDWgt" FooterStyle-CssClass=GridHead     HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDWgt" DataFormatString="{0:#,##0}" SortExpression="YTDWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDDollarLb" DataFormatString="{0:0.00}"  SortExpression="YTDDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDWgt" FooterStyle-CssClass=GridHead     HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDWgt" DataFormatString="{0:#,##0}" SortExpression="LYTDWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDDollarLb" DataFormatString="{0:0.00}"  SortExpression="LYTDDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustRep" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CustRep" SortExpression="CustRep" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustGroup" FooterStyle-CssClass=GridHead    HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CustGroup" SortExpression="CustGroup"  ItemStyle-Wrap=false ItemStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Zip" FooterStyle-CssClass=GridHead          HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CustZip" SortExpression="CustZip" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=left HeaderStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="PFC Rep" FooterStyle-CssClass=GridHead          HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="PFCRep" SortExpression="PFCRep" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=center HeaderStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="ABC" FooterStyle-CssClass=GridHead          HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="ABC" SortExpression="ABC" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=left HeaderStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTD Budget $" FooterStyle-CssClass=GridHead          HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDBudget" DataFormatString="{0:#,##0}" SortExpression="YTDBudget" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=right HeaderStyle-HorizontalAlign=right></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Ind Type" FooterStyle-CssClass=GridHead     HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CustType" SortExpression="CustType" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=left HeaderStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    </Columns>
                                                        <PagerStyle Visible="False" />
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
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height: 20px" bgcolor=#EFF9FC >
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
