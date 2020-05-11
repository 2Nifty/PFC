<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BranchCustomerSalesAnalysis.aspx.cs" Inherits="BranchCustomerSalesAnalysis" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Sales Analysis Report</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <script> 

        // Javascript Function To Show The Preview Page
        function PrintReport(version,period)
        {
            var url="Version="+version+"&Period="+period+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>' +
                      "&Year=" + '<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "" %>' +
                      "&Branch=" + '<%= (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() :"" %>' +
                      "&BranchName=" + '<%= (Request.QueryString["BranchName"] != null) ? Request.QueryString["BranchName"].ToString().Trim() :"" %>' +
                      "&Chain=" + '<%=(Request.QueryString["Chain"] != null) ? Request.QueryString["Chain"].ToString().Trim() : "" %>' +
                      "&CustNo=" +'<%=(Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "" %>'+
                      "&Item=" +'<%=(Request.QueryString["Item"] != null) ? Request.QueryString["Item"].ToString().Trim() : "" %>'+
                      "&MonthName=" +'<%=(Request.QueryString["MonthName"] != null) ? Request.QueryString["MonthName"].ToString().Trim() : "" %>';
            
            var a=window.screen.availWidth-60;
            window.open('BranchCustomerSalesAnalysisPreview.aspx?'+url, '', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
         
        }
        
        // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
         var str=BranchCustomerSalesAnalysis.DeleteExcel('BranchCustomerSalesAnalysis'+session).value.toString();
           parent.window.close();
       }
       
      
    </script>

</head>
<body bottommargin="0">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td colspan="2" height=20px>
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td colspan="2" valign="middle" class="PageHead">
                                <table width="100%"  cellspacing="0" cellpadding="0" border="0">
                                    <tr align=right>
                                        <td valign=middle style="height: 20px"><div align="left" class="LeftPadding">Branch Customer Sales Analysis</div></td>
                                        
                                        <td valign=middle style="height: 20px" class="TabHead">
                                            <asp:RadioButton style="vertical-align:middle;" ID="rdoReportVersion1" runat="server" Checked=true Visible=false Text="Long Version" GroupName="ReportVersion"/>
                                            <asp:RadioButton style="vertical-align:middle;" ID="rdoReportVersion2" Text="Short Version" runat="server" GroupName="ReportVersion" Visible=false/>
                                        </td>
                                        
                                        <td valign="middle">
                                            <a href='<%= GetFileURL() %>'><img  border=0 src="../common/images/ExporttoExcel.gif" /></a>
                                            <asp:ImageButton  ImageUrl="../common/images/Print.gif" runat=server id="btnPrint" Text="Print" OnClick="btnPrint_Click"/>
                                            <img style="cursor:hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                                <table width="100%" cellpadding="0" cellspacing="0" >
                                    <tr>
                                        <td height="19px" class="TabHead"><span class="LeftPadding">Period : <%=Request.QueryString["MonthName"].ToString() + " " + Request.QueryString["Year"].ToString()%></span></td>
                                        <td class="TabHead">
                                            <span class="LeftPadding">Branch :
                                                <%=Request.QueryString["BranchName"].ToString() %>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span class="LeftPadding">Item :
                                                <%=Request.QueryString["Item"].ToString() %>
                                            </span>
                                        </td>

                                        <td class="TabHead">
                                            <span class="LeftPadding">Fiscal Year :
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
                                        <td align="left" class="TabHead"><span class="LeftPadding">
                                        Run By : <%= Session["UserName"].ToString()%></span>
                                        </td>                                        
                                        <td align="left" class="TabHead">
                                            <span class="LeftPadding">Run Date : <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
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
                                            <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px; left: 0px;
                                                width: 1000px; height: 488px; border: 0px solid;">
                                                <asp:DataGrid PageSize="20" ID="dgAnalysis" BackColor="#f4fbfd" AllowPaging="true" GridLines=Both
                                                    runat="server" Width="2000px" AutoGenerateColumns="false" PagerStyle-Visible="false"
                                                    BorderWidth="1" AllowSorting="true"
                                                    OnSortCommand="dgAnalysis_SortCommand" OnItemDataBound="dgAnalysis_ItemDataBound" >
                                                    <HeaderStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                                    <FooterStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                                    <ItemStyle Wrap=false CssClass="GridItem" BackColor="#f4fbfd" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                                    <Columns>
                                                    <asp:BoundColumn HeaderText="CustNo" DataField="CustNo" SortExpression="CustNo" ItemStyle-Wrap=false FooterStyle-Wrap=false HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustName" DataField="CustName" SortExpression="CustName" ItemStyle-Wrap=false HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustCity" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem       DataField="CustCity" SortExpression="CustCity" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="SalesLoc" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataField="SalesLoc" SortExpression="SalesLoc" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Chain"    FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataField="Chain" SortExpression="Chain" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMSales"  FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:#,##0}" DataField="CMSales" SortExpression="CMSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMSales"  FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:#,##0}" DataField="LMSales" SortExpression="LMSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CGM"      FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:#,##0}" DataField="CGM" SortExpression="CGM"  ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CGMPct"   FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:0.0}" DataField="CGMPct"  SortExpression="CGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMGM"     FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:#,##0}" DataField="LMGM" SortExpression="LMGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMGMPct"  FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:0.0}" DataField="LMGMPct"  SortExpression="LMGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMWgt"    FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem      DataFormatString="{0:#,##0}"  DataField="CMWgt" SortExpression="CMWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:0.00}" DataField="CMDollarLb" SortExpression="CMDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMWgt"      FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}"  DataField="LMWgt" SortExpression="LMWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:0.00}"  DataField="LMDollarLb" SortExpression="LMDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDSales"   FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}"  DataField="YTDSales" SortExpression="YTDSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDSales"  FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}" DataField="LYTDSales" SortExpression="LYTDSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDGM"      FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}"  DataField="YTDGM" SortExpression="YTDGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDGMPct"   FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:0.0}" DataField="YTDGMPct" SortExpression="YTDGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDGM"     FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}"  DataField="LYTDGM" SortExpression="LYTDGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDGMPct"  FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:0.0}"  DataField="LYTDGMPct" SortExpression="LYTDGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDWgt"     FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem    DataFormatString="{0:#,##0}"  DataField="YTDWgt" SortExpression="YTDWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem   DataFormatString="{0:0.00}"  DataField="YTDDollarLb" SortExpression="YTDDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDWgt"     FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem   DataFormatString="{0:#,##0}" DataField="LYTDWgt" SortExpression="LYTDWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  DataFormatString="{0:0.00}" DataField="LYTDDollarLb" SortExpression="LYTDDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustRep"      FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  DataField="CustRep" SortExpression="CustRep" ItemStyle-HorizontalAlign="left" ItemStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustGroup"    FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  DataField="CustGroup" SortExpression="CustGroup" ItemStyle-HorizontalAlign="left" ItemStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Zip"          FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem  DataField="CustZip" SortExpression="CustZip" ItemStyle-HorizontalAlign="left" ItemStyle-Wrap=false></asp:BoundColumn>
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
                                <asp:HiddenField runat=server id =hidSort />
                                <asp:HiddenField runat=server id =hidSortField />
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
