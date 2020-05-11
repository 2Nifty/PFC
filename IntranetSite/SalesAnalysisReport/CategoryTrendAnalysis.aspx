<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CategoryTrendAnalysis.aspx.cs" Inherits="CategoryTrendAnalysis" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>CategoryTrend Analysis Report</title>
    <link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet"   type="text/css" />
   <Script>
        function ShowHide(SHMode)
        {
	        if (SHMode.id == "Hide") {
		        document.getElementById("HideLabel").style.display = "none";
		        document.getElementById("LeftMenu").style.display = "none";
		        document.getElementById("LeftMenuContainer").style.width = "1";
		        document.getElementById("SHButton").innerHTML = "<img ID='Show' src='Images/ShowButton.gif' width='22' height='21' onClick='ShowHide(this)'>";
		        //alert(document.getElementById(SHMode.id));
	        }
	        if (SHMode.id == "ShowTopMenu") {
		        document.getElementById("TopMenu").style.display = "block";
		        //document.getElementById("LeftMenu").style.display = "block";
		        //document.getElementById("LeftMenuContainer").style.width = "230";
		        document.getElementById("TopMenuControl").innerHTML = "<input name='HideTopMenu' id='HideTopMenu' type='button' class='FormButton' value='Hide this Menu' onClick='ShowHide(this)'>";
		        //alert(document.getElementById(SHMode.id));
	        }
	        if (SHMode.id == "HideTopMenu") {
		        document.getElementById("TopMenu").style.display = "none";
		        //document.getElementById("LeftMenu").style.display = "block";
		        //document.getElementById("LeftMenuContainer").style.width = "230";
		        document.getElementById("TopMenuControl").innerHTML = "<input name='ShowTopMenu' id='ShowTopMenu' type='button' class='FormButton' value='Show this Menu' onClick='ShowHide(this)'>";
		        //alert(document.getElementById(SHMode.id));
	        }
	        if (SHMode.id == "Show") {
		        document.getElementById("HideLabel").style.display = "block";
		        document.getElementById("LeftMenu").style.display = "block";
		        document.getElementById("LeftMenuContainer").style.width = "230";
		        document.getElementById("SHButton").innerHTML = "<img ID='Hide' src='Images/HidButton.gif' width='22' height='21' onClick='ShowHide(this)'>";
		        //alert(document.getElementById(SHMode.id));
	        }
        }
       
        // Javascript Function to show the preview page 
        function PrintReport()
        {
             var url="Branch=" + '<%=Request.QueryString["Branch"] %>' +
                      "&BranchID=" + '<%=Request.QueryString["BranchID"] %>' +
                      "&StDate=" + '<%=Request.QueryString["StDate"] %>' +
                      "&EndDate=" + document.getElementById("hidEndDate").value +
                      "&Period=" +'<%=Request.QueryString["Period"] %>'+
                      "&CategoryFrom="+'<%=Request.QueryString["CategoryFrom"] %>'+"&CategoryTo="+'<%=Request.QueryString["CategoryTo"] %>'+
                      "&VarianceFrom="+'<%=Request.QueryString["VarianceFrom"] %>' +"&VarianceTo="+'<%=Request.QueryString["VarianceFrom"] %>'+
                      "&Sort="+document.getElementById("hidSort").value+"&Version="+document.getElementById("hidVersion").value;
            
            var a=window.screen.availWidth-60;
            window.open('CategoryTrendPreview.aspx?'+url, '', 'height=700,width=840,scrollbars=no,status=no,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (840/2))+',resizable=no');
        }
        
       
       // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
           var str=CategoryTrendAnalysis.DeleteExcel('CategoryTrendAnalysis'+session).value.toString();
           parent.window.close();
       }
       
</Script>

