<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DailySalesReport.aspx.cs"
    Inherits="PFC.Intranet.DailySalesReports._DailySalesReport" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Daily Sales Analysis Report</title>
    <link href="../DailySalesReport/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../DailySalesReport/Common/StyleSheet/FreezeGrid.css" rel="stylesheet"
        type="text/css" />

    <script>
      function PrintReport(url)
        {
            //var url= "Sort="+document.getElementById("hidSort").value+"&Branch=" + document.form1.ddlBranch.value +'&BranchName='+document.form1.ddlBranch.options[document.form1.ddlBranch.selectedIndex].text+'&StartDate=<%= (ViewState["StartDate"] != null) ? ViewState["StartDate"].ToString().Trim() : "" %>&EndDate=<%= (ViewState["EndDate"] != null) ? ViewState["EndDate"].ToString().Trim() : "" %>';
            var hwin=window.open('DailySalesReportPreview.aspx?'+url, 'DailySalesReportPrint', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
            hwin.focus();
        }
         // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
           _DailySalesReport.DeleteExcel('DailySalesReport'+session).value
            parent.window.close();
           
       }
    function BindValue(sortExpression)
    {
       
     if(document.getElementById("hidSortExpression") !=null)
                document.getElementById("hidSortExpression").value= sortExpression;
        document.getElementById("btnSort").click();
    }
    function ShowHide(SHMode)
{
 
    if (SHMode == "Show") {
  
		document.getElementById("HideLabel").style.display = "";
		document.getElementById("LeftMenu").style.display = "";
		document.getElementById("LeftMenuContainer").style.width = "200px";	
		document.getElementById('div-datagrid').style.width='810px';
		document.getElementById('hidShowMode').value='Show';
		document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='../Common/Images/HidButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Hide');\">";		
	}
	if (SHMode== "Hide") {
		document.getElementById("HideLabel").style.display = "none";
		document.getElementById("LeftMenu").style.display = "none";
		document.getElementById("LeftMenuContainer").style.width = "28px";		
		document.getElementById('div-datagrid').style.width='980px';
		document.getElementById('hidShowMode').value='HideL';
		document.getElementById("SHButton").innerHTML = "<img ID='Show' style='cursor:hand' src='../Common/Images/ShowButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Show');\">";
		
	}	
	}
	function ShowPanel()
	{
	if(document.getElementById('leftPanel')!=null)
	{
	 document.getElementById('leftPanel').style.display='';
	 	document.getElementById("HideLabel").style.display = "";
		document.getElementById("LeftMenu").style.display = "";
	 document.getElementById('imgHide').style.display='';
	 document.getElementById('imgShow').style.display='none';
	 document.getElementById('div-datagrid').style.width='810px';
	 document.getElementById('hidShowMode').value='Show';
	 document.getElementById('LeftMenuContainer').style.width = '200px';
	 document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='../Common/Images/HidButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Hide');\">";		
	 }
	}
    </script>

