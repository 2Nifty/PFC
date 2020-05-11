<%@ Page Language="C#" AutoEventWireup="true"  EnableEventValidation="false"  CodeFile="CPRBuyReport.aspx.cs" Inherits="CPRReport" %>
<%@ Register Src="../PrintUtility/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/FooterImage.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script language="javascript">  
    function OpenHelp(topic)
    {
        window.open('CPRHelp.aspx#' + topic + '','CPRHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    var WinPrint;  
    function PrintCPR2()
    {   
        var PagePath = document.getElementById("ReportPageName").value;
        WinPrint = window.open(PagePath,'CPRPrint','height=40,width=40,top=0,left=0,toolbar=0,scrollbars=yes,status=0,resizable=YES');  
        alert('Please be patient.\nPrinting reports over 20 pages can take time.\n\nWait for the Print dialog box to appear.\nSelect the printer to use, \nuse Preferences to set the layout to landscape,\nthen click the Print button.\n\nWatch for the printer icon at the bottom of the browser.\nPress OK when the printer icon goes away.');         
        WinPrint.close();
        return false;
    }
    function StartCPRPrinter()
    {   
        var PagePath = document.getElementById("ReportPageName").value;
        WinPrint = window.open("CPRPrinter.aspx",'CPRPrinter','height=300,width=500,top=0,left=0,toolbar=0,scrollbars=yes,status=0,resizable=YES');  
        return true;
    }
    </script>
    <title>CPR Report</title>
    <script src="../Common/JavaScript/Common.js" type="text/javascript"></script>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .bottomBorder {
	    font-weight: bold;
    	border-bottom-width: 1px;
	    border-bottom-style: solid;
	    border-bottom-color: black;
    }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <asp:HiddenField ID="HiddenFactor" runat="server" />
    <asp:HiddenField ID="HiddenIncludeSummQtys" runat="server" />
    <asp:HiddenField ID="VMIChain" runat="server" />
    <asp:HiddenField ID="VMIContract" runat="server" />
    <asp:HiddenField ID="VMIRun" runat="server" />
    <asp:HiddenField ID="ReportPageName" runat="server" />
    <asp:HiddenField ID="StatusFileName" runat="server" />
    <div id="userInfo" style="color:#ffffff;"  class="HeaderImagebg" >
    <table width="100%" border="0" cellspacing="0" cellpadding="0"  >
    <col width="25%" /><col width="50%" /><col width="25%" />
    <tr>
        <td>&nbsp;
        </td>
        <td align="center">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                <tr >
                    <td align="right">                        
                        <asp:Image ID="imgHeaderLeft" runat=server ImageUrl="~/Common/Images/userinfo_left.gif" Width="11" Height="25" />
                    </td>
                    <td class="userinfobg" style="padding-right:5px">
                        <asp:Image ID="lblDate" runat=server ImageUrl="~/Common/Images/clock.gif" ></asp:Image>
                    </td>
                    <td class="userinfobg" style="padding-left:1px">                        
                        <asp:Label ID="lblUserInfo" runat="server"></asp:Label>
                    </td>
                    <td align="left">
                     <asp:Image ID="Image1" runat=server ImageUrl="~/Common/Images/userinfo_right.gif" Width="11" Height="25" />
                     </td>
                </tr>
            </table>
        </td>
        <td align="right">
        <table border="0" cellspacing="0" cellpadding="0" >
          <tr >
            <td>
                <asp:ImageButton ID="ExcelImageButton" runat="server"  ImageUrl="~/Common/Images/Excel.gif" OnClick="ExcelExportButton_Click" />
                &nbsp;
            </td>
            <td>
                <uc1:PrintDialogue id="Print" runat="server">
                </uc1:PrintDialogue>
            </td>
            <td valign="middle">&nbsp;<b><a onclick="OpenHelp('Printed');" style="cursor: hand"
             title="Click Here for Help on&#013;Printing the Report">?</a></b>&nbsp;
            </td>
            <td><asp:ImageButton ID="CloseButton" runat="server" ImageUrl="~/Common/Images/Close.gif" 
            PostBackUrl="javascript:window.close();"  CausesValidation="false"
            ToolTip="Close the Report Window"/>&nbsp;&nbsp;
            <asp:LinkButton ID="LinkButton1" runat="server"></asp:LinkButton>
            </td></tr></table>
        </td>
    </tr>
    </table>
    </div>
    <div id="PrintArea">
    <table width="100%" cellpadding="0" cellspacing="0" id="KahunaTable">
        <tr>
            <td valign="top" Width="30%">
                <asp:DataGrid ID="ItemGrid" runat="server" AutoGenerateColumns="false" 
                PageSize="1" AllowPaging="true" PagerStyle-Visible="false" ShowHeader="false"
                BorderWidth="0" >
                <AlternatingItemStyle CssClass="GridItem"  BackColor="#FFFFFF" />
                <Columns>
                <asp:BoundColumn DataField="ItemNo" DataFormatString="Item {0:G}" ItemStyle-Font-Size="14"
                    ItemStyle-Width="300" ItemStyle-HorizontalAlign="left" ></asp:BoundColumn>
                </Columns>
               </asp:DataGrid>
                <asp:Panel ID="ItemPanel" runat="server" Height="80px" Width="375px" >
                <div id="PrintItemHeader">
                <table width="100%" cellpadding="0" cellspacing="0" class="GridItem">
                    <tr>
                        <td>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Description:
                        </td>
                        <td colspan="2">
                            <b><asp:Label ID="ItemDescLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Qty/UOM:
                        </td>
                        <td>
                            <b><asp:Label ID="QtyUOMLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                        <td>
                            <asp:Label ID="UOMWghtLabel" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Super Equiv:
                        </td>
                        <td>
                            <asp:Label ID="SuperEqLabel" runat="server" Text=""></asp:Label>&nbsp;&nbsp;
                            <asp:Label ID="SuperEqPcsLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td>Low Profile:
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Wgt/100:
                        </td>
                        <td>
                            <b><asp:Label ID="Wgt100Label" runat="server" Text=""></asp:Label></b>
                        </td>
                        <td>
                            <asp:Label ID="LowPalletLabel" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Factor:
                        </td>
                        <td>
                            <b><asp:Label ID="FactorLabel" runat="server" Text=""></asp:Label></b>&nbsp;&nbsp;
                            <asp:Label ID="LLTagLabel" runat="server" Text="" ForeColor="red"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="CFVLabel" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                </table>
                </div>
                </asp:Panel>
                <asp:Panel ID="VMIPanel" runat="server" Height="80px">
                <div id="PrintVMIHeader">
                <table width="100%" cellpadding="0" cellspacing="0" class=GridItem>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Customer Chain
                        </td>
                        <td>
                        <b><asp:Label ID="VMIChainLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                        <td>Contract
                        </td>
                        <td>
                        <b><asp:Label ID="VMIContractLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Effective
                        <b><asp:Label ID="VMIBegLabel" runat="server" Text=""></asp:Label></b> thru 
                        <b><asp:Label ID="VMIEndLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                        <td>Cust PO
                        </td>
                        <td>
                        <b><asp:Label ID="VMICustPOLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cross Ref #
                        </td>
                        <td>
                        <b><asp:Label ID="VMIXRefLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                        <td colspan="2">
                        <b><asp:Label ID="VMIDescLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sub Item #
                        </td>
                        <td>
                        <b><asp:Label ID="VMISubItemLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                        <td>PFC Salesperson
                        </td>
                        <td>
                        <b><asp:Label ID="VMISalesPersonLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Annual Usage Qty
                        </td>
                        <td>
                        <b><asp:Label ID="VMIUsageLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                        <td>Contact
                        </td>
                        <td>
                        <b><asp:Label ID="VMIContactLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expected GP %
                        </td>
                        <td>
                        <b><asp:Label ID="VMIGPLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                        <td>Order Method
                        </td>
                        <td>
                        <b><asp:Label ID="VMIOrderMethodLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vendor Code
                        </td>
                        <td>
                        <b><asp:Label ID="VMIVendorLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                        <td>Month Factor
                        </td>
                        <td>
                        <b><asp:Label ID="VMIFactorLabel" runat="server" Text=""></asp:Label></b>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                        <b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="CPRDataLabel" runat="server" Text="" ForeColor="Red"></asp:Label></b>
                        </td>
                    </tr>
                </table>
                </div>
                </asp:Panel>
            </td>
            <td valign="top" Width="70%">
                <asp:Panel ID="VendorPanel" runat="server" Height="120px" ScrollBars="vertical" Width="100%">
                <div id="PrintVendorData">
                <asp:GridView ID="VendorGridView" runat="server" AutoGenerateColumns="false" BorderWidth="0"  BackColor="#f4fbfd" 
                    GridLines="None" RowStyle-BorderStyle="None" RowStyle-BorderWidth="0" CssClass="GridItem" >
                <AlternatingRowStyle  BackColor="#FFFFFF" />
                <Columns>
                <asp:BoundField HeaderText="Vend" DataField="VendorName" SortExpression="VendorName" ItemStyle-Wrap="false"  
                    ItemStyle-Width="55" ItemStyle-HorizontalAlign="left" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="Rank" DataField="VendorRank" SortExpression="VendorRank" ItemStyle-Wrap="false" 
                    ItemStyle-Width="35" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="Co" DataField="CountryCode" SortExpression="CountryCode" ItemStyle-Wrap="false" 
                    ItemStyle-Width="45" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="FOB" DataField="FOB_Cost" SortExpression="FOB_Cost" ItemStyle-Wrap="false"  HtmlEncode="false"
                    ItemStyle-Width="60" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="Diff" DataField="FOB_Diff" SortExpression="FOB_Diff" ItemStyle-Wrap="false"  HtmlEncode="false"
                    ItemStyle-Width="60" DataFormatString="{0:N1}%" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="Duty" DataField="DutyRate" SortExpression="DutyRate" ItemStyle-Wrap="false"  HtmlEncode="false"
                    ItemStyle-Width="60" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="F/Lb" DataField="FOB_Wgt" SortExpression="FOB_Wgt" ItemStyle-Wrap="false"  HtmlEncode="false"
                    ItemStyle-Width="60" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="Land" DataField="Land_Cost" SortExpression="Land_Cost" ItemStyle-Wrap="false"  HtmlEncode="false"
                    ItemStyle-Width="60" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="Diff" DataField="Land_Diff" SortExpression="Land_Diff" ItemStyle-Wrap="false"  HtmlEncode="false"
                    ItemStyle-Width="60" DataFormatString="{0:N1}%" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="L/Lb" DataField="Land_Wgt" SortExpression="Land_Wgt" ItemStyle-Wrap="false"  HtmlEncode="false"
                    ItemStyle-Width="60" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="Cartons" DataField="VendorCartons" SortExpression="VendorCartons" ItemStyle-Wrap="false"  HtmlEncode="false"
                    ItemStyle-Width="60" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                </Columns>
                </asp:GridView>
                </div>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td colspan="3">
            <asp:Panel ID="CPRPanel" runat="server" Width="100%" ScrollBars="both" BorderWidth="0">
            <asp:Table ID="CPRHeadingTable" runat="server" CellPadding="0" CellSpacing="0" Width="100%">
                <asp:TableRow BackColor="#f4fbfd"  Width="100%">
                    <asp:TableCell Width="65px" HorizontalAlign="center" CssClass="bottomBorder" >BASE</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="150px">SALES AVERAGES</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="150px">3 Year Sales Mo. Avg.</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="320px">STOCK/ORDERS</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="95px">BUY</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center">NUMBER OF MONTHS</asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            <asp:GridView ID="CPRGridView" runat="server" AutoGenerateColumns="false" BorderWidth="0"  BackColor="#f4fbfd"
            GridLines="None" RowStyle-BorderStyle="None" RowStyle-BorderWidth="0" OnRowDataBound="CPRLineFormat" CssClass="GridItem" 
            HeaderStyle-VerticalAlign="Bottom" AlternatingRowStyle-BorderWidth="0">
            <AlternatingRowStyle  BackColor="#FFFFFF" />
            <Columns>
            <asp:BoundField HeaderText="Loc" DataField="LocationCode" SortExpression="LocationCode" ItemStyle-Wrap="false" 
                ItemStyle-Width="50px" ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap="false" ></asp:BoundField>
            <asp:BoundField HeaderText="SV" DataField="SVCode" SortExpression="SVCode" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" 
                ItemStyle-Width="15px" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="3 Mo" DataField="Avg3M" SortExpression="Avg3M" ItemStyle-Wrap="false"  HtmlEncode="false"
                ItemStyle-Width="50px" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="6 Mo" DataField="Avg6M" SortExpression="Avg6M" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="50px" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="30D Use" DataField="Use30D" SortExpression="Use30D" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="50px" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

            <asp:BoundField HeaderText="Prev1" DataField="Use_Year1_MoAvg" SortExpression="Use_Year1_MoAvg" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="50px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="Period Prev2" DataField="Use_Year2_MoAvg" SortExpression="Use_Year2_MoAvg" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="50px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="Prev3" DataField="Use_Year3_MoAvg" SortExpression="Use_Year3_MoAvg" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="50px" DataFormatString="{0:N0}" ItemStyle-CssClass="rightBorder" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>

            <asp:BoundField HeaderText="Avl" DataField="Avl" SortExpression="Avl" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="45px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right"  HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="Trf" DataField="Trf" SortExpression="Trf" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="45px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right"  HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="OO" DataField="OO" SortExpression="OO" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="45px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right"  HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="OW" DataField="OW" SortExpression="OW" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="45px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="OW Nxt" DataField="OWNxtQty" SortExpression="OWNxtQty" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="45px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right"  HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="OW Date" DataField="OWNxtDate" SortExpression="OWNxtDate" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="50px" DataFormatString="{0:MM/dd/yy}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="Total" DataField="TotalQty" SortExpression="TotalQty" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="45px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="Need" DataField="FcstNeed" SortExpression="FcstNeed" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="45" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="Net Buy" DataField="NetBuy" SortExpression="NetBuy" ItemStyle-Wrap="false" HtmlEncode="false"  HeaderStyle-CssClass="rightBorder"
                ItemStyle-Width="50" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right"  ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="Mos Avl" DataField="MosAvl" SortExpression="MosAvl" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="45" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="Mos Trf" DataField="MosTrf" SortExpression="MosTrf" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="45" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="Mos OO" DataField="MosOO" SortExpression="MosOO" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="45" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="Mos OW" DataField="MosOW" SortExpression="MosOW" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="45" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="Mos Total" DataField="MosTotal" SortExpression="MosTotal" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="45" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
            </Columns>
            </asp:GridView>
            <asp:GridView ID="ATotalsGridView" runat="server" AutoGenerateColumns="false" BorderWidth="0" OnRowDataBound="PosLineFormat" 
            GridLines="None" RowStyle-BorderStyle="None" RowStyle-BorderWidth="0" ShowHeader="false" CssClass="GridItem">
            <Columns>
            <asp:BoundField DataField="ATitle" ItemStyle-HorizontalAlign="right" ></asp:BoundField>
            <asp:BoundField DataField="ANetTotal" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HtmlEncode="false" ></asp:BoundField>
            </Columns>
            </asp:GridView>
            </asp:Panel>
            </td>
        </tr>
    </table>
    </div>
    <table width="100%" id="tblPager" runat="server"  cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <uc3:pager ID="Pager1"  OnBubbleClick="Pager_PageChanged"  runat="server" />
            </td>
        </tr>
    </table>
    <uc2:Footer ID="BottomFrame1" runat="server" />

    </form>
</body>
</html>
