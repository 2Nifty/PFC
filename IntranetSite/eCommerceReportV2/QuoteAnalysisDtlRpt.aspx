<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QuoteAnalysisDtlRpt.aspx.cs" Inherits="QuoteAnalysisDtlRpt" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager"  TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Quote Analysis Detail Report</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .list
        {
	        line-height:23px;
	        background:#FFFFCC;
	        padding:0px 10px;
	        border:1px solid #FAEE9A;
	        position:relative;
	        z-index:1;
	        top:0px;
        }
    </style>

    <script language="javascript" type="text/javascript">
    function PrintReport()
    {
//        var url= "Sort="+document.getElementById("hidSort").value+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>&Year=<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : ""%>&CustomerNumber=<%= (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : ""%>&BranchNumber=<%= (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : ""%>&StartDate=<%= Request.QueryString["StartDate"].ToString()%>&EndDate=<%= Request.QueryString["EndDate"].ToString()%>&CustomerName=<%= Request.QueryString["CustomerName"].ToString()%>';
        var url= "Sort="+document.getElementById("hidSort").value+"&Month="+'<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>&Year=<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : ""%>&CustomerNumber=<%= (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : ""%>&CustomerName=<%= Request.QueryString["CustomerName"].ToString()%>&BranchNumber=<%= (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : ""%>&StartDate=<%= Request.QueryString["StartDate"].ToString()%>&EndDate=<%= Request.QueryString["EndDate"].ToString()%>&OrdSrc=<%= (Request.QueryString["OrdSrc"] != null) ? Request.QueryString["OrdSrc"].ToString().Trim() : ""%>&ItemNotOrd=<%= (Request.QueryString["ItemNotOrd"] != null) ? Request.QueryString["ItemNotOrd"].ToString().Trim() : "false"%>&SrcTyp=<%= (Request.QueryString["SrcTyp"] != null) ? Request.QueryString["SrcTyp"].ToString().Trim() : ""%>&QuoteNumber=<%= (Request.QueryString["QuoteNumber"] != null) ? Request.QueryString["QuoteNumber"].ToString().Trim() : ""%>';
        var hwin=window.open('QuoteAnalysisDtlRptPreview.aspx?'+url, '', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
        hwin.focus();
    }

    function DeleteFiles(session)
    {
        var str=QuoteAnalysisDtlRpt.DeleteExcel('QuoteAnalysisDtlRpt'+session).value.toString();
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
                <td valign="top" colspan="2">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <table class="PageHead" style="height: 40px" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="Left5pxPadd BannerText" width="72%">
                                Quote Analysis Detail Report
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
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="height:20px;">
                        <tr class="PageBg">
                            <td class="LeftPadding TabHead" style="width: 175px">
                                <asp:Label ID="lblSourceType" runat="server" Text=""></asp:Label>
                            </td>
                            <td class="TabHead" style="width: 125px">
                                Quote # :
                                <%=Request.QueryString["QuoteNumber"].ToString()%>
                            </td>
                            <td class="TabHead" style="width: 150px">
                                Customer # :
                                <%=Request.QueryString["CustomerNumber"].ToString() %>
                            </td>
                            <td class="TabHead" style="width: 310px">
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
                            <asp:DataGrid ID="dgQuoteAnalysis" Width="1230px" runat="server"
                                GridLines="both" BorderWidth="1px" ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false"
                                BorderColor="#DAEEEF" AllowPaging="true" PageSize="19" PagerStyle-Visible="false"
                                OnItemDataBound="dgQuoteAnalysis_ItemDataBound" OnPageIndexChanged="dgQuoteAnalysis_PageIndexChanged"
                                OnSortCommand="dgQuoteAnalysis_SortCommand">
                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Center" Wrap="true" />
                                <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Right" />
                                <AlternatingItemStyle CssClass="GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF" HorizontalAlign="Right" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Right" />
                                <Columns>
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="100" HeaderText="Quote Method" ItemStyle-Width="100" ItemStyle-HorizontalAlign="left" FooterStyle-BorderColor="#DAEEEF" DataField="QuoteMethod" SortExpression="QuoteMethod" />                                   
                                    <asp:TemplateColumn HeaderStyle-BorderColor="#DAEEEF" HeaderText="Quotation Date" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="center" FooterStyle-BorderColor="#DAEEEF" >
                                        <ItemTemplate>
                                            <asp:Label ID="lblQuoteDate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"QuotationDate")%>' />
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
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="70" HeaderText="Expiry Date" ItemStyle-HorizontalAlign="center" FooterStyle-BorderColor="#DAEEEF" DataField="ExpiryDate" DataFormatString="{0:MM/dd/yyyy}" SortExpression="ExpiryDate" />
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="150" HeaderText="User Item #" ItemStyle-Width="150" ItemStyle-HorizontalAlign="left" FooterStyle-BorderColor="#DAEEEF" DataField="UserItemNo" DataFormatString="{0:#,##0.00}" SortExpression="UserItemNo" />
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="120" HeaderText="PFC Item #" ItemStyle-Width="120" ItemStyle-HorizontalAlign="left" FooterStyle-BorderColor="#DAEEEF" DataField="PFCItemNo" DataFormatString="{0:#,##0.00}" SortExpression="PFCItemNo" />
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="300" HeaderText="Description" ItemStyle-Width="300" ItemStyle-HorizontalAlign="left" FooterStyle-BorderColor="#DAEEEF" DataField="Description" DataFormatString="{0:#,##0.00}" SortExpression="Description" />
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" HeaderText="Sls Brn" ItemStyle-Width="40" ItemStyle-HorizontalAlign="center" FooterStyle-BorderColor="#DAEEEF" DataField="SalesBranchofRecord" DataFormatString="{0:#,##0.00}" SortExpression="SalesBranchofRecord" />
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" HeaderText="Req Qty" ItemStyle-Width="40" DataField="RequestQuantity" FooterStyle-BorderColor="#DAEEEF" DataFormatString="{0:#,##0}" SortExpression="RequestQuantity" />
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" HeaderText="Avl Qty" ItemStyle-Width="40" DataField="RunningAvailQty" FooterStyle-BorderColor="#DAEEEF" DataFormatString="{0:#,##0}" SortExpression="RunningAvailQty" />                                                                          
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" HeaderText="Unit Price" ItemStyle-Width="40" DataField="UnitPrice" FooterStyle-BorderColor="#DAEEEF" DataFormatString="{0:c}" SortExpression="UnitPrice" />
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" HeaderText="Mgn %" ItemStyle-Width="40" DataField="MarginPercentage" FooterStyle-BorderColor="#DAEEEF" DataFormatString="{0:#,##0.0}" SortExpression="MarginPercentage" />
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" HeaderText="Avg Cost" ItemStyle-Width="40" DataField="AvgCost" FooterStyle-BorderColor="#DAEEEF" DataFormatString="{0:c}" SortExpression="AvgCost"  />
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" HeaderText="Price UOM" ItemStyle-Width="40" ItemStyle-HorizontalAlign="left" FooterStyle-BorderColor="#DAEEEF" DataField="PriceUOM" DataFormatString="{0:#,##0.00}" SortExpression="PriceUOM" />
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="70" HeaderText="Total Price" ItemStyle-Width="70" DataField="TotalPrice" FooterStyle-BorderColor="#DAEEEF" DataFormatString="{0:c}" SortExpression="TotalPrice" />                                        
                                    <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="70" HeaderText="Total Weight" ItemStyle-Width="70" DataField="GrossWeight" FooterStyle-BorderColor="#DAEEEF" DataFormatString="{0:#,##0.00}" SortExpression="GrossWeight" />
                                </Columns>
                            </asp:DataGrid>                            
                            <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found" Visible="False" /></center>                            
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
