<%@ Page Language="C#" AutoEventWireup="true" CodeFile="eCommerceQuote2OrderAnalysis.aspx.cs"
    Inherits="eCommerceQuoteToOrderAnalysis" %>


<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager"  TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>eCommerce Quote and Order Analysis Report</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
<script>
 //Javascript function to Show the preview page
        function PrintReport()
        {
            var url= "Sort="+document.getElementById("hidSort").value+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>&Year=<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "" %>&Branch=<%= (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() : "" %>&CustNo=<%= (Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "" %>&StartDate=<%= (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "" %>&EndDate=<%= (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "" %>&MonthName=<%=Request.QueryString["MonthName"] %>&BranchName=<%=Request.QueryString["BranchName"] %>&RepName=<%=Request.QueryString["RepName"] %>&RepNo=<%=Request.QueryString["RepNo"] %>&PriceCdCtl=<%=Request.QueryString["PriceCdCtl"] %>';
            var hwin=window.open('eCommerceQuoteAndOrderPreview.aspx?'+url, '', 'height=700,width=750,scrollbars=no,status=no,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (750/2))+',resizable=NO',"");
            hwin.focus();
        }
         // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
            var str=eCommerceQuoteToOrderAnalysis.DeleteExcel('eCommerceQuote2Order'+session).value.toString();
            parent.window.close();
       }
       function BindValue(sortExpression)
       {
            if(document.getElementById("hidSortExpression") !=null)
                document.getElementById("hidSortExpression").value= sortExpression;
            document.getElementById("btnSort").click();
       }
</script>     
</head>
<body>
    <form id="form1" runat="server">  
     <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>      
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top" colspan="2">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 40px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            eCommerce Quote and Order Analysis Report
                                        </td>
                                        <td align="right"  style="width: 30%;padding-right:5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td >
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif" ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td> 
                                                         <img style="cursor:hand" src="../common/images/Print.gif" id="btnPrint"  onclick="javascript:PrintReport();" /></td>
                                                    <td  >
                                                        <img align="right" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            src="Common/Images/Buttons/Close.gif" style="cursor: hand;padding-right:2px;" /></td>
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
              <td>
                <table cellpadding=1 cellspacing=0 width="100%">
                    <tr>
                        <td class="LeftPadding TabHead" style="width:110px">
                            Customer # <%=(Request.QueryString["CustNo"].ToString() == "") ? "All" : Request.QueryString["CustNo"].ToString()%>
                        </td>
                        <td class="LeftPadding TabHead" style="width:180px">
                             Branch: <%=Request.QueryString["BranchName"].ToString()%>
                        </td>
                        <td class="TabHead"  style="width:200px">
                               Period: <%=Request.QueryString["MonthName"].ToString()%><%=Request.QueryString["StartDate"].ToString()%> -  <%=Request.QueryString["Year"].ToString()%><%=Request.QueryString["EndDate"].ToString()%>
                        </td>
                        <td class="TabHead" style="width: 150px">
                                CSR Name: <%=Request.QueryString["RepName"].ToString()%>
                        </td>
                        <td width=100px;>&nbsp;</td>
                        <td class="TabHead" style="width:130px">
                                Run By: <%= Session["UserName"].ToString() %>
                        </td>
                        <td class="TabHead" style="width:130px">
                                Run Date: <%=DateTime.Now.ToShortDateString()%>
                        </td>
                    </tr>
                </table>
              </td>
            </tr>            
            <tr>
                <td>
                    <asp:UpdatePanel ID="pnlSearchVendor" runat="server" UpdateMode="conditional">
                            <ContentTemplate> 
                                <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                    top: 0px; left: 0px; width: 1020px; height: 500px; border: 0px solid;">
                                    <div id="PrintDG2">
                                        <asp:DataGrid ID="dgQuote2Order" Width="100%" runat="server" GridLines="both" BorderWidth="1px" ShowFooter="true" AllowSorting="true"
                                            AutoGenerateColumns="false" BorderColor="#DAEEEF" AllowPaging="true" PageSize="19" PagerStyle-Visible="false" OnItemDataBound="dgQuote2Order_ItemDataBound" OnPageIndexChanged="dgQuote2Order_PageIndexChanged" OnSortCommand="dgQuote2Order_SortCommand">
                                            <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                HorizontalAlign="Center" />
                                            <ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White"
                                                Height="20px" HorizontalAlign="Left" />
                                            <AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                                HorizontalAlign="Left" />
                                            <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                HorizontalAlign="Center" />
                                            <Columns>
                                                <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="left" HeaderText="Cust #" FooterStyle-HorizontalAlign=Center
                                                    DataField="customerNumber" SortExpression="customerNumber" ItemStyle-Wrap="false"
                                                    ItemStyle-Width="40" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                    
                                                <asp:BoundColumn HeaderStyle-Width="200" ItemStyle-HorizontalAlign="left" HeaderText="Name" FooterStyle-HorizontalAlign="right"
                                                    DataField="CustomerName" SortExpression="CustomerName" ItemStyle-Wrap="false"
                                                    ItemStyle-Width="200" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                
                                                <asp:BoundColumn HeaderStyle-Width="20" ItemStyle-HorizontalAlign="left" HeaderText="Brn" FooterStyle-HorizontalAlign="right"
                                                    DataField="SalesLocationCode" SortExpression="SalesLocationCode" ItemStyle-Wrap="false"
                                                    ItemStyle-Width="20" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                
                                                <asp:TemplateColumn SortExpression="NoOfQuotes" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false"  FooterStyle-HorizontalAlign="right"
	                                                HeaderText="# of Quotes" HeaderStyle-Width="40" ItemStyle-Width="40" HeaderStyle-Wrap="false">
	                                                <ItemTemplate>
	                                                    <asp:HyperLink ID="hplNoOfQuotes" runat="server" Visible="true" NavigateUrl='<%# "QuoteAnalysisReport.aspx?Month="+Request.QueryString["Month"].ToString().Trim()+"&Year="+Request.QueryString["Year"].ToString().Trim() +"&StartDate="+Request.QueryString["StartDate"].ToString().Trim() +"&EndDate="+Request.QueryString["EndDate"].ToString().Trim()+"&CustomerNumber=" + DataBinder.Eval(Container,"DataItem.customerNumber")+"&BranchNumber=" + DataBinder.Eval(Container,"DataItem.SalesLocationCode")+"&CustomerName=" + DataBinder.Eval(Container,"DataItem.CustomerName")+ "&RepName=" + Request.QueryString["RepName"].ToString().Trim()+ "&RepNo=" + Request.QueryString["RepNo"].ToString().Trim()%>' Text='<%# string.Format("{0:#,##0}",DataBinder.Eval(Container,"DataItem.NoOfQuotes"))%>'></asp:HyperLink> 
	                                                </ItemTemplate>
                                                </asp:TemplateColumn>                                        
                                                    
                                                <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="right" HeaderText="Extended $ Amnt" FooterStyle-HorizontalAlign="right"
                                                    DataField="ExtAmount" DataFormatString="{0:#,##0.00}" SortExpression="ExtAmount" ItemStyle-Wrap="false"
                                                    ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                    
                                                <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="right" HeaderText="Extended Weight" FooterStyle-HorizontalAlign="right"
                                                    DataField="ExtWeight" DataFormatString="{0:#,##0.00}" SortExpression="ExtWeight" ItemStyle-Wrap="false"
                                                    ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                
                                                <asp:TemplateColumn SortExpression="NoOfOrders" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false"  FooterStyle-HorizontalAlign="right"
	                                                HeaderText="# of Orders" HeaderStyle-Width="40" ItemStyle-Width="40" HeaderStyle-Wrap="false">
	                                                <ItemTemplate>
	                                                    <asp:HyperLink ID="hplNoOfOrders" runat="server" Visible="true" NavigateUrl='<%# "OrderAnalysisReport.aspx?Month="+Request.QueryString["Month"].ToString().Trim()+"&Year="+Request.QueryString["Year"].ToString().Trim() +"&StartDate="+Request.QueryString["StartDate"].ToString().Trim() +"&EndDate="+Request.QueryString["EndDate"].ToString().Trim()+"&CustomerNumber=" + DataBinder.Eval(Container,"DataItem.customerNumber")+"&BranchNumber=" + DataBinder.Eval(Container,"DataItem.SalesLocationCode")+"&CustomerName=" + DataBinder.Eval(Container,"DataItem.CustomerName") + "&RepName=" + Request.QueryString["RepName"].ToString().Trim()+ "&RepNo=" + Request.QueryString["RepNo"].ToString().Trim()%>' Text='<%# DataBinder.Eval(Container,"DataItem.NoOfOrders")%>'></asp:HyperLink> 
	                                                </ItemTemplate>
                                                </asp:TemplateColumn>                                     
                                                
                                                <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="right" HeaderText="Extended $ Amnt" FooterStyle-HorizontalAlign="right"
                                                    DataField="ExtOrdAmount" DataFormatString="{0:#,##0.00}" SortExpression="ExtOrdAmount" ItemStyle-Wrap="false"
                                                    ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                    
                                                <asp:BoundColumn ItemStyle-HorizontalAlign="right" HeaderText="Extended Weight" DataField="ExtOrdWeight" SortExpression="ExtOrdWeight" DataFormatString="{0:#,##0.00}" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="right"
                                                    ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                    
                                                <asp:BoundColumn></asp:BoundColumn>
                                            </Columns>
                                        </asp:DataGrid> 
                                        <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle"  Text="No Records Found" Visible="False"></asp:Label></center>                            
                                    </div>
                                </div> 
                                
                                <asp:Button ID="btnSort" runat="server" Text="" style="display:none;" OnClick="btnSort_Click" />
                                
                                <uc3:pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged" />
                                <asp:HiddenField ID="hidFileName" Value="" runat="server" />  
                                <input type="hidden" runat="server" id="hidSort" />    
                            </ContentTemplate>
                    </asp:UpdatePanel>
                </td>    
            </tr>
            <tr>
                <td>
                    <uc2:BottomFrame ID="BottomFrame1" runat="server" />   
                    <input type="hidden" runat="server" id="hidSortExpression" /> 
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
