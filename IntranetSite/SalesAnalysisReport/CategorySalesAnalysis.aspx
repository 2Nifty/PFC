<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CategorySalesAnalysis.aspx.cs" Inherits="CategorySalesAnalysis" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>CategoryTrend Analysis Report</title>
    <link href="Stylesheet/Styles.css" rel="stylesheet"  type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
   <Script>
        function ShowHide(SHMode)
        {
	        if (SHMode.id == "Hide") {
		        document.getElementById("HideLabel").style.display = "none";
		        document.getElementById("LeftMenu").style.display = "none";
		        document.getElementById("LeftMenuContainer").style.width = "1";
		        document.getElementById("SHButton").innerHTML = "<img ID='Show' src='Images/ShowButton.gif' width='22' height='21' onClick='ShowHide(this)'>";
		        
	        }
	        if (SHMode.id == "ShowTopMenu") {
		        document.getElementById("TopMenu").style.display = "block";
		        document.getElementById("TopMenuControl").innerHTML = "<input name='HideTopMenu' id='HideTopMenu' type='button' class='FormButton' value='Hide this Menu' onClick='ShowHide(this)'>";
		        
	        }
	        if (SHMode.id == "HideTopMenu") {
		        document.getElementById("TopMenu").style.display = "none";
		        document.getElementById("TopMenuControl").innerHTML = "<input name='ShowTopMenu' id='ShowTopMenu' type='button' class='FormButton' value='Show this Menu' onClick='ShowHide(this)'>";
		    }
	        if (SHMode.id == "Show") {
		        document.getElementById("HideLabel").style.display = "block";
		        document.getElementById("LeftMenu").style.display = "block";
		        document.getElementById("LeftMenuContainer").style.width = "230";
		        document.getElementById("SHButton").innerHTML = "<img ID='Hide' src='Images/HidButton.gif' width='22' height='21' onClick='ShowHide(this)'>";
		       
	        }
        }
        
        //Javascript function to Show the preview page
        function PrintReport()
        {
        
            var strUrl="Month=" +'<%=Request.QueryString["Month"] %>'+
                        "&Year="+'<%=Request.QueryString["Year"]%>'+
                          "&Period=" +'<%=Request.QueryString["Period"]%>'+
                          "&CategoryFrom="+'<%=Request.QueryString["CategoryFrom"]%>'+"&CategoryTo="+'<%=Request.QueryString["CategoryTo"]%>'+
                          "&VarianceFrom="+'<%=Request.QueryString["VarianceFrom"]%>'+
                          "&VarianceTo="+'<%=Request.QueryString["VarianceTo"]%>'+
                          "&Sort="+document.getElementById("hidSort").value+
                          "&PeriodType="+document.getElementById("hidPeriod").value+
                          "&Version="+document.getElementById("hidVersion").value;

            
            window.open("CategorySalesPreview.aspx?"+strUrl,"SalesPreview" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        }
        
        
       // Javascript Function to hide the pager record details
       function Hide()
       {
            document.getElementById("TblPagerRecord").style.display='none';
       }
       
        // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
           var str=CategorySalesAnalysis.DeleteExcel('CategorySalesAnalysis'+session).value.toString();
           parent.window.close();
       }
       
</Script>

