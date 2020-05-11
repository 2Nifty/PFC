<%@ Page Language="C#" AutoEventWireup="true" CodeFile="eCommerceSalesAnalysisCustRpt.aspx.cs" Inherits="eCommerceSalesAnalysisCustRpt" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager"  TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>eCommerce Quote and Order Customer Report</title>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        .Border1
        {
            border-bottom:1px Solid #DAEEEF;
            border-collapse:collapse;
        }
        .Border2
        {
            border-right:1px Solid #DAEEEF;
            border-collapse:collapse;
        }
        .GridPad
        {
	        padding-top: 2px;
	        padding-bottom: 2px;
        }
    </style>

    <script type="text/javascript">
    function PrintReport()
    {
        var url= "Sort="+document.getElementById('hidSort').value+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>&Year=<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "" %>&Branch=<%= (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() : "" %>&CustNo=<%= (Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "" %>&StartDate=<%= (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "" %>&EndDate=<%= (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "" %>&MonthName=<%=Request.QueryString["MonthName"] %>&BranchName=<%=Request.QueryString["BranchName"] %>&RepName=<%=Request.QueryString["RepName"] %>&RepNo=<%=Request.QueryString["RepNo"] %>&PriceCdCtl=<%=Request.QueryString["PriceCdCtl"] %>&OrdSrc=<%=Request.QueryString["OrdSrc"] %>&ItemNotOrd=<%=Request.QueryString["ItemNotOrd"] %>';
        var hwin=window.open('eCommerceSalesAnalysisCustRptPreview.aspx?'+url, '', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
        hwin.focus();
    }
    
    function Close(session)
    {
        var str=eCommerceSalesAnalysisCustRpt.DeleteExcel('eCommerceSalesAnalysis'+session).value.toString();
        window.close();
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
        <asp:ScriptManager ID="smEcommRpt" runat="server" EnablePartialRendering="true" />
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
                                            eCommerce Quote and Order Customer Report
                                        </td>
                                        <td align="right" style="width: 30%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <img id="btnPrint" alt="print" style="cursor: hand" src="../common/images/Print.gif" onclick="javascript:PrintReport();" /></td>
                                                    <td>
                                                        <img id="btnClose" alt="close" src="../Common/images/close.gif" style="cursor: hand" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');" /></td>
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
            <tr id="trHead" class="PageBg" style="height:20px;">
                <td>
                    <table cellpadding="1" cellspacing="0" width="100%">
                        <tr>
                            <td class="LeftPadding TabHead" style="width: 110px">
                                Customer #
                                <%=(Request.QueryString["CustNo"].ToString() == "") ? "All" : Request.QueryString["CustNo"].ToString()%>
                            </td>
                            <td class="LeftPadding TabHead" style="width: 180px">
                                Branch:
                                <%=Request.QueryString["BranchName"].ToString()%>
                            </td>
                            <td class="TabHead" style="width: 200px">
                                Period:
                                <%=Request.QueryString["MonthName"].ToString()%>
                                <%=Request.QueryString["StartDate"].ToString()%>
                                -
                                <%=Request.QueryString["Year"].ToString()%>
                                <%=Request.QueryString["EndDate"].ToString()%>
                            </td>
                            <td class="TabHead" style="width: 150px">
                                CSR:
                                <%=Request.QueryString["RepName"].ToString()%>
                            </td>
                            <td width="100px;">
                                &nbsp;</td>
                            <td class="TabHead" style="width: 130px">
                                Run By:
                                <%= Session["UserName"].ToString() %>
                            </td>
                            <td class="TabHead" style="width: 130px">
                                Run Date:
                                <%=DateTime.Now.ToShortDateString()%>
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
                                    <asp:DataGrid ID="dgECommSales" Width="1750px" runat="server" GridLines="both" BorderWidth="1px" 
                                        ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false" BorderColor="#DAEEEF"
                                        AllowPaging="true" PageSize="17" PagerStyle-Visible="false" OnItemDataBound="dgECommSales_ItemDataBound"
                                        OnPageIndexChanged="dgECommSales_PageIndexChanged" OnSortCommand="dgECommSales_SortCommand">
                                        <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                            HorizontalAlign="Center" Wrap="true" />
                                        <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="#DAEEEF"
                                            Height="20px" HorizontalAlign="Left" Wrap="false" />
                                        <AlternatingItemStyle CssClass="GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                            HorizontalAlign="Left" Wrap="false" />
                                        <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                            HorizontalAlign="Center" Wrap="false" />
                                        <Columns>
                                            <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" HeaderText="Cust #" ItemStyle-Width="40"
                                                FooterStyle-BorderColor="#DAEEEF" DataField="CustomerNumber" SortExpression="CustomerNumber" />
                                            <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="250" HeaderText="Name" ItemStyle-Width="250"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right" DataField="CustomerName" SortExpression="CustomerName" />
                                            <asp:BoundColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="20" HeaderText="Brn" ItemStyle-Width="20"
                                                ItemStyle-HorizontalAlign="Center" FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="SalesLocationCode" SortExpression="SalesLocationCode" />

                                            <asp:TemplateColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" ItemStyle-Width="40" ItemStyle-HorizontalAlign="Right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right" SortExpression="NoOfECommQuotes">
                                                <ItemTemplate>
                                                    <asp:HyperLink ID="hplNoOfECommQuotes" runat="server" Text='<%# string.Format("{0:#,##0}",DataBinder.Eval(Container,"DataItem.NoOfECommQuotes"))%>'
                                                        NavigateUrl='<%# "eCommerceSalesAnalysisHdrRpt.aspx?Month="+Request.QueryString["Month"].ToString().Trim() + "&Year="+Request.QueryString["Year"].ToString().Trim() + "&StartDate="+Request.QueryString["StartDate"].ToString().Trim() + "&EndDate="+Request.QueryString["EndDate"].ToString().Trim() + "&CustomerNumber="+DataBinder.Eval(Container,"DataItem.customerNumber") + "&BranchNumber="+DataBinder.Eval(Container,"DataItem.SalesLocationCode") + "&CustomerName="+DataBinder.Eval(Container,"DataItem.CustomerName") + "&RepName="+Request.QueryString["RepName"].ToString().Trim() + "&RepNo="+Request.QueryString["RepNo"].ToString().Trim() + "&OrdSrc="+Request.QueryString["OrdSrc"].ToString().Trim() + "&ItemNotOrd="+Request.QueryString["ItemNotOrd"].ToString().Trim() + "&SrcTyp=ECOMM"%>'>
                                                    </asp:HyperLink>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="ECommExtAmount" DataFormatString="{0:c}" SortExpression="ECommExtAmount" />
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="ECommExtWeight" DataFormatString="{0:#,##0.00}" SortExpression="ECommExtWeight" />
                                                
                                            <asp:TemplateColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" ItemStyle-Width="40" ItemStyle-HorizontalAlign="Right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right" SortExpression="NoOfECommOrders">
                                                <ItemTemplate>
                                                    <asp:HyperLink ID="hplNoOfECommOrders" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.NoOfECommOrders")%>'
                                                        NavigateUrl='<%# "eCommerceSalesAnalysisHdrRpt.aspx?Month="+Request.QueryString["Month"].ToString().Trim()+"&Year="+Request.QueryString["Year"].ToString().Trim() +"&StartDate="+Request.QueryString["StartDate"].ToString().Trim() +"&EndDate="+Request.QueryString["EndDate"].ToString().Trim()+"&CustomerNumber=" + DataBinder.Eval(Container,"DataItem.customerNumber")+"&BranchNumber=" + DataBinder.Eval(Container,"DataItem.SalesLocationCode")+"&CustomerName=" + DataBinder.Eval(Container,"DataItem.CustomerName") + "&RepName=" + Request.QueryString["RepName"].ToString().Trim()+ "&RepNo=" + Request.QueryString["RepNo"].ToString().Trim() + "&OrdSrc="+Request.QueryString["OrdSrc"].ToString().Trim() + "&ItemNotOrd="+Request.QueryString["ItemNotOrd"].ToString().Trim() + "&SrcTyp=ECOMM_ORD"%>'>
                                                    </asp:HyperLink>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="ECommExtOrdAmount" DataFormatString="{0:c}" SortExpression="ECommExtOrdAmount" />
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="ECommExtOrdWeight" SortExpression="ECommExtOrdWeight" DataFormatString="{0:#,##0.00}" />

                                            <asp:TemplateColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" ItemStyle-Width="40" ItemStyle-HorizontalAlign="Right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right" SortExpression="NoOfManualQuotes">
                                                <ItemTemplate>
                                                    <asp:HyperLink ID="hplNoOfManualQuotes" runat="server" Text='<%# string.Format("{0:#,##0}",DataBinder.Eval(Container,"DataItem.NoOfManualQuotes"))%>'
                                                        NavigateUrl='<%# "eCommerceSalesAnalysisHdrRpt.aspx?Month="+Request.QueryString["Month"].ToString().Trim()+"&Year="+Request.QueryString["Year"].ToString().Trim() +"&StartDate="+Request.QueryString["StartDate"].ToString().Trim() +"&EndDate="+Request.QueryString["EndDate"].ToString().Trim()+"&CustomerNumber=" + DataBinder.Eval(Container,"DataItem.customerNumber")+"&BranchNumber=" + DataBinder.Eval(Container,"DataItem.SalesLocationCode")+"&CustomerName=" + DataBinder.Eval(Container,"DataItem.CustomerName")+ "&RepName=" + Request.QueryString["RepName"].ToString().Trim()+ "&RepNo=" + Request.QueryString["RepNo"].ToString().Trim() + "&OrdSrc="+Request.QueryString["OrdSrc"].ToString().Trim() + "&ItemNotOrd="+Request.QueryString["ItemNotOrd"].ToString().Trim() + "&SrcTyp=MANUAL"%>'>
                                                    </asp:HyperLink>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="ManualExtAmount" DataFormatString="{0:c}" SortExpression="ManualExtAmount" />
                                            <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended Weight" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="ManualExtWeight" DataFormatString="{0:#,##0.00}" SortExpression="ManualExtWeight" />
                                                
                                            <asp:TemplateColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" HeaderText="# of Orders" ItemStyle-Width="40" ItemStyle-HorizontalAlign="Right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right" SortExpression="NoOfManualOrders">
                                                <ItemTemplate>
                                                    <asp:HyperLink ID="hplNoOfManualOrders" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.NoOfManualOrders")%>'
                                                        NavigateUrl='<%# "eCommerceSalesAnalysisHdrRpt.aspx?Month="+Request.QueryString["Month"].ToString().Trim()+"&Year="+Request.QueryString["Year"].ToString().Trim() +"&StartDate="+Request.QueryString["StartDate"].ToString().Trim() +"&EndDate="+Request.QueryString["EndDate"].ToString().Trim()+"&CustomerNumber=" + DataBinder.Eval(Container,"DataItem.customerNumber")+"&BranchNumber=" + DataBinder.Eval(Container,"DataItem.SalesLocationCode")+"&CustomerName=" + DataBinder.Eval(Container,"DataItem.CustomerName") + "&RepName=" + Request.QueryString["RepName"].ToString().Trim()+ "&RepNo=" + Request.QueryString["RepNo"].ToString().Trim() + "&OrdSrc="+Request.QueryString["OrdSrc"].ToString().Trim() + "&ItemNotOrd="+Request.QueryString["ItemNotOrd"].ToString().Trim() + "&SrcTyp=MANUAL_ORD"%>'>
                                                    </asp:HyperLink>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="ManualExtOrdAmount" DataFormatString="{0:c}" SortExpression="ManualExtOrdAmount" />
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="ManualExtOrdWeight" SortExpression="ManualExtOrdWeight" DataFormatString="{0:#,##0.00}" />

                                            <asp:TemplateColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" ItemStyle-Width="40" ItemStyle-HorizontalAlign="Right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right" SortExpression="NoOfMissedECommQuotes">
                                                <ItemTemplate>
                                                    <asp:HyperLink ID="hplNoOfMissedECommQuotes" runat="server" Text='<%# string.Format("{0:#,##0}",DataBinder.Eval(Container,"DataItem.NoOfMissedECommQuotes"))%>'
                                                        NavigateUrl='<%# "eCommerceSalesAnalysisHdrRpt.aspx?Month="+Request.QueryString["Month"].ToString().Trim()+"&Year="+Request.QueryString["Year"].ToString().Trim() +"&StartDate="+Request.QueryString["StartDate"].ToString().Trim() +"&EndDate="+Request.QueryString["EndDate"].ToString().Trim()+"&CustomerNumber=" + DataBinder.Eval(Container,"DataItem.customerNumber")+"&BranchNumber=" + DataBinder.Eval(Container,"DataItem.SalesLocationCode")+"&CustomerName=" + DataBinder.Eval(Container,"DataItem.CustomerName")+ "&RepName=" + Request.QueryString["RepName"].ToString().Trim()+ "&RepNo=" + Request.QueryString["RepNo"].ToString().Trim() + "&OrdSrc="+Request.QueryString["OrdSrc"].ToString().Trim() + "&ItemNotOrd="+Request.QueryString["ItemNotOrd"].ToString().Trim() + "&SrcTyp=MISSED_ECOMM"%>'>
                                                    </asp:HyperLink>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="MissedECommExtAmount" DataFormatString="{0:c}" SortExpression="MissedECommExtAmount" />
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="MissedECommExtWeight" DataFormatString="{0:#,##0.00}" SortExpression="MissedECommExtWeight" />

                                            <asp:TemplateColumn HeaderStyle-BorderColor="#DAEEEF" HeaderStyle-Width="40" ItemStyle-Width="40" ItemStyle-HorizontalAlign="Right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right" SortExpression="NoOfMissedManualQuotes">
                                                <ItemTemplate>
                                                    <asp:HyperLink ID="hplNoOfMissedManualQuotes" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.NoOfMissedManualQuotes")%>'
                                                        NavigateUrl='<%# "eCommerceSalesAnalysisHdrRpt.aspx?Month="+Request.QueryString["Month"].ToString().Trim()+"&Year="+Request.QueryString["Year"].ToString().Trim() +"&StartDate="+Request.QueryString["StartDate"].ToString().Trim() +"&EndDate="+Request.QueryString["EndDate"].ToString().Trim()+"&CustomerNumber=" + DataBinder.Eval(Container,"DataItem.customerNumber")+"&BranchNumber=" + DataBinder.Eval(Container,"DataItem.SalesLocationCode")+"&CustomerName=" + DataBinder.Eval(Container,"DataItem.CustomerName") + "&RepName=" + Request.QueryString["RepName"].ToString().Trim()+ "&RepNo=" + Request.QueryString["RepNo"].ToString().Trim() + "&OrdSrc="+Request.QueryString["OrdSrc"].ToString().Trim() + "&ItemNotOrd="+Request.QueryString["ItemNotOrd"].ToString().Trim() + "&SrcTyp=MISSED_MANUAL"%>'>
                                                    </asp:HyperLink>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="MissedManualExtAmount" DataFormatString="{0:c}" SortExpression="MissedManualExtAmount" />
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right"
                                                FooterStyle-BorderColor="#DAEEEF" FooterStyle-HorizontalAlign="right"
                                                DataField="MissedManualExtWeight" SortExpression="MissedManualExtWeight" DataFormatString="{0:#,##0.00}" />
                                        </Columns>
                                    </asp:DataGrid>
                                    <center>
                                        <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found" Visible="False"></asp:Label>
                                    </center>
                            </div>
                            <asp:Button ID="btnSort" runat="server" Text="" Style="display: none;" OnClick="btnSort_Click" />
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
