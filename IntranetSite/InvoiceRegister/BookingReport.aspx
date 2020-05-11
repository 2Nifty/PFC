<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="BookingReport.aspx.cs" EnableEventValidation="false"
    ValidateRequest="false" Inherits="BookingReport" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Booking Report </title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <script>
 function PrintReport()
 {  
    var WinPrint = window.open('print.aspx','Print','height=10,width=10,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");
   
 }
function ShowHide(SHMode)
{
 
    if (SHMode == "Show") {
  
		document.getElementById("HideLabel").style.display = "";
		document.getElementById("LeftMenu").style.display = "";
		document.getElementById("LeftMenuContainer").style.width = "200px";	
		document.getElementById('div-datagrid').style.width='820px';
		document.getElementById('hidShowMode').value='Show';
		document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='../Common/Images/HidButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Hide');\">";		
	}
	if (SHMode== "Hide") {
		document.getElementById("HideLabel").style.display = "none";
		document.getElementById("LeftMenu").style.display = "none";
		document.getElementById("LeftMenuContainer").style.width = "28px";		
		document.getElementById('div-datagrid').style.width='985px';
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
	     document.getElementById('div-datagrid').style.width='820px';
	     document.getElementById('hidShowMode').value='Show';
	     document.getElementById('LeftMenuContainer').style.width = '200px';
	     document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='../Common/Images/HidButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Hide');\">";		
	     }
	}
   
    function BindValue(sortExpression)
    { 
    //alert(sortExpression);
        if(document.getElementById("hidSortExpression") !=null)
            document.getElementById("hidSortExpression").value= sortExpression;
        document.getElementById("btnSort").click();
    }
 function PrintReport1(url)
        {
        var url= "Sort="+document.getElementById("hidSort").value+"&Branch=" + document.form1.ddlBranch.value +'&BranchName='+document.form1.ddlBranch.options[document.form1.ddlBranch.selectedIndex].text+'&StartDate=<%= (ViewState["StartDate"] != null) ? ViewState["StartDate"].ToString().Trim() : "" %>&EndDate=<%= (ViewState["EndDate"] != null) ? ViewState["EndDate"].ToString().Trim() : "" %>';
          var hwin=window.open('InvoiceRegisterPreview.aspx?'+url, 'InvoiceRegisterPreview', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
           hwin.focus();
        }
         // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
            BookingReport.DeleteExcel('BookingReport'+session).value
            parent.window.close();
           
       }
    </script>