</head>
<body >
    <form id="form1" runat="server">
        
    <table  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td colspan="2"><table   border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td colspan="2" valign="middle" class="PageHead">
                <table   border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                      <td style="height: 26px" valign=middle><div align="left" class="LeftPadding">Category Trend Analysis</div></td>
                      <td style="height: 26px" valign=middle class="TabHead">
                            <span class="TabHead" style="vertical-align:middle;">Report Version :</span>
                            <asp:RadioButton style="vertical-align:middle;" ID="rdoReportVersion1" runat="server" Checked=true  AutoPostBack=true Text="Long Version" GroupName="ReportVersion" OnCheckedChanged="rdoReportVersion1_CheckedChanged"/>
                            <asp:RadioButton style="vertical-align:middle;" ID="rdoReportVersion2" AutoPostBack=true Text="Short Version" runat="server" GroupName="ReportVersion" OnCheckedChanged="rdoReportVersion2_CheckedChanged"/>
                        </td>
                        <td style="height: 26px" valign=middle align=right>
                            <a href='<%= GetFileURL() %>' ><img  border=0 src="../common/images/ExporttoExcel.gif" /></a>
                              <img style="cursor:hand" src="../common/images/Print.gif" id="btnPrint"  onclick="PrintReport()" />
                              <img style="cursor:hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"/>
                        </td>
                    </tr>
                </table>
            </td>
          </tr>
      <tr>
        <td colspan=2 align="left" class="PageBg">
        <table cellpadding=0 cellspacing=0 width=100%>
                <tr>
                    <td class=TabHead height="22px"><span>Category : <%=(Request.QueryString["CategoryFrom"] == "" && Request.QueryString["CategoryTo"] == "") ? "All" :Request.QueryString["CategoryFrom"].ToString()+" - " +Request.QueryString["CategoryTo"].ToString() %>
                    </span>
                    </td>
                    <td class=TabHead >&nbsp;&nbsp;<span>Variance : 
                    <%=(Request.QueryString["VarianceFrom"] == "" && Request.QueryString["VarianceTo"] == "") ? "All" : Request.QueryString["VarianceFrom"].ToString() + " - " + Request.QueryString["VarianceTo"].ToString()%>
                    </span></td>

                    <td class=TabHead >&nbsp;&nbsp;<span>Branch : <%=Request.QueryString["Branch"].ToString() %></span></td>
                    <td class=TabHead >&nbsp;&nbsp;<span>Fiscal Period : <%=Request.QueryString["Period"].ToString()%></span></td>
                    <td align="left" class="TabHead">&nbsp;&nbsp;<span>
                    Run By : <%= Session["UserName"].ToString()%></span>
                    </td>                                        
                    <td align="left" class="TabHead">&nbsp;&nbsp;
                        <span>Run Date : <%=DateTime.Now.ToShortDateString()%></span></td>
                    
                </tr>
            </table>
        </td>
    </tr>
    <tr><td colspan=2 align=center><asp:Label ID=lblMsg ForeColor=red Visible=true runat=server CssClass="TabHead" Text="No Records Found"></asp:Label></td></tr>
      <tr>
        <td colspan="2" id=tdGrid runat=server><table class="BluBordAll"   border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="top">                
                <div id=div-datagrid class="Sbar" style="overflow: auto; position: relative; top: 0px; left: 0px;width: 835px; height: 490px; border: 0px solid;">
                <div id="PrintDG3"> 
                    <asp:DataGrid PageSize=2 BorderWidth=0px  BorderColor=#c9c6c6 ShowHeader=false PagerStyle-Visible=false  ID=dgReport  AllowPaging=true AutoGenerateColumns=false GridLines=both  runat=server  OnPageIndexChanged="dgReport_PageIndexChanged">
                        <Columns>
                            <asp:TemplateColumn>
                                <ItemTemplate>
                                    <table cellpadding=0 cellspacing=0 width=100% >
                                        <tr bgcolor="#F4FBFD"><td colspan=4 height=5px></td></tr>
                                        <tr bgcolor="#F4FBFD"><td width=7% class=TabHead height=18px>Category :</td><td width=25%><asp:Label ID=lblCategory runat=server CssClass=cnt Text='<%#DataBinder.Eval(Container,"DataItem.Category")%>'></asp:Label>&nbsp;<asp:Label CssClass=cnt ID=lblItemDescription runat=server Text='<%#GetDescription(Container)%>'></asp:Label></td>
                                        <td width=7% class=TabHead height=18px>Plating &nbsp;&nbsp;&nbsp;&nbsp;:</td><td width=25%><asp:Label ID=lblPlating runat=server CssClass=cnt Text='<%#DataBinder.Eval(Container,"DataItem.Plating")%>'></asp:Label><span class=cnt>-</span><asp:Label CssClass=cnt ID=lblPlatingDescription runat=server Text='<%#DataBinder.Eval(Container,"DataItem.PlatingDescription")%>'></asp:Label></td></tr>
                                        <tr bgcolor="#F4FBFD"><td width=7% class=TabHead height=18px>Branch &nbsp;&nbsp;&nbsp;&nbsp;:</td ><td><asp:Label ID=lblBranch CssClass=cnt runat=server Text='<%#Request.QueryString["Branch"].ToString()%>'></asp:Label></td>
                                        <td width=7% class=TabHead height=18px>Variance :</td><td width=40%><asp:Label ID=lblVariance runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Variance")%>' CssClass=cnt></asp:Label></td></tr>
                                        <tr >
                                            <td colspan=4 align=left>
                                                
                                                <asp:DataGrid ID=dgAnalysis runat=server  BorderWidth=1 GridLines=Both  AutoGenerateColumns=false OnItemDataBound="dgAnalysis_ItemDataBound" AllowSorting=true OnSortCommand="dgAnalysis_SortCommand">
                                                <HeaderStyle CssClass=GridHead BackColor=#dff3f9 BorderStyle=Solid BorderWidth=1px  Wrap=False/>
                                                <ItemStyle CssClass=GridItem BackColor="#f4fbfd" BorderStyle=Solid BorderWidth=1px Wrap=False/>
                                                <AlternatingItemStyle CssClass=GridItem BackColor=#FFFFFF BorderWidth=0 Wrap=False/>
                                                    <Columns>
                                                    
                                                        <asp:TemplateColumn HeaderText="Period" ItemStyle-HorizontalAlign="left" ItemStyle-Width=100px SortExpression="Fiscalyear,FiscalMonth" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate>
                                                            <asp:HyperLink ID=lblPeriod runat=server Text='<%#GetText(Container) %>' Target=_blank NavigateUrl='<%# GetUrl(Container)%>'></asp:HyperLink></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn  HeaderText="Qty" ItemStyle-HorizontalAlign="right" SortExpression=Qty FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate>
                                                                <asp:Label ID=lblQty runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Qty","{0:#,###}")%>'></asp:Label>
                                                                <asp:Label ID=lblFiscalMonth runat=server Visible=false Text='<%#DataBinder.Eval(Container,"DataItem.FiscalMonth") %>'></asp:Label>
                                                                <asp:Label ID=lblFiscalYear runat=server Visible=false Text='<%#DataBinder.Eval(Container,"DataItem.FiscalYear") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn HeaderText="Sales" ItemStyle-HorizontalAlign="right" SortExpression=Sales FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblSales runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Sales","{0:#,###}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn HeaderText="Cost" ItemStyle-HorizontalAlign="right" SortExpression=Cost FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblPeriod runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Cost","{0:#,###}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn HeaderText="GM%" HeaderStyle-Width=50px ItemStyle-HorizontalAlign="right" SortExpression=GM FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblCost runat=server Text='<%#DataBinder.Eval(Container,"DataItem.GM","{0:0.0}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn HeaderStyle-Width=90px HeaderText="% Of Total Sales" ItemStyle-HorizontalAlign="right" SortExpression=Totsales FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblSales1 runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Totsales","{0:0.0}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn HeaderText="Ext Wgt" ItemStyle-Width=60px ItemStyle-HorizontalAlign="right" SortExpression=ExtWgt FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblExtWgt runat=server Text='<%#DataBinder.Eval(Container,"DataItem.ExtWgt","{0:#,###}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn HeaderText="Sell $/Lb" HeaderStyle-Width=70px ItemStyle-HorizontalAlign="right" SortExpression=SellLb ItemStyle-Width=70px FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblSellLb runat=server Text='<%#DataBinder.Eval(Container,"DataItem.SellLb","{0:0.00}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn HeaderText="Cost $/Lb" HeaderStyle-Width=70px ItemStyle-HorizontalAlign="right" SortExpression=CostLb ItemStyle-Width=70px FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblCostLb runat=server Text='<%#DataBinder.Eval(Container,"DataItem.CostLb","{0:0.00}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn HeaderStyle-Width=70px  HeaderText="GM $/Lb" ItemStyle-HorizontalAlign="right" SortExpression=GMLb FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false>
                                                            <ItemTemplate><asp:Label ID=lblGMLb runat=server Text='<%#DataBinder.Eval(Container,"DataItem.GMLb","{0:0.00}") %>'></asp:Label></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                    </Columns>
                                            </asp:DataGrid>       
                                            <asp:Label ID=lblMessage runat=server Text="No Records Found" CssClass=GridHead ForeColor=red Visible=true></asp:Label>
                                            </td>
                                        </tr>
                                        <tr bgcolor="#F4FBFD"><td colspan=4 height=20px></td></tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <PagerStyle Visible="False" />
                    </asp:DataGrid>
                </div>
                </div>
              </td>
            </tr>
        </table></td>
      </tr>
      <tr>
         <td colspan="2" id=tdPager runat=server class="BluBg"><uc1:pager id="Pager1" runat="server"></uc1:pager></td>
      </tr>
    </table>
	  </td>
  </tr>
     <tr><td> <asp:HiddenField ID="hidEndDate" runat="server" /><asp:HiddenField ID="hidVersion" runat="server" /><input type=hidden ID="hidSort" runat="server" />
    </td></tr>
</table>
</form>
<script>window.parent.document.getElementById("Progress").style.display='none';</script>
</body>
</html>