</head>
<body onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr>
                <td height="5%" id="tdHeader" colspan="2">
                    <uc1:Header ID="ucHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 30px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            Daily Sales Analysis Report
                                        </td>
                                        <td align="right" style="width: 30%; padding-right: 5px;">
                                       
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                                    ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                            </td>
                                                            <td>
                                                             <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="conditional" runat="server">
                                                                 <ContentTemplate>
                                                             <asp:ImageButton runat="server" style="cursor: hand" ID="ibtnPrint" ImageUrl="~/Common/Images/Print.gif"
                                                                    ImageAlign="middle" OnClick="ibtnPrint_Click" />
                                                                  </ContentTemplate></asp:UpdatePanel>
                                                                </td>
                                                            <td>
                                                                <img align="right" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                                    src="Common/Images/Close.gif" style="cursor: hand; padding-right: 2px;" /></td>
                                                        </tr>
                                                    </table></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr id="trHead" class="PageBg">
                <td class="LeftPadding TabHead" style="height: 10px" colspan="2">
                    <asp:UpdatePanel ID="pnlBranch" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <table cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td width="25%">
                                        <asp:Label ID="lblBranch" runat="server" Text="Branch  "></asp:Label><asp:DropDownList
                                            ID="ddlBranch" runat="server" AutoPostBack="true" CssClass="FormCtrl" Width="150px"
                                            OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged">
                                        </asp:DropDownList></td>
                                        <td><asp:Label ID="lblPeriod" runat="server" Text="" ></asp:Label> </td>
                                    <td align="right">
                                        <img src="Common/Images/btn_showcal.gif" id="imgShow" onclick="ShowPanel();" />
                                        <img src="Common/Images/btn_hidecal.gif" style="display: none;" id="imgHide" onclick="javascript: document.getElementById('leftPanel').style.display='none';document.getElementById('imgShow').style.display='';this.style.display='none';document.getElementById('div-datagrid').style.width='1010px';hidShowMode.value='Hide';" /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td valign="top">
                 <asp:UpdatePanel ID="upnlCalendar" UpdateMode="conditional" RenderMode="inline" runat="server">
                        <ContentTemplate>
                    <table cellspacing="0" cellpadding="0" id="leftPanel" style="display: none;" height="523px">
                        <tr>
                            <td valign="top" style="background-color: #F4FBFD; border-right-width: 1px; border-right-style: solid;
                                border-right-color: #8CD5EA;" height="493px">
                                <table id="LeftMenuContainer" width="200" border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td class="ShowHideBarBk" id="HideLabel"><div align="right">Select Date Range</div></td>
        <td width="1" class="ShowHideBarBk"><div align="right" id="SHButton"><img ID="Hide" style="cursor:hand" src="../Common/Images/HidButton.gif" width="22" height="21" onclick="ShowHide('Hide')"></div></td>
      </tr>
      <tr valign="top">   
        </tr>
    </table>
                               <table id="LeftMenu" width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
                                        <td class="redhead Left5pxPadd">
                                            Beginning Date</td>
                                    </tr>
                                    <tr valign="top">
                                        <td width="100%" valign="top"  class="Left5pxPadd">
                                            <asp:Calendar BorderColor="#DAEEEF" ID="cldStartDt" runat="server" Visible="true" Width="100%" >
                                            </asp:Calendar>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="redhead Left5pxPadd">
                                            Ending Date</td>
                                    </tr>
                                    <tr valign="top">
                                        <td width="100%" valign="top" class="Left5pxPadd">
                                            <asp:Calendar  SelectionMode="Day" BorderColor="#DAEEEF" ID="cldEndDt" runat="server" Visible="true"
                                                Width="100%" ></asp:Calendar>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr valign="top">
                                        <td width="100%" align="center" class=" Left5pxPadd">
                                        <asp:ImageButton runat="server" ID="ibtnRunReport" ImageUrl="~/DailySalesReport/Common/Images/runreport.gif"
                                                                    ImageAlign="middle" OnClick="ibtnRunReport_Click" />
                                        </td></tr>	 
      </table>
                            </td>
                        </tr>
                    </table></ContentTemplate></asp:UpdatePanel>
                </td>
                 <td align="left" valign="top">
                 <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                    <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                        top: 0px; left: 0px; height: 493px; width: 1010px; border: 0px solid;">
                        <asp:GridView PagerSettings-Visible="false" PageSize="17" Width="1110px" ID="dvDailySales"
                            runat="server" AllowPaging="true" ShowHeader="true" ShowFooter="true"  AllowSorting="true" AutoGenerateColumns="false"
                            OnRowDataBound="dvDailySales_RowDataBound" OnSorting="dvDailySales_Sorting">
                            <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                HorizontalAlign="Center" />
                            <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White" Height="20px"
                                HorizontalAlign="Left" />
                            <AlternatingRowStyle CssClass="Left5pxPadd GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                HorizontalAlign="Left" />
                            <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                HorizontalAlign="Center" />
                                 <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9"  
                                HorizontalAlign="Center" />
                            <Columns>
                                <asp:BoundField  HeaderText="Sales Person" DataField="SalesPerson" SortExpression="SalesPerson" ItemStyle-CssClass="Left5pxPadd">
                                    <ItemStyle HorizontalAlign="Left" Width="150px"  />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle HorizontalAlign="center" Width="150px" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesDol" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesDolLB" DataFormatString="{0:#,##0.000}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesGP" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesGPPct" DataFormatString="{0:#,##0.00}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesGPDolLB" DataFormatString="{0:#,##0.000}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesOrders" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesLines" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="SalesPounds" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditDol" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right"/>
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditDolLB" DataFormatString="{0:#,##0.000}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditGP" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditGPPct" DataFormatString="{0:#,##0.00}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditGPDolLB" DataFormatString="{0:#,##0.000}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditOrders" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditLines" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="CreditPounds" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                </asp:BoundField>
                            </Columns>
                      
                        </asp:GridView>
                       <div align="center"> <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                            Visible="False"></asp:Label></div><input type="hidden" runat="server" id="hidSortExpression" />
                        <asp:Button ID="btnSort" runat="server" Text="" Style="display: none;" OnClick="btnSort_Click" />
                        <input type="hidden" runat="server" id="hidSort" />
                    </div>
                   <div id="divPager" runat="server"><uc3:pager ID="dvPager" runat="server" OnBubbleClick="Pager_PageChanged" /></div> 
                  
                    </ContentTemplate></asp:UpdatePanel>
                </td>
            </tr>
            <tr > 
             <td  class="BluBg buttonBar" colspan="2" height="20px" style="border-top:solid 1px #DAEEEF" >
                 <table cellpadding=0 cellspacing="0" style="padding-top:1px;">
                     <tr>
                         <td>
                             <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                 <ContentTemplate>
                                     <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                         runat="server" Text=""></asp:Label>
                                 </ContentTemplate>
                             </asp:UpdatePanel>
                         </td>
                         <td>
                             <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
                                 <ProgressTemplate>
                                     <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                 </ProgressTemplate>
                             </asp:UpdateProgress>
                         </td>
                     </tr>
                 </table>
             </td>
           </tr>
            <tr>
                <td colspan="2" valign=top>
                    <table width="100%">
                        <uc2:BottomFooter ID="ucFooter" Title="Daily Sales Analysis Report" runat="server" />  
                               <asp:HiddenField ID="hidShowMode" runat="server" /> 
                                <asp:HiddenField ID="hidFileName" Value="" runat="server" />                  
                    </table>
                </td>
            </tr>
        </table>
    </form>
    <script>
   if (document.getElementById('hidShowMode').value == "Show")
   {
    document.getElementById('leftPanel').style.display='';
    document.getElementById('imgHide').style.display='';
    document.getElementById('imgShow').style.display='none';
    document.getElementById('div-datagrid').style.width='830px';
    document.getElementById('hidShowMode').value='Show';
    }
    </script>
</body>
</html>