</head>
<body scroll="no" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout ="360000" EnablePartialRendering="true">
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
                                            Booking Report
                                        </td>
                                        <td align="right" style="width: 30%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/InvoiceRegister/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="conditional" runat="server">
                                                            <ContentTemplate>
                                                                <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnPrint" ImageUrl="~/InvoiceRegister/Common/Images/Print.gif"
                                                                    ImageAlign="middle" OnClick="ibtnPrint_Click" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td>
                                                        <img align="right" src="Common/Images/Close.gif" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            style="cursor: hand; padding-right: 2px;" />
                                                    </td>
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
            <tr id="trHead" class="PageBg">
                <td class="LeftPadding TabHead" style="height: 10px" colspan="2">
                 <asp:UpdatePanel ID="pnlBranch" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <table cellspacing="0" cellpadding="0" height="40" width="100%">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td valign="top" style="width: 270px">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left" colspan="3">
                                                    <asp:Label ID="Label1" runat="server" Text="Begin Date:" Width="65px" Height="20px"></asp:Label><asp:Label ID="lblStartDt" runat="server" Width="80px" Height="20px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3">
                                                    <asp:Label ID="Label3" runat="server" Text="End Date:" Width="55px" Height="20px"></asp:Label><asp:Label ID="lblEndDt" runat="server" Width="60px" Height="20px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1" valign="middle" style="padding-right: 5px">
                                                    <asp:Label ID="Label2" runat="server" Text="Show Sub-Totals:" Width="97px"></asp:Label></td>
                                                            <td colspan="2">
                                                                <asp:Label ID="lblSubTotalType" runat="server"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 10px; width: 270px;" valign="top">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td colspan="3" style="height: 14px">
                                                                <asp:Label ID="Label4" runat="server" Text="Branch:" Height="20px" Width="47px"></asp:Label><asp:Label ID="lblBranch" runat="server" Width="165px" Height="20px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3" valign="middle" style="padding-right: 5px">
                                                                <asp:Label ID="Label7" runat="server" Text="Line Filter:" Width="62px" Height="20px" ></asp:Label><asp:Label ID="lblLineType" runat="server" Height="20px" ></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 10px; width: 270px;" valign="top">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td style="padding-right: 5px;" align="left" colspan="2">
                                                                <asp:Label ID="Label5" runat="server" Text="CSR:  " Height="20px" Width="30px"></asp:Label><asp:Label ID="lblCSR" runat="server" Width="120px" Height="20px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left">
                                                                <asp:Label ID="Label6" runat="server" Text="Customer No:" Width="81px" Height="20px"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblCustNo" runat="server" Width="120px" Height="20px"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 10px">
                                                    <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
                                                        <ProgressTemplate>
                                                            <span style="padding-left: 5px; font-weight: bold; padding-top: 0px; color: Red;">Loading...</span>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
                                                </td>
                                                <td style="padding-left: 10px">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                  </ContentTemplate>
                </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan=2 align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 480px; width: 1018px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" PageSize="1"
                                    Width="1365px" ID="gvBranch" runat="server" AllowPaging="true" ShowHeader="false"
                                    ShowFooter="false" AllowSorting="false" AutoGenerateColumns="false" OnRowDataBound="gvBranch_RowDataBound">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White"
                                        Height="19px" HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White"
                                        Height="19px" HorizontalAlign="Left" />
                                    <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label Text="No Record Found" ID="lbldgMessage" Font-Bold="true" Visible="false"
                                                    ForeColor="red" runat="server"></asp:Label>
                                                <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" PageSize="17"
                                                    Width="1400px" ID="gvInvoiceRegister" runat="server" AllowPaging="false" ShowHeader="true"
                                                    ShowFooter="true" AllowSorting="false" AutoGenerateColumns="false" OnRowDataBound="gvInvoiceRegister_RowDataBound"
                                                    OnSorting="gvInvoiceRegister_Sorting">
                                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                                        HorizontalAlign="Center" />
                                                    <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White"
                                                        Height="19px" HorizontalAlign="Left" />
                                                    <AlternatingRowStyle CssClass="Left5pxPadd GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                                        HorizontalAlign="Left" />
                                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                                        HorizontalAlign="Center" />
                                                    <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9"
                                                        HorizontalAlign="Center" />
                                                    <Columns>
                                                        <asp:BoundField HeaderText="Post Date" DataField="PostDate" DataFormatString="{0:MM/dd/yy}"
                                                            SortExpression="PostDate" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="70px" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle HorizontalAlign="center" Width="70px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" HeaderText="Order Type" DataField="OrderType"
                                                            SortExpression="OrderType">
                                                            <ItemStyle HorizontalAlign="Center" Width="35px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="35px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="Item" HeaderText="Item" SortExpression="Item">
                                                            <ItemStyle HorizontalAlign="Left" Width="120px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Left" Width="120" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="ItemDescription" HeaderText="Item Description"
                                                            SortExpression="ItemDescription">
                                                            <ItemStyle HorizontalAlign="Left" Width="300px" Wrap="False" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="225px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="BranchSls" HeaderText="Sls" SortExpression="BranchSls">
                                                            <ItemStyle HorizontalAlign="Center" Width="25px" />
                                                            <FooterStyle HorizontalAlign="Center" />
                                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" Width="25px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="BranchShip" HeaderText="Ship" ItemStyle-HorizontalAlign="Center"
                                                            SortExpression="BranchShip">
                                                            <ItemStyle HorizontalAlign="Center" Width="25px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Center" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="Qty" HeaderText="Qty" SortExpression="Qty"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Center" Width="35px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Center" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="AltNetUnitPrice" HeaderText="Price" SortExpression="AltNetUnitPrice"
                                                            DataFormatString="{0:#,##0.00}">
                                                            <ItemStyle HorizontalAlign="Right" Width="35px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="AltNetUnitCost" HeaderText="Cost" DataFormatString="{0:#,##0.00}"
                                                            SortExpression="AltNetUnitCost">
                                                            <ItemStyle HorizontalAlign="Right" Width="35px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="ExtendedPrice" HeaderText="Price" DataFormatString="{0:#,##0.00}"
                                                            SortExpression="ExtendedPrice">
                                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="true" />
                                                            <FooterStyle HorizontalAlign="right" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="ExtendedCost" HeaderText="Cost" DataFormatString="{0:#,##0.00}"
                                                            SortExpression="ExtendedCost">
                                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="true" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="right" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="ExtendedWeight" HeaderText="Weight"
                                                            DataFormatString="{0:#,##0.00}" SortExpression="ExtendedWeight">
                                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="true" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="MarginPct" HeaderText="Margin Pct"
                                                            DataFormatString="{0:#,##0.0}" SortExpression="MarginPct">
                                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="true" HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="DisplayRplGMPct" HeaderText="RplGMPct"
                                                            DataFormatString="{0:#,##0.0}" SortExpression="DisplayRplGMPct">
                                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="true" HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="SellPerLb" HeaderText="Sell/Lb" DataFormatString="{0:#,##0.00}"
                                                            SortExpression="SellPerLb">
                                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="SellToCustomerNumber" HeaderText="Number"
                                                            SortExpression="SellToCustomerNumber">
                                                            <ItemStyle HorizontalAlign="Center" Width="70px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="SellToCustomerName" HeaderText="Sell to Customer Name"
                                                            SortExpression="SellToCustomerName">
                                                            <ItemStyle HorizontalAlign="Left" Width="200px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="200px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="OrderNo" HeaderText="Order #"
                                                            SortExpression="OrderNo">
                                                            <ItemStyle HorizontalAlign="Left" Width="110px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Left" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="110px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HtmlEncode="false" DataField="CustomerSrvcRepName" HeaderText="CSR"
                                                            SortExpression="CustomerSrvcRepName">
                                                            <ItemStyle HorizontalAlign="Left" Width="100px" />
                                                            <FooterStyle HorizontalAlign="Left" />
                                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="100px" />
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
                                                <asp:HiddenField ID="hidBranchID" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.BranchSls") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <div align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>
                                <input type="hidden" runat="server" id="hidSortExpression" />
                                <asp:Button ID="btnSort" runat="server" Text="" Style="display: none;" OnClick="btnSort_Click" />
                                <input type="hidden" runat="server" id="hidSort" />
                            </div>
                            <div id="divPager" runat="server">
                                <uc3:pager ID="dvPager" runat="server" OnBubbleClick="Pager_PageChanged" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="BluBg buttonBar" colspan="2" height="20px" style="border-top: solid 1px #DAEEEF">
                    <table cellpadding="0" cellspacing="0" style="padding-top: 1px;">
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label></ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <table width="100%">
                        <uc2:BottomFooter ID="ucFooter" Title="Booking Report " runat="server" />
                        <asp:HiddenField ID="hidShowMode" runat="server" />
                        <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                    </table>
                </td>
            </tr>
        </table>
    </form>

    <script type="text/javascript">
    if (document.getElementById('hidShowMode').value == "Show")
    {
        document.getElementById('leftPanel').style.display='';
        document.getElementById('imgHide').style.display='';
        document.getElementById('imgShow').style.display='none';
        document.getElementById('div-datagrid').style.width='800px';
        document.getElementById('hidShowMode').value='Show';
    } 
// function PrintReport(header,report )
//{
//alert('test');
//     var prtContent = "<html><head><link href='common/StyleSheet/styles.css' rel='stylesheet' type='text/css' /></head><body>"
//     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:350px;'colspan=3><h3>Invoice Register Report</h3></td></tr>";
//     prtContent = prtContent +"</table><br>"; 
//     prtContent = prtContent + header;  
//     prtContent = prtContent + report;     
//     prtContent = prtContent + "</body></html>";
//     var WinPrint = window.open('','','left=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');
//     prtContent = prtContent.replace(/BORDER-COLLAPSE: collapse;/i,"border-collapse:separate;");
//     prtContent = prtContent.replace(/BORDER-LEFT: #c9c6c6 1px solid;/i,"BORDER-LEFT: #c9c6c6 0px solid;");
//     prtContent = prtContent.replace(/BORDER-RIGHT: #c9c6c6 1px solid;/i,"BORDER-RIGHT: #c9c6c6 0px solid;");
//     prtContent = prtContent.replace(/BORDER-TOP: #c9c6c6 1px solid;/i,"BORDER-TOP: #c9c6c6 0px solid;");
//     prtContent = prtContent.replace(/BORDER-BOTTOM: #c9c6c6 1px solid;/i,"BORDER-BOTTOM: #c9c6c6 0px solid;");
//     WinPrint.document.write(prtContent);
//     WinPrint.document.close();
//     WinPrint.focus();
//     WinPrint.print();
//     WinPrint.close();
//     window.close();
//}
 
 function print_header() 
{ 
    var table = document.getElementById("dvPrint"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/g, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
} 
    </script>

</body>
</html>
