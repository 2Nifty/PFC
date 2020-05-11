<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="BranchBudgetReport.aspx.cs"
    EnableEventValidation="false" ValidateRequest="false" Inherits="BranchBudgetReport" %>

<%@ Register Src="Common/UserControls/PFCTextBoxControl.ascx" TagName="PFCTextBox"
    TagPrefix="uc4" %>
<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Sales Forecasting</title>
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/BudgetStyles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Common/Javascript/CustBudget.js"></script>

    <script>
    function PrintReport()
    {  
        var WinPrint = window.open('print.aspx','Print','height=10,width=10,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");       
    }   
    
    // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {
        BranchBudgetReport.DeleteExcel('BranchBudgetReport'+session).value
        parent.window.close();           
    }
    
    </script>

    <style>
    .Right5pxPadd 
    {
	    padding-Right: 10px;
    }
    </style>
</head>
<body scroll="no" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server" defaultbutton="btnDummy">
        <asp:ScriptManager ID="scmCustBudget" runat="server" AsyncPostBackTimeout="360000"
            EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr>
                <td id="tdHeader" colspan="2">
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
                                        <td class="Left5pxPadd BannerText" width="40%">
                                            Branch Sales Forecast Maintenance</td>
                                        <td align="right" style="width: 60%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td style="padding-bottom: 2px" valign="bottom">
                                                    </td>
                                                    <td class="TabHead" style="padding-bottom: 2px" valign="bottom">
                                                        <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter="20" DynamicLayout="false">
                                                            <ProgressTemplate>
                                                                <span style="padding-left: 5px; font-weight: bold; padding-top: 0px; color: Red;">Loading...</span>
                                                            </ProgressTemplate>
                                                        </asp:UpdateProgress>
                                                    </td>
                                                    <td style="padding-right:5px;">
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/InvoiceRegister/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                        <asp:Button ID="btnDummy" runat="server" Style="display: none;" OnClientClick="javascript:return false;" />
                                                    </td>
                                                    <td style="width:60px;">
                                                        <img align="right" src="../Common/Images/Close.gif" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
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
            <tr>
                <td colspan="2" align="left" valign="top" class="GridBorderAll" height="280">
                    <asp:UpdatePanel ID="upnlCustomerGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <asp:GridView PagerSettings-Visible="false" ID="gvCustBudget" runat="server" AutoGenerateColumns="False"
                                AllowPaging="True" OnRowDataBound="gvCustBudget_RowDataBound" PageSize="1" ShowHeader="False">
                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                    HorizontalAlign="Center" Width="70px" />
                                <RowStyle CssClass="GridItem Right5pxPadd" BackColor="White" BorderColor="White"
                                    Height="19px" HorizontalAlign="Right" />
                                <AlternatingRowStyle CssClass="GridItem " BackColor="White" BorderColor="White"
                                    HorizontalAlign="Right" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                    HorizontalAlign="Right" />
                                <EmptyDataRowStyle VerticalAlign="Top" BorderWidth="0px" CssClass="GridHead" BackColor="#DFF3F9"
                                    HorizontalAlign="Right" />
                                <PagerSettings Visible="False" />
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                <tr>
                                                    <td class="BluBg" align="left"  style="height: 30px;" id="tdBranchGridHdr" runat="server">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="TabHead" style="padding-left: 5px;">
                                                            <tr>
                                                                <td colspan="2">
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td align="left">
                                                                                <asp:HiddenField ID="hidBranchId" runat="server" Value='<%#DataBinder.Eval(Container, "DataItem.LocID")%>' />
                                                                                <asp:Label ID="lblBranchCaption" Text='<%#DataBinder.Eval(Container, "DataItem.LocDisp")%>'
                                                                                    Style="cursor: hand;" Font-Size="Large" runat="server" Width="755px" Height="20px"></asp:Label></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Table BorderStyle="None" BorderWidth="0px" ID="tblBranchBudget" runat="server"
                                                            Height="260px" CellPadding="0" CellSpacing="0" Font-Bold="true">
                                                            <asp:TableHeaderRow ID="TableHeaderRow1" runat="server">
                                                                <asp:TableHeaderCell ID="TableHeaderCell1" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    Width="75px" runat="server">Fiscal Year</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell2" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    Width="80px" runat="server">Type</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell3" Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Sep</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell4" Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Oct</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell5" Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Nov</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell6" Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Dec</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell7" Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Jan</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell8" Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Feb</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell9" Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Mar</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell10" Width="62px" CssClass="GridHeadLine"
                                                                    HorizontalAlign="Center" runat="server">Apr</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell11" Width="60px" CssClass="GridHeadLine"
                                                                    HorizontalAlign="Center" runat="server">May</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell12" Width="60px" CssClass="GridHeadLine"
                                                                    HorizontalAlign="Center" runat="server">Jun</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell13" Width="60px" CssClass="GridHeadLine"
                                                                    HorizontalAlign="Center" runat="server">Jul</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell14" Width="60px" CssClass="GridHeadLine"
                                                                    HorizontalAlign="Center" runat="server">Aug</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell15" Width="70px" CssClass="GridHeadLine"
                                                                    HorizontalAlign="Center" runat="server">Annual</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell ID="TableHeaderCell16" Width="53px" CssClass="GridHeadLine"
                                                                    HorizontalAlign="Center" runat="server">Growth %</asp:TableHeaderCell>
                                                            </asp:TableHeaderRow>
                                                            <asp:TableRow ID="TableRow3" runat="server" CssClass="GridBottomLine">
                                                                <asp:TableCell ID="tdDolYear1" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                                    Text="2010" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Type" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                                    Text="A-Sales" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Sep" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Oct" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Nov" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Dec" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Jan" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Feb" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Mar" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Apr" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1May" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Jun" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Jul" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Aug" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Annual" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1GrowthPct" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                                    Text="" runat="server"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="TableRow4" runat="server">
                                                                <asp:TableCell CssClass="GridBottomLine" ID="tdDolYear2" HorizontalAlign="Center"
                                                                    Text="2011" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Type" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                                    Text="A-Sales" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Sep" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Oct" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Nov" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Dec" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Jan" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Feb" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Mar" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Apr" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2May" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Jun" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Jul" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Aug" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2Annual" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear2GrowthPct" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                                    Text="" runat="server"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="TableRow5" runat="server">
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell97" HorizontalAlign="Center"
                                                                    Text="2012" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell98" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                                    Text="Fixed F-Sales" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell99" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell100" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell101" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell102" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell103" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell104" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell105" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell106" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell107" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell108" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell109" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell110" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell111" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell112" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                                    Text="" runat="server"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="TableRow7" runat="server">
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell129" HorizontalAlign="Center"
                                                                    Text="2012" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell130" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                                    Text="Branch F-Sales" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell131" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell132" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell133" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell134" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell135" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell136" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell137" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell138" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell139" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell140" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell141" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell142" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell143" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell144" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                                    Text="" runat="server"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="TableRow8" runat="server">
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell145" HorizontalAlign="Center"
                                                                    Text="2012" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell146" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                                    Text="Variance Pct" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell147" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell148" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell149" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell150" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell151" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell152" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell153" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell154" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell155" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell156" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell157" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell158" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell159" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell160" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                                    Text="" runat="server"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="trEmptyLine1" runat="server">
                                                                <asp:TableCell ID="TableCell79" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                                    Text="" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell80" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell81" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell82" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell83" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell84" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell85" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell86" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell87" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell88" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell89" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell90" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell91" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell92" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell93" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell94" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell95" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    runat="server"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="TableRow6" runat="server">
                                                                <asp:TableCell ID="TableCell70" HorizontalAlign="center" runat="server" CssClass="GridBottomLine">2010</asp:TableCell>
                                                                <asp:TableCell ID="TableCell1" HorizontalAlign="Left" Text="A-GM Pct" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell2" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell3" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell4" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell5" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell6" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell7" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell8" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell9" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell10" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell11" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell12" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell13" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell14" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell15" HorizontalAlign="Right" Text="" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="TableRow2" runat="server">
                                                                <asp:TableCell ID="TableCell16" HorizontalAlign="center" runat="server" CssClass="GridBottomLine">2011</asp:TableCell>
                                                                <asp:TableCell ID="TableCell17" HorizontalAlign="Left" Text="A-GM Pct" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell18" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell19" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell20" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell21" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell22" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell23" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell24" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell25" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell26" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell27" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell28" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell29" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell30" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell96" HorizontalAlign="Center" Text="" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="TableRow1" runat="server">
                                                                <asp:TableCell ID="TableCell113" HorizontalAlign="center" runat="server" CssClass="GridBottomLine">2012</asp:TableCell>
                                                                <asp:TableCell ID="TableCell114" HorizontalAlign="Left" Text="Fixed F-GM Pct" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell115" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell116" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell117" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell118" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell119" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell120" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell121" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell122" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell123" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell124" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell125" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell126" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell127" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell128" HorizontalAlign="Center" Text="" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="TableRow9" runat="server">
                                                                <asp:TableCell ID="TableCell46" HorizontalAlign="center" runat="server" CssClass="GridBottomLine">2012</asp:TableCell>
                                                                <asp:TableCell ID="TableCell47" HorizontalAlign="Left" Text="Branch F-GM Pct" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell48" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell49" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell50" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell51" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell52" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell53" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell54" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell55" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell56" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell73" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell74" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell75" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell76" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell77" HorizontalAlign="Center" Text="" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="TableRow10" runat="server">
                                                                <asp:TableCell ID="TableCell78" HorizontalAlign="center" runat="server" CssClass="GridBottomLine">2012</asp:TableCell>
                                                                <asp:TableCell ID="TableCell161" HorizontalAlign="Left" Text="Variance Pct" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell162" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell163" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell164" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell165" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell166" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell167" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell168" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell169" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell170" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell171" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell172" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell173" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell174" HorizontalAlign="Right" Text="0.0" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell175" HorizontalAlign="Center" Text="" runat="server"
                                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                            </asp:TableRow>
                                                        </asp:Table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <div align="center">
                                <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                    Visible="False"></asp:Label>
                            </div>
                            <input type="hidden" runat="server" id="hidSortExpression" />
                            <input type="hidden" runat="server" id="hidSort" />
                            <div id="divPager" runat="server">
                                <uc3:pager ID="pager" runat="server" OnBubbleClick="Pager_PageChanged" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <uc2:BottomFooter ID="ucFooter" Title="Branch Sales Forecast Maintenance" runat="server" />
                    <asp:HiddenField ID="hidShowMode" runat="server" />
                    <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