</head>
<body bottommargin=0px onload="JavaScript:Hide();">
    <form id="form1" runat="server">
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">      
  <tr>
    <td colspan="2"><table width="100%"  border="0" cellspacing="1" cellpadding="0">
      <tr>
        <td colspan="2" valign="middle" class="PageHead">
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td style="height: 26px" valign=middle><div align="left" class="LeftPadding">Category Sales Analysis</div></td>
                    
                    <td valign=middle class="TabHead">
                        <span class="TabHead"> Period Type :</span>
                        <asp:RadioButton ID="rdoDate1" runat="server" AutoPostBack=true Text="MTD " GroupName="DateGroup" OnCheckedChanged="rdoDate1_CheckedChanged"/>
                        <asp:RadioButton ID="rdoDate2" runat="server" Checked=true AutoPostBack=true Text="YTD "  GroupName="DateGroup" OnCheckedChanged="rdoDate2_CheckedChanged"/>
                    </td>
                  
                    <td  valign=middle class="TabHead">
                        <span >Report Version :</span>
                        <asp:RadioButton ID="rdoReportVersion1" runat="server" Checked=true  AutoPostBack=true Text="Long Version" GroupName="ReportVersion" OnCheckedChanged="rdoReportVersion1_CheckedChanged"/>
                        <asp:RadioButton ID="rdoReportVersion2" AutoPostBack=true Text="Short Version" runat="server" GroupName="ReportVersion" OnCheckedChanged="rdoReportVersion2_CheckedChanged"/>
                        
                    </td>
                    <td valign=middle align=right>
                        <a href='<%= GetFileURL() %>'><img  border=0 src="../common/images/ExporttoExcel.gif" /></a>
                        <img style="cursor:hand" src="../common/images/Print.gif" id="btnPrint"  onclick="javascript:PrintReport();" />
                        <img style="cursor:hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"/>
                    </td>
                    
                </tr>
            </table>
        </td>
      </tr>
      <tr>
        <td colspan=2 align="left" class="PageBg">
        <table width=100% cellpadding=0 cellspacing=0>
                <tr>
                    <td class=TabHead height="22px"><span class=LeftPadding>Category : </span><span>
                    <%=(Request.QueryString["CategoryFrom"] == "" && Request.QueryString["CategoryTo"] == "") ? "All" :Request.QueryString["CategoryFrom"].ToString()+" - " +Request.QueryString["CategoryTo"].ToString() %>
                    </span>
                    </td>
                    <td class=TabHead ><span class=LeftPadding>Variance : </span><span>
                    <%=(Request.QueryString["VarianceFrom"] == "" && Request.QueryString["VarianceTo"] == "") ? "All" : Request.QueryString["VarianceFrom"].ToString() + " - " + Request.QueryString["VarianceTo"].ToString()%>
                    </span></td>
                    <td class=TabHead ><span class=LeftPadding>Fiscal Period : </span><span><%=Request.QueryString["Period"].ToString()%></span></td>
                    <td align="left" class="TabHead"><span class="LeftPadding">Run By : <%= Session["UserName"].ToString()%></span>
                    </td>                                        

                    <td class=TabHead ><span class=LeftPadding>Run Date : </span><span><%=DateTime.Now.ToShortDateString()%></span></td>
                </tr>
            </table>
        </td>    </tr>
    <tr><td colspan=2 align=center><asp:Label ID=lblMsg ForeColor=red Visible=true runat=server CssClass="TabHead" Text="No Records Found"></asp:Label></td></tr>
      <tr>
        <td colspan="2" id=tdGrid runat=server><table class="BluBordAll" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="top">                
                    <asp:DataGrid PageSize=2 ShowHeader=false BorderWidth=0px BorderColor=#c9c6c6 PagerStyle-Visible=false  ID=dgReport AllowSorting=true 
                    AllowPaging=true AutoGenerateColumns=false runat=server  OnPageIndexChanged="dgReport_PageIndexChanged" GridLines=both>
                        <Columns>
                            <asp:TemplateColumn>
                                <ItemTemplate>
                                    <table width=100% cellpadding=0 cellspacing=0 border=0>
                                        <tr runat=server id=trHead bgcolor="#F4FBFD">
                                        <td class=TabHead  height=20 width="500">
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID=lblHead Text="Category :" runat=server CssClass=TabHead></asp:Label>
                                             <asp:Label CssClass=TabHead ID=lblCategory runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Category")%>'></asp:Label>&nbsp;
                                                 <asp:Label ID=lblItemDescription CssClass=TabHead  runat=server Text='<%#GetDescription(Container)%>'></asp:Label>
                                            </td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td colspan=2 align=left>
                                               <div id=div-datagrid class="Sbar" style="overflow: auto; position: relative; top: 0px; left: 0px; bottom:0px;
                                                width: 1000px; height: 447px; border: 0px solid;"> 
                                                <asp:DataGrid width="1100px" AutoGenerateColumns=false ID=dgAnalysis runat=server BorderWidth=1 OnItemCreated="dgAnalysis_ItemCreated" 
                                                OnItemDataBound="dgAnalysis_ItemDataBound" ShowFooter="True" GridLines=both AllowSorting="True" OnSortCommand="dgAnalysis_SortCommand" BackColor="#f4fbfd">
                                                
                                                <HeaderStyle CssClass=GridHead BackColor="#DFF3F9" HorizontalAlign="right" Wrap=False/>
                                                <ItemStyle CssClass=GridItem BackColor="#F4FBFD" HorizontalAlign="Right" Wrap=False />
                                                <AlternatingItemStyle CssClass=GridItem BackColor=White BorderWidth=0px HorizontalAlign="Right" Wrap=False />                                                   
                                                <FooterStyle CssClass=GridItem BackColor=#DFF3F9 HorizontalAlign="Right" Wrap=False />
                                                <Columns>
                                                    <asp:BoundColumn HeaderText="Brn" DataField="Brn"  SortExpression="Brn" HeaderStyle-HorizontalAlign=right FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Category" DataField="Category" SortExpression="Category" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false> </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CM_YYSales" DataFormatString="{0:#,##0}" DataField="CM_YYSales" SortExpression="CM_YYSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CM_GMPer"  DataField="CM_GMPer" SortExpression="CM_GMPer" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CM_Total" ItemStyle-Width=90  DataField="CM_Total" SortExpression="CM_Total" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderText="CM_LB"  DataField="CM_LB" DataFormatString="{0:0.00}" SortExpression="CM_LB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CM_GMLB" DataField="CM_GMLB" DataFormatString="{0:0.00}" SortExpression="CM_GMLB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CY_YYSales" DataFormatString="{0:#,##0}" DataField="CY_YYSales" SortExpression="CY_YYSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CY_GMPer"  DataField="CY_GMPer" SortExpression="CY_GMPer" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CY_Tot"   ItemStyle-Width=120 DataField="CY_Tot" SortExpression="CY_Tot" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CY_LB" DataField="CY_LB" DataFormatString="{0:0.00}" SortExpression="CY_LB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CY_GMLB" DataField="CY_GMLB" DataFormatString="{0:0.00}" SortExpression="CY_GMLB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderText="PY_YYSales" DataFormatString="{0:#,##0}" DataField="PY_YYSales"  SortExpression="PY_YYSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="PY_GMPer" DataField="PY_GMPer"  SortExpression="PY_GMPer" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="PY_Total" ItemStyle-Width=120 DataField="PY_Total" SortExpression="PY_Total" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="PY_LB" DataField="PY_LB" DataFormatString="{0:0.00}" SortExpression="PY_LB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="PY_GMLB" DataField="PY_GMLB" DataFormatString="{0:0.00}" SortExpression="PY_GMLB" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderStyle-Wrap=false></asp:BoundColumn>
                                                </Columns>
                                                </asp:DataGrid>         
                                               </div> 
                                            
                                            </td>
                                        </tr>
                                        <tr bgcolor="#F4FBFD"><td colspan=4 height=20></td></tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <PagerStyle Visible="False" />
                    </asp:DataGrid>
                
              </td>
            </tr>
        </table></td>
      </tr>
      <tr>
         <td colspan="2" width=1000px id=tdPager runat=server class="BluBg"><uc1:pager id="Pager1" runat="server"></uc1:pager></td>
      </tr>
    </table>
        <input type=hidden ID="hidSort" runat="server" />
        <input type=hidden ID="hidPeriod" runat="server" />
        <input type=hidden ID="hidVersion" runat="server" />
	  </td>
  </tr>
     
</table>
</form>
<script>window.parent.document.getElementById("Progress").style.display='none';</script>
</body>
</html>
