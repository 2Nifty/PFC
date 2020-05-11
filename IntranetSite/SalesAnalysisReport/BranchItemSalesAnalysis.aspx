<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BranchItemSalesAnalysis.aspx.cs"
    Inherits="BranchItemSalesAnalysis" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Branchwise Item Sales Analysis Report</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script> 
   
        // Javascript Function To Show Preview Page
        function PrintReport(version,period)
        {
                     var url= "period="+period+"&version="+version+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>' +
                              "&Year=" + '<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "" %>' +
                              "&Branch=" + '<%= (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() :"" %>' +
                              "&BranchName=" + '<%= (Request.QueryString["BranchName"] != null) ? Request.QueryString["BranchName"].ToString().Trim() :"" %>' +
                              "&Chain=" + '<%=(Request.QueryString["Chain"] != null) ? Request.QueryString["Chain"].ToString().Trim() : "" %>' +
                              "&CustNo=" +'<%=(Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "" %>'+
                              "&MonthName=" +'<%=(Request.QueryString["MonthName"] != null) ? Request.QueryString["MonthName"].ToString().Trim() : "" %>'+
                             "&CategoryFrom=" +'<%=(Request.QueryString["CategoryFrom"] != null) ? Request.QueryString["CategoryFrom"].ToString().Trim() : "" %>'+
                              "&CategoryTo=" +'<%=(Request.QueryString["CategoryTo"] != null) ? Request.QueryString["CategoryTo"].ToString().Trim() : "" %>'+
                              "&VarianceFrom=" +'<%=(Request.QueryString["VarianceFrom"] != null) ? Request.QueryString["VarianceFrom"].ToString().Trim() : "" %>'+
                              "&VarianceTo=" +'<%=(Request.QueryString["VarianceTo"] != null) ? Request.QueryString["VarianceTo"].ToString().Trim() : "" %>';
                    
                    var a=window.screen.availWidth-60;
                    window.open('BranchItemSalesAnalysisPreview.aspx?'+url, '', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
        }


       // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
        
           var str=BranchItemSalesAnalysis.DeleteExcel('BranchItemSalesAnalysis'+session).value.toString();
           parent.window.close();
       }


    </script>

