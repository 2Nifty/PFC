<%@ Page Language="C#" AutoEventWireup="true" CodeFile="eCommerceSalesAnalysisHdrRpt.aspx.cs" Inherits="eCommerceSalesAnalysisHdrRpt" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager"  TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Quote and Order Header Report</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .5pxLeft
    {
    	padding-left: 5px;
    }
    </style>

    <script type="text/javascript">
        function PrintReport()
        {
            var url= "Sort="+document.getElementById("hidSort").value+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>&Year=<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : ""%>&CustomerNumber=<%= (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : ""%>&BranchNumber=<%= (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : ""%>&StartDate=<%= Request.QueryString["StartDate"].ToString()%>&EndDate=<%= Request.QueryString["EndDate"].ToString()%>&CustomerName=<%= Request.QueryString["CustomerName"].ToString()%>';
            var hwin=window.open('eCommerceSalesAnalysisHdrRptPreview.aspx?'+url, '', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
            hwin.focus();
        }

        function DeleteFiles(session)
        {
            var str=eCommerceSalesAnalysisHdrRpt.DeleteExcel('eCommerceSalesAnalysisHdrRpt'+session).value.toString();
            parent.window.close();
        }    
    </script>     
</head>
<body>
    <form id="frmHdr" runat="server">
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
                                Quote and Order Header Report
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
                    <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                        top: 0px; left: 0px; width: 1010px; height: 510px; border: 0px solid;">
                        <asp:DataGrid UseAccessibleHeader="true" ID="dgSalesAnalysisHdr" Width="695px" runat="server"
                            GridLines="both" BorderWidth="1px" ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false"
                            BorderColor="#DAEEEF" AllowPaging="true" PageSize="19" PagerStyle-Visible="false"
                            OnItemDataBound="dgSalesAnalysisHdr_ItemDataBound" OnPageIndexChanged="dgSalesAnalysisHdr_PageIndexChanged"
                            OnSortCommand="dgSalesAnalysisHdr_SortCommand">
                            <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                HorizontalAlign="Center" Wrap="false" />
                            <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="White" Height="20px"
                                HorizontalAlign="Right" Wrap="false" />
                            <AlternatingItemStyle CssClass="GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                Height="20px" HorizontalAlign="Right" Wrap="false" />
                            <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                HorizontalAlign="Right" Wrap="false" />
                            <Columns>
                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Quote Method" ItemStyle-Width="100"
                                    ItemStyle-HorizontalAlign="Left" ItemStyle-CssClass="5pxLeft" DataField="QuoteMethod"
                                    SortExpression="QuoteMethod" />
                                <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Quote Date" ItemStyle-Width="70"
                                    ItemStyle-HorizontalAlign="Center" DataField="QuotationDate" DataFormatString="{0:MM/dd/yyyy}"
                                    SortExpression="QuotationDate" />
                                <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Expiry Date" ItemStyle-Width="70"
                                    ItemStyle-HorizontalAlign="Center" DataField="ExpiryDate" DataFormatString="{0:MM/dd/yyyy}"
                                    SortExpression="ExpiryDate" />
                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Quote No" ItemStyle-Width="100"
                                    DataField="QuoteNumber" SortExpression="QuoteNumber" />
                                <asp:BoundColumn HeaderStyle-Width="30" HeaderText="Brn" ItemStyle-Width="30" ItemStyle-HorizontalAlign="Center"
                                    DataField="SalesBranchofRecord" SortExpression="SalesBranchofRecord" />
                                <asp:TemplateColumn HeaderStyle-Width="50" HeaderText="Line Count" ItemStyle-Width="50" SortExpression="LineCount">
                                    <ItemTemplate>
                                        <asp:HyperLink ID="hplLineCount" runat="server" Text='<%# string.Format("{0:#,##0}",DataBinder.Eval(Container,"DataItem.LineCount"))%>' />
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
