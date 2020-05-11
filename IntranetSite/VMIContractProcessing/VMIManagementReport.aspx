<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VMIManagementReport.aspx.cs" Inherits="VMIContractProcessing_VMIManagementReport" EnableViewState="true" %>
<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VMI Management Report</title>
    <link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <style>   
        

   .GridHeads {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
	color: #3A3A56;
	
	height: 15px;
	border-bottom:solid 0px #c9c6c6;
	border-left:solid 0px #c9c6c6;
	border-right:solid 1px #c9c6c6;
	border-top:solid 0px #c9c6c6;
	border-collapse:collapse;
}
    
    </style>
    <script language="javascript">


        // Javascript Function To Show The Preview Page
        function PrintReport()
        {
         var url="ContractNo=" + '<%= Request.QueryString["ContractNo"].Trim()%>' +
                      "&CustomerPO=" + '<%= Request.QueryString["CustomerPO"].Trim()%>'+
                      "&ChainName=" + '<%= Request.QueryString["ChainName"].Trim()%>'+
                      "&mode=" + '<%= Request.QueryString["mode"].Trim()%>';
                      
          window.open('VMIManagementReportPreview.aspx?'+url, '', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
         
        }
        
        // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
           var str=VMIContractProcessing_VMIManagementReport.DeleteExcel('VMIManagementReport'+session).value.toString();
           parent.window.close();
       }
        
  </script>
