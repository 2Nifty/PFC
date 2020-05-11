<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderAnalysisDtlRpt.aspx.cs" Inherits="OrderAnalysisDtlRpt" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager"  TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Order Analysis Detail Report</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    
    <script language="javascript" type="text/javascript">
        function PrintReport()
        {
            var url= "Sort="+document.getElementById("hidSort").value+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>&Year=<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "" %>&CustomerNumber=<%= (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : ""%>&BranchNumber=<%= (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : ""%>&StartDate=<%= Request.QueryString["StartDate"].ToString()%>&EndDate=<%= Request.QueryString["EndDate"].ToString()%>&CustomerName=<%= Request.QueryString["CustomerName"].ToString()%>';
            var hwin=window.open('OrderAnalysisPreview.aspx?'+url, '', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
            hwin.focus();
        }

        function DeleteFiles(session)
        {
            var str=OrderAnalysisReport.DeleteExcel('OrderAnalysisReport'+session).value.toString();
            parent.window.close();
        }
       
        function ShowGridtooltip(tooltipId, parentId) 
        {   
            it = document.getElementById(tooltipId); 
        
            // need to fixate default size (MSIE problem) 
            img = document.getElementById(parentId); 
                   
            it.style.top =  event.clientY - 130 + 'px'; 
            it.style.left = event.clientX+ 'px';
           
            // Show the tag in the position
            it.style.display = '';
          
            return false; 
        }
    </script> 
</head>
<body>
    <form id="frmDtl" runat="server">        
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <table class="PageHead" style="height: 40px" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="Left5pxPadd BannerText" width="72%">
                                Order Analysis Detail Report
                            </td>
                            <td>
                                <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                    ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                            </td>
                            <td>
                                <img alt="print" style="cursor: hand" src="../common/images/Print.gif" id="btnPrint" onclick="javascript:PrintReport();" /></td>
                            <td>
                                <img alt="close" align="right" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                    src="../Common/images/close.gif" style="cursor: hand; padding-right: 2px;" /></td>
                        </tr>
                    </table>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr class="PageBg">
                            <td class="LeftPadding TabHead" style="width: 200px">
                                <asp:Label ID="lblSourceType" runat="server" Text=""></asp:Label>
                            </td>
                            <td class="LeftPadding TabHead" style="width: 150px">
                                Customer # :
                                <%=Request.QueryString["CustomerNumber"].ToString() %>
                            </td>
                            <td class="LeftPadding TabHead" style="width: 420px">
                                Customer Name :
                                <%=Request.QueryString["CustomerName"].ToString() %>
                            </td>
                            <td class="TabHead" style="width: 125px">
                                Run By :
                                <%= Session["UserName"].ToString() %>
                            </td>
                            <td class="TabHead" style="width: 125px">
                                Run Date :
                                <%=DateTime.Now.ToShortDateString()%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>            
            <tr>
                <td>
                    <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative; top: 0px; left: 0px; width: 1020px; height: 510px; border: 0px solid;">
                            <asp:DataGrid UseAccessibleHeader="true" ID="dgOrderAnalysis" Width="1270" runat="server"
                                GridLines="both" BorderWidth="1px" ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false"
                                BorderColor="#DAEEEF" AllowPaging="true" PageSize="19" PagerStyle-Visible="false"
                                OnItemDataBound="dgOrderAnalysis_ItemDataBound" OnPageIndexChanged="dgOrderAnalysis_PageIndexChanged"
                                OnSortCommand="dgOrderAnalysis_SortCommand">
                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Center" Wrap="false" />
                                <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="White" Height="20px" HorizontalAlign="Left" />
                                <AlternatingItemStyle CssClass="GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF" HorizontalAlign="Left" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"  HorizontalAlign="Left" />
                                <Columns>                                    
                                    <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Order Method" ItemStyle-Width="100" FooterStyle-HorizontalAlign="Center"
                                        DataField="QuoteMethod" SortExpression="QuoteMethod" />                                  
                                    <asp:TemplateColumn HeaderText="P.O. Number" SortExpression="PurchaseOrderNo" ItemStyle-Width="80">
                                        <HeaderStyle Width="70px" />  
                                        <ItemTemplate>
                                            <asp:Label Style="cursor:hand;" ID="lblPONo" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"PurchaseOrderNo")%>' Font-Underline="true" />
                                            <div id="divToolTips" class="list" runat="server" style="display: none; position: absolute;z-index:99;" onmouseup="return false;">
                                                <table border="0" cellpadding="0" cellspacing="0" style="z-index:99;">
                                                    <tr>
                                                        <td colspan="2" style="z-index:99;">
                                                            <span class="boldText"><b>User Name: </b></span>
                                                            <asp:Label ID="lblUserName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ECommUserName")%>' Font-Bold="false"></asp:Label></td>                                                    
                                                    </tr>
                                                    <tr>
                                                        <td style="padding-right:10px; z-index:99;">
                                                            <span class="boldText"><b> Phone: </b></span>
                                                            <asp:Label ID="lblPhone" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ECommPhoneNo")%>' Font-Bold="false"></asp:Label></td>
                                                        <td>
                                                            <span class="boldText" style="padding-left: 5px;z-index:99;"><b>IP: </b></span>
                                                            <asp:Label ID="lblIP" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ECommIPAddress")%>' Font-Bold="false"></asp:Label></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn HeaderStyle-Width="70" HeaderText="P.O. Date" ItemStyle-Width="70"
                                        DataField="PurchaseOrderDate" DataFormatString="{0:MM/dd/yyyy}" SortExpression="PurchaseOrderDate" />
                                    <asp:BoundColumn HeaderStyle-Width="150" HeaderText="User Item #" ItemStyle-Width="150" FooterStyle-HorizontalAlign="right"
                                        DataField="UserItemNo" DataFormatString="{0:#,##0.00}" SortExpression="UserItemNo" />
                                    <asp:BoundColumn HeaderStyle-Width="120" HeaderText="PFC Item #" ItemStyle-Width="120"
                                        DataField="PFCItemNo" DataFormatString="{0:#,##0.00}" SortExpression="PFCItemNo" />
                                    <asp:BoundColumn HeaderStyle-Width="300" HeaderText="Description" ItemStyle-Width="300"
                                        DataField="Description" DataFormatString="{0:#,##0.00}" SortExpression="Description" />
                                    <asp:BoundColumn HeaderStyle-Width="80" HeaderText="Sales Branch Of Record" ItemStyle-Width="80"
                                        DataField="SalesBranchofRecord" DataFormatString="{0:#,##0.00}" SortExpression="SalesBranchofRecord" />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Req. Qty" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="RequestQuantity" DataFormatString="{0:#,##0}" SortExpression="RequestQuantity" />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Ava. Qty" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="RunningAvailQty" DataFormatString="{0:#,##0}" SortExpression="RunningAvailQty" />                                                                          
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Unit Price" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="UnitPrice" DataFormatString="{0:#,##0.00}" SortExpression="UnitPrice" />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Margin %" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="MarginPercentage" DataFormatString="{0:#,##0.0}" SortExpression="MarginPercentage" />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Average Cost" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="AvgCost" DataFormatString="{0:#,##0.00}" SortExpression="AvgCost"  />
                                    <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Price UOM" ItemStyle-Width="40"
                                        DataField="PriceUOM" DataFormatString="{0:#,##0.00}" SortExpression="PriceUOM" />
                                    <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Total Price" ItemStyle-Width="70" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="TotalPrice" DataFormatString="{0:#,##0.00}" SortExpression="TotalPrice" />                                        
                                    <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Total Weight" ItemStyle-Width="70" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                        DataField="GrossWeight" DataFormatString="{0:#,##0.00}" SortExpression="GrossWeight" />
                                </Columns>
                            </asp:DataGrid> 
                            <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle"  Text="No Records Found" Visible="False" /></center>                            
                    </div>                    
                    <uc3:pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged" />
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:BottomFrame ID="BottomFrame1" runat="server" />   
                    <asp:HiddenField ID="hidFileName" Value="" runat="server" />  
                    <input type="hidden" runat="server" id="hidSort" />    
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