</head>
<body bottommargin="0">
    <form id="form1" runat="server">
        <table width="100%" border="0"  cellspacing="0" cellpadding="0">
            <tr>
                <td colspan="2">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td colspan="2" valign="middle" class="PageHead">
                                <table width=100% border="0" cellspacing="0" cellpadding="0">
                                    <tr height=20px>
                                        <td style="height: 20px"><div align="left" class="LeftPadding">Branch Item Sales Analysis</div></td>
                                        
                                        <td style="height: 20px" valign=middle class="TabHead">
                                           <span class="TabHead" runat="server" id="spnPeriod">Period Type :</span>
                                           <asp:RadioButton style="vertical-align:middle;" ID="rdoDate1" runat="server" AutoPostBack="true" Text="MTD " GroupName="DateGroup" OnCheckedChanged="rdoDate1_CheckedChanged"/>     
                                           <asp:RadioButton style="vertical-align:middle;" ID="rdoDate2" runat="server" Checked="true" AutoPostBack="true" Text="YTD " GroupName="DateGroup" OnCheckedChanged="rdoDate2_CheckedChanged"/>
                                        </td>
                                        
                                        <td class="TabHead" valign=middle runat=server id=spnVersion>
                                             <span class="TabHead">Report Version :</span>
                                             <asp:RadioButton ID="rdoReportVersion1" style="vertical-align:middle;" runat="server" Checked="true" AutoPostBack="true" Text="Long Version" GroupName="ReportVersion" OnCheckedChanged="rdoReportVersion1_CheckedChanged"/>
                                             <asp:RadioButton ID="rdoReportVersion2" style="vertical-align:middle;" AutoPostBack="true" Text="Short Version" runat="server" GroupName="ReportVersion" OnCheckedChanged="rdoReportVersion2_CheckedChanged"/>
                                        </td>
                                        
                                        <td align=right>
                                            <a href='<%= GetFileURL() %>'><img border="0" src="../common/images/ExporttoExcel.gif" /></a>
                                            <asp:ImageButton ImageUrl="../common/images/Print.gif" runat="server" ID="btnPrint" OnClick="btnPrint_Click" />
                                            <img style="cursor: hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');" />
                                        </td>
                                        
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                                <table width="100%" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td height="19px" class="TabHead">
                                            <span class="LeftPadding">Period :
                                                <%=Request.QueryString["MonthName"].ToString() + " " + Request.QueryString["Year"].ToString()%>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span class="LeftPadding">Branch :
                                                <%=Request.QueryString["BranchName"].ToString() %>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span class="LeftPadding">Category : </span><span>
                                                <%=(Request.QueryString["CategoryFrom"] == "" && Request.QueryString["CategoryTo"] == "") ? "All" :Request.QueryString["CategoryFrom"].ToString()+" - " +Request.QueryString["CategoryTo"].ToString() %>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span class="LeftPadding">Variance : </span><span>
                                                <%=(Request.QueryString["VarianceFrom"] == "" && Request.QueryString["VarianceTo"] == "") ? "All" : Request.QueryString["VarianceFrom"].ToString() + " - " + Request.QueryString["VarianceTo"].ToString()%>
                                            </span>
                                        </td>
                                        <td align="Left" class="TabHead">
                                            <span class="LeftPadding">Run By :
                                                <%= Session["UserName"].ToString()%>
                                            </span>
                                        </td>
                                        <td align="right" class="TabHead">
                                            <span class="LeftPadding">Run Date :
                                                <%=DateTime.Now.Month%>
                                                /<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" bgcolor="#EFF9FC" colspan="2">
                                <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                    Visible="False"></asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" width="100%">
                                            <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; width: 1000px; height: 488px; border: 0px solid;">
                                                <asp:DataGrid ID="dgAnalysis" BackColor="#f4fbfd" AllowPaging="true" runat="server"
                                                    AutoGenerateColumns="false" PagerStyle-Visible="false" OnItemDataBound="dgAnalysis_ItemDataBound"
                                                    BorderWidth="1" AllowSorting="true" OnSortCommand="dgAnalysis_SortCommand" GridLines="both"
                                                    ShowFooter="false">
                                                    <HeaderStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                                    <FooterStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                                    <ItemStyle CssClass="GridItem" BackColor="#f4fbfd" Wrap="false" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                                    <Columns>
                                                        <asp:BoundColumn HeaderText="Item" DataField="Item" SortExpression="Item" ItemStyle-Wrap=false></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="ItemDesc" DataField="ItemDesc" SortExpression="ItemDesc" ItemStyle-Wrap=false>
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="UOM" DataField="UOM" SortExpression="UOM" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  HeaderStyle-Wrap=false></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_InvQty" DataFormatString="{0:#,##0}" DataField="CM_InvQty" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false 
                                                            SortExpression="CM_InvQty" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_sales" DataFormatString="{0:#,##0}" DataField="CM_sales" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  HeaderStyle-Wrap=false
                                                            SortExpression="CM_sales" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_GM$" DataFormatString="{0:#,##0}" DataField="CM_GM$" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CM_GM$" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_GMPer" DataFormatString="{0:0.0}" DataField="CM_GMPer" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CM_GMPer" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_SellWgt" DataFormatString="{0:#,##0}" DataField="CM_SellWgt" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false 
                                                            SortExpression="CM_SellWgt" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_Lb" DataFormatString="{0:0.00}" DataField="CM_Lb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CM_Lb" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CM_order" DataField="CM_order" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  HeaderStyle-Wrap=false
                                                            SortExpression="CM_order" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_InvQty" DataField="CY_InvQty" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_InvQty" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_InvQty" DataField="PY_InvQty" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_InvQty" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_Sales" DataField="CY_Sales" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_Sales" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_Sales" DataField="PY_Sales" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_Sales" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_GM$" DataField="CY_GM$" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_GM$" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_GM$" DataField="PY_GM$" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_GM$" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_GMPer" DataField="CY_GMPer" DataFormatString="{0:0.0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_GMPer" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_GMPer" DataField="PY_GMPer" DataFormatString="{0:0.0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_GMPer" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_Sellwgt" DataField="CY_Sellwgt" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_Sellwgt" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_Sellwgt" DataField="PY_Sellwgt" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_Sellwgt" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_Lb" DataField="CY_Lb" DataFormatString="{0:0.00}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_Lb" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_Lb" DataField="PY_Lb" DataFormatString="{0:0.00}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_Lb" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="CY_Order" DataField="CY_Order" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead  ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="CY_Order" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="PY_Order" DataField="PY_Order" DataFormatString="{0:#,##0}" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead  ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false
                                                            SortExpression="PY_Order" ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="BluBg">
                                <table width="100%" id="tblPager" runat="SERVER">
                                    <tr>
                                        <td>
                                            <uc1:pager ID="Pager1" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                                <input type="hidden" runat="server" id="hidSort" />
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
