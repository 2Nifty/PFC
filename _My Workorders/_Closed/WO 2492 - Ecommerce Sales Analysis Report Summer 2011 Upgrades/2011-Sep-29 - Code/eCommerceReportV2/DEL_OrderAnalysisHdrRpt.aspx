<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DEL_OrderAnalysisHdrRpt.aspx.cs" Inherits="OrderAnalysisHdrRpt" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager"  TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Order Header Analysis Report</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .5pxLeft
    {
    	padding-left: 5px;
    }
    </style>

    <script type="text/javascript">
        //Javascript function to Show the preview page
        function PrintReport()
        {
            var url= "Sort="+document.getElementById("hidSort").value+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>&Year=<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : ""%>&CustomerNumber=<%= (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : ""%>&BranchNumber=<%= (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : ""%>&StartDate=<%= Request.QueryString["StartDate"].ToString()%>&EndDate=<%= Request.QueryString["EndDate"].ToString()%>&CustomerName=<%= Request.QueryString["CustomerName"].ToString()%>';
            var hwin=window.open('OrderAnalysisHdrRptPreview.aspx?'+url, '', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
            hwin.focus();
        }

        // Javascript Function To Call Server Side Function Using Ajax
        function DeleteFiles(session)
        {
            var str=OrderAnalysisHdrRpt.DeleteExcel('OrderAnalysisHdrRpt'+session).value.toString();
            parent.window.close();
        }    
    </script>     
</head>
<body>
    <form id="frmOrderHdr" runat="server">
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
                            <td class="PageHead" colspan="5" style="height: 40px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            Order Header Analysis Report
                                        </td>
                                        <td align="right" style="width: 30%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <img style="cursor: hand" src="../common/images/Print.gif" id="btnPrint" onclick="javascript:PrintReport();" /></td>
                                                    <td>
                                                        <img align="right" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            src="../Common/images/close.gif" style="cursor: hand; padding-right: 2px;" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr id="trHead" class="PageBg">
                            <td class="LeftPadding TabHead" style="width: 110px">
                                Customer # :
                                <%=Request.QueryString["CustomerNumber"].ToString() %>
                            </td>
                            <td class="LeftPadding TabHead" style="width: 300px">
                                Customer Name :
                                <%=Request.QueryString["CustomerName"].ToString() %>
                            </td>
                            <td class="TabHead">
                                &nbsp;
                            </td>
                            <td class="TabHead" style="width: 130px">
                                Run By :
                                <%= Session["UserName"].ToString() %>
                            </td>
                            <td class="TabHead" style="width: 130px">
                                Run Date :
                                <%=DateTime.Now.ToShortDateString()%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                        top: 0px; left: 0px; width: 1010px; height: 510px; border: 0px solid;">
                            <asp:DataGrid UseAccessibleHeader="true" ID="dgOrderAnalysis" Width="695px" runat="server"
                                GridLines="both" BorderWidth="1px" ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false"
                                BorderColor="#DAEEEF" AllowPaging="true" PageSize="19" PagerStyle-Visible="false"
                                OnItemDataBound="dgOrderAnalysis_ItemDataBound" OnPageIndexChanged="dgOrderAnalysis_PageIndexChanged"
                                OnSortCommand="dgOrderAnalysis_SortCommand">
                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" Wrap="false" />
                                <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="White" Height="20px"
                                    HorizontalAlign="Right" Wrap="false" />
                                <AlternatingItemStyle CssClass="GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                    Height="20px" HorizontalAlign="Right" Wrap="false" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Right" Wrap="false" />
                                <Columns>
                                    <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Order Method" ItemStyle-Width="100"
                                        ItemStyle-HorizontalAlign="Left" ItemStyle-CssClass="5pxLeft" DataField="OrderMethod" SortExpression="OrderMethod" />
                                    <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Quotation Date" ItemStyle-Width="70"
                                        ItemStyle-HorizontalAlign="Center" DataField="QuotationDate" DataFormatString="{0:MM/dd/yyyy}"
                                        SortExpression="QuotationDate" />
                                    <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Expiry Date" ItemStyle-Width="70"
                                        ItemStyle-HorizontalAlign="Center" DataField="ExpiryDate" DataFormatString="{0:MM/dd/yyyy}"
                                        SortExpression="ExpiryDate" />
                                    <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Order No" ItemStyle-Width="100"
                                        DataField="OrderNumber" SortExpression="OrderNumber" />
                                    <asp:BoundColumn HeaderStyle-Width="30" HeaderText="Brn" ItemStyle-Width="30" ItemStyle-HorizontalAlign="Center"
                                        DataField="SalesBranchofRecord" SortExpression="SalesBranchofRecord" />
                                    <asp:TemplateColumn HeaderStyle-Width="50" HeaderText="Order Lines" ItemStyle-Width="50" SortExpression="LineCount">
                                        <ItemTemplate>
                                            <asp:HyperLink ID="hplLineCount" runat="server" Text='<%# string.Format("{0:#,##0}",DataBinder.Eval(Container,"DataItem.LineCount"))%>'
                                                NavigateUrl='<%# "OrderAnalysisDtlRpt.aspx?Month="+Request.QueryString["Month"].ToString().Trim() + "&Year="+Request.QueryString["Year"].ToString().Trim() + "&StartDate="+Request.QueryString["StartDate"].ToString().Trim() + "&EndDate="+Request.QueryString["EndDate"].ToString().Trim() + "&CustomerNumber="+DataBinder.Eval(Container,"DataItem.customerNumber") + "&RepName="+Request.QueryString["RepName"].ToString().Trim() + "&RepNo="+Request.QueryString["RepNo"].ToString().Trim() + "&OrdSrc="+Request.QueryString["OrdSrc"].ToString().Trim() + "&ItemNotOrd="+Request.QueryString["ItemNotOrd"].ToString().Trim()%>'>
                                            </asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn HeaderStyle-Width="75" HeaderText="Tot Req Qty" ItemStyle-Width="75"
                                        DataField="RequestQuantity" DataFormatString="{0:#,##0}" SortExpression="RequestQuantity" />
                                    <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Total Price" ItemStyle-Width="100"
                                        DataField="ExtPrice" DataFormatString="{0:c}" SortExpression="ExtPrice" />
                                    <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Total Weight" ItemStyle-Width="100"
                                        DataField="ExtWeight" DataFormatString="{0:#,##0.00}" SortExpression="ExtWeight" />
                                </Columns>
                            </asp:DataGrid>
                            <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found" Visible="False"></asp:Label></center>
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