</head>
<body scroll=no>
    <form id="form1" runat="server">
        <table cellpadding="0" cellspacing="0" id="master" class="DashBoardBk" width="100%" >
            <tr>
                <td width="100%" colspan="2" style="height: 75px">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
                        <tr>
                            <td width="62%" valign="middle">
                                <img src="../Common/Images/Logo.gif" width="453" height="50" hspace="25" vspace="10"></td>
                            <td width="38%" valign="bottom" class="10pxPadding">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="PageHead" width="70%">
                    <div align="left" class="LeftPadding">VMI Management Report</div>
                </td>
                <td class="PageHead" align="right" style="padding-right:5px" width="30%">
                <a href='<%= GetFileURL() %>'><img  border=0 src="../common/images/ExporttoExcel.gif" /></a>
                <img src="../Common/images/print.gif" style="cursor:hand"  onclick="javascript:PrintReport();" />
                <img style="cursor:hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"/>
                </td>
            </tr>
           
            <tr>
                <td valign="middle" colspan="2">
                    <asp:DataGrid PageSize="1" ID="dgReport" AllowPaging="true"  PagerStyle-Visible =false runat="server" AutoGenerateColumns="False" 
                                        OnPageIndexChanged="dgReport_PageIndexChanged" OnItemDataBound="dgReport_ItemDataBound" ShowHeader="False" EnableViewState="true">                                        
                        <Columns>
                            <asp:TemplateColumn>
                                <ItemTemplate>
                                    <table width="100%" cellpadding="0" cellspacing="1">
                        
                                        <tr>
                                            <td class="PageBg">
                                                <table cellspacing="0" cellpadding="2" align="left" width="100%">
                                                    <tr>
                                                        <td height="1"  class="splitBorder TabHead" style="width: 116px">
                                                            <strong>CUSTOMER CHAIN</strong>
                                                        </td>
                                                        <td align="left" colspan="3"  class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblCusChain" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"Chain")%>'></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                            <strong>CONTRACT #</strong>
                                                        </td>
                                                        <td align="left" colspan="3" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblContract" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ContractNo")%>'/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                                <strong>START DATE</strong>
                                                        </td>
                                                        <td align="left" colspan="3" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblStartDate" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"StartDate")%>'/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                                <strong>END DATE</strong>
                                                        </td>
                                                        <td align="left" colspan="3" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblEndDate" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"EndDate")%>'/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                                <strong>PFC ITEM #</strong>
                                                        </td>
                                                        <td align="left" colspan="3" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblPFCItemNo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ItemNo")%>'/>&nbsp;
                                                            <asp:Label CssClass="cnt" ID="lblDescription" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ItemDesc")%>'/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                                <strong>CROSS REF #</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblRefNo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CrossRef")%>'/>
                                                        </td>
                                                         <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                                <strong>CUSTOMER PO</strong>
                                                        </td>
                                                        <td align="left" colspan="3" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblCusPO" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustomerPO")%>'/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                                <strong>SUB ITEM #</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead" style="width: 225px">
                                                            <asp:Label CssClass="cnt" ID="lblSubItemNo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"SubItemNo")%>'/>
                                                        </td>
                                                        <td height="1" class="splitBorder TabHead" style="width: 119px">
                                                                <strong>PFC SALES PERSON</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblSales" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"Salesperson")%>'/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                                <strong>ANNUAL USAGE QTY</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead" style="width: 225px">
                                                            <asp:Label CssClass="cnt" ID="lblQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"EAU_Qty")%>'/>
                                                        </td>
                                                        <td height="1" class="splitBorder TabHead" style="width: 119px">
                                                                <strong>CONTACT</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblContact" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"Contact")%>'/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                                <strong>PRICE PER UOM</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead" style="width: 225px">
                                                            <asp:Label CssClass="cnt" ID="lblPrice" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ContractPrice")%>'/>
                                                        </td>
                                                        <td height="1" class="splitBorder TabHead" style="width: 119px">
                                                                <strong>CONTACT PH#</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblPhone" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ContactPhone")%>'/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                                <strong>EXPECTED GP %</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead" style="width: 225px">
                                                            <asp:Label CssClass="cnt" ID="lblGp" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"E_Profit_Pct")%>'/>
                                                        </td>
                                                        <td height="1" class="splitBorder TabHead" style="width: 119px">
                                                                <strong>ORDER METHOD</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblOrder" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"OrderMethod")%>'/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" class="splitBorder TabHead" style="width: 116px">
                                                            <strong>VENDOR CODE</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead" style="width: 225px">
                                                            <asp:Label CssClass="cnt" ID="lblVendor" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"Vendor")%>'/>
                                                        </td>
                                                        <td height="1" class="splitBorder TabHead" style="width: 119px">
                                                            <strong>MONTH FACTOR</strong>
                                                        </td>
                                                        <td align="left" class="splitBorder TabHead">
                                                            <asp:Label CssClass="cnt" ID="lblMonth" runat="server"  Text='<%#DataBinder.Eval(Container.DataItem,"MonthFactor","{0:#,###.0}" )%>'/>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>                                        
                                        <tr>
                            <td valign="top" width="100%" colspan="2">
                                <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;left: 0px;height:273px;width:1010px; border: 0px solid;">
                                    <asp:DataGrid PageSize="20" ID="dgContract"  BackColor="#f4fbfd" AllowPaging="false"
                                        GridLines="both" runat="server" AutoGenerateColumns="False" PagerStyle-Visible="false" 
                                        OnItemDataBound="dgContract_ItemDataBound"
                                        BorderWidth="1px" AllowSorting="true" CssClass="BluBordAll" BorderColor="#c9c6c6">
                                        <HeaderStyle HorizontalAlign="left" VerticalAlign="Top" CssClass="GridHeads" BackColor="#dff3f9" />
                                        <ItemStyle CssClass="GridItem" Wrap="false" BackColor="#f4fbfd" />
                                        <FooterStyle HorizontalAlign="left" CssClass="GridHeads" BackColor="#dff3f9" />
                                        <AlternatingItemStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                        <Columns>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="Location" DataField="Branch" SortExpression="Branch" ItemStyle-Width="60" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="Annual QTY" DataField="Loc_EAU_Qty" DataFormatString="{0:#,###0}" SortExpression="Loc_EAU_Qty" ItemStyle-Wrap=false ItemStyle-Width="73" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="30 Day" DataField="Loc_EAU_30_Day_Qty" DataFormatString="{0:#,###0}" SortExpression="Loc_EAU_30_Day_Qty" ItemStyle-Wrap=false ItemStyle-Width="70" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="30 Day" DataField="Act_30D_Use_Qty" DataFormatString="{0:#,###0}" SortExpression="Act_30D_Use_Qty" ItemStyle-Wrap=false ItemStyle-Width="70" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="Forecast" DataField="Act_Forecast_Qty" DataFormatString="{0:#,###0}" SortExpression="Act_Forecast_Qty" ItemStyle-Wrap=false ItemStyle-Width="70" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="30 Day" DataField="Tot_Brn_30D_Qty" DataFormatString="{0:#,###0}" SortExpression="Tot_Brn_30D_Qty" ItemStyle-Width="60" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="Avail" DataField="Brn_Avail" DataFormatString="{0:#,###0}" SortExpression="Brn_Avail" ItemStyle-Width="50" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="Res QTY" DataField="VMI_Res_Qty" DataFormatString="{0:#,###0}" SortExpression="VMI_Res_Qty" ItemStyle-Width="70" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="Factor" DataField="VMI_Res_Factor" DataFormatString="{0:0.0}"  SortExpression="VMI_Res_Factor" ItemStyle-Width="50" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="Res Need" DataField="VMI_Res_Need_Qty" DataFormatString="{0:#,###0}" SortExpression="VMI_Res_Need_Qty" ItemStyle-Width="70" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="On Order" DataField="OO_Qty" DataFormatString="{0:#,###0}" SortExpression="OO_Qty" ItemStyle-Width="70" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="Date" DataField="Next_PO_Date" SortExpression="Next_PO_Date" ItemStyle-Width="103" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="QTY" DataField="Next_PO_Qty" DataFormatString="{0:#,###0}" SortExpression="Next_PO_Qty" ItemStyle-Width="60" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="STS" DataField="Next_PO_Status" SortExpression="Next_PO_Status" ItemStyle-Width="40" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="QTY" DataField="Trans_Qty" DataFormatString="{0:#,###0}" SortExpression="Trans_Qty" ItemStyle-Width="60" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="Date" DataField="Next_Trans_Date" SortExpression="Next_Trans_Date" ItemStyle-Width="100" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="QTY" DataField="Next_Trans_Qty" DataFormatString="{0:#,###0}" SortExpression="Next_Trans_Qty" ItemStyle-Width="60" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="Factor" DataField="Buy_Factor" DataFormatString="{0:0.0}" SortExpression="Buy_Factor" ItemStyle-Width="60" HeaderStyle-Wrap=false></asp:BoundColumn>
                                            <asp:BoundColumn FooterStyle-CssClass=GridHeads  HeaderStyle-CssClass=GridHeads ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" HeaderText="QTY" DataField="Buy_Qty" DataFormatString="{0:#,###0}" SortExpression="Buy_Qty" ItemStyle-Width="40" HeaderStyle-Wrap=false></asp:BoundColumn>
                                        </Columns>
                                    </asp:DataGrid>
                                    <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                    Visible="False"></asp:Label></center>
                                    </div>
                            </td>
                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                           
                        </Columns>
                    </asp:DataGrid>
                     
                </td>
            </tr>
            <tr>
                <td colspan="2" class="BluBg">
                    <table width="100%" id="tblPager" runat="SERVER">
                        <tr>
                            <td>
                                <uc1:pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged" />
                            </td>
                        </tr>
                    </table>
                     <input type=hidden runat=server id=hidSort/>
                </td>
            </tr>
            
            <tr>
                <td style="width: 753px">
                    <uc1:BottomFrame ID="BottomFrame1" runat="server" Visible="true" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
