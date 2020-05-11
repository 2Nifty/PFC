<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="CustNextYearBudgetReport.aspx.cs" EnableEventValidation="false" ValidateRequest="false" Inherits="CustNextYearBudgetReport" %>

<%@ Register Src="Common/UserControls/PFCTextBoxControl.ascx" TagName="PFCTextBox" TagPrefix="uc4" %>
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
				var status = "";
        status = CustNextYearBudgetReport.DeleteExcel('CustomerForecastReport'+session).value;
        parent.window.close();           
    }
    
    function ShowCatPriceSchedule(custNo)
    {
        var winHnd = window.open('../CustomerMaintenance/CatPriceSchedMaint.aspx?CustNo=' + custNo ,'CatPriceSchedMaint','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=yes','');	
        winHnd.focus();          
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
                                            Customer Sales Next Year Forecasting Maintenance</td>
                                        <td align="right" style="width: 60%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td style="padding-bottom: 2px" valign="bottom">
                                                        <asp:UpdatePanel ID="pnlBranchDesc" UpdateMode="conditional" runat="server">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td align="left">
                                                                            <asp:Label ID="Label5" runat="server" Font-Size="8pt" Text="Inside Rep:" Width="65px"></asp:Label></td>
                                                                        <td align="left" style="width: 100px">
                                                                            <asp:Label ID="lblInsideRep" runat="server" Font-Size="8pt" Width="100px"></asp:Label></td>
                                                                        <td align="left">
                                                                            <asp:Label ID="Label9" runat="server" Font-Size="8pt" Text="Branch:" Width="45px"></asp:Label></td>
                                                                        <td align="left" style="width: 100px">
                                                                            <asp:Label ID="lblBranch" runat="server" Font-Size="8pt" Width="120px"></asp:Label></td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td class="TabHead" style="padding-bottom: 2px" valign="bottom">
                                                        <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter="20" DynamicLayout="false">
                                                            <ProgressTemplate>
                                                                <span style="padding-left: 5px; font-weight: bold; padding-top: 0px; color: Red;">Loading...</span>
                                                            </ProgressTemplate>
                                                        </asp:UpdateProgress>
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/InvoiceRegister/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                        <asp:Button ID="btnDummy" runat="server" Style="display: none;" OnClientClick="javascript:return false;" />
                                                    </td>
                                                    <td>
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
                <td colspan="2" align="left" valign="top" class="GridBorderAll" height="260">
                    <asp:UpdatePanel ID="upnlCustomerGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <asp:GridView PagerSettings-Visible="false" ID="gvCustBudget" runat="server" AutoGenerateColumns="False"
                                AllowPaging="True" OnRowDataBound="gvCustBudget_RowDataBound" PageSize="1" ShowHeader="False">
                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                    HorizontalAlign="Center" Width="70px" />
                                <RowStyle CssClass="GridItem Right5pxPadd" BackColor="White" BorderColor="White"
                                    Height="19px" HorizontalAlign="Right" />
                                <AlternatingRowStyle CssClass="GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                    HorizontalAlign="Right" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                    HorizontalAlign="Right" />
                                <EmptyDataRowStyle VerticalAlign="Top" BorderWidth="0px" CssClass="GridHead" BackColor="#DFF3F9"
                                    HorizontalAlign="Right" />
                                <PagerSettings Visible="False" />
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td align="left" class="PageBg" valign="middle">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="TabHead" style="padding-left: 5px;">
                                                            <tr>
                                                                <td colspan="4" valign="middle">
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td align="left">
                                                                                <asp:Label ID="lblCustNo" Style="cursor: hand;" Font-Size="Large" runat="server"
                                                                                    Text='<%#DataBinder.Eval(Container, "DataItem.CustNo")%>' Width="55px" Height="20px"
                                                                                    ToolTip="Click here to view category price schedule."></asp:Label></td>
                                                                            <td style="padding-left: 10px;">
                                                                                <asp:Label ID="lblCustName" Font-Size="Large" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.CustName")%>'
                                                                                    Width="450px" Height="20px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td>
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="Label4" runat="server" Text="Outside Rep:" Width="73px"></asp:Label></td>
                                                                            <td>
                                                                                <asp:Label ID="lblOutsideRep" Text='<%#DataBinder.Eval(Container, "DataItem.OutsideSalesRep")%>'
                                                                                    runat="server" Width="100px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td>
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="Label8" runat="server" Text="Inside Rep:" Width="73px"></asp:Label></td>
                                                                            <td>
                                                                                <asp:Label ID="lblgvInsideSalesRep" Text='<%#DataBinder.Eval(Container, "DataItem.InsideSalesRep")%>'
                                                                                    runat="server" Width="120px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="middle" style="height: 20px;">
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="Label3" runat="server" Text="Credit Ind:" Width="59px"></asp:Label></td>
                                                                            <td>
                                                                                <asp:Label ID="lblCreditInd" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.CreditInd")%>'
                                                                                    Width="70px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td valign="middle">
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="Label7" runat="server" Text="Delete Status:" Width="77px"></asp:Label></td>
                                                                            <td>
                                                                                <asp:Label ID="lblDeleteStatus" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.DeleteStatus")%>'
                                                                                    Width="40px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td valign="middle">
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="Label2" runat="server" Text="Price Cd:" Width="51px"></asp:Label></td>
                                                                            <td>
                                                                                <asp:Label ID="lblPriceCd" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.PriceCd")%>'
                                                                                    Width="30px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td valign="middle">
                                                                </td>
                                                                <td valign="middle">
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="Label1" runat="server" Text="Sales Grp:" Width="60px"></asp:Label></td>
                                                                            <td>
                                                                                <asp:Label ID="lblSalesGrp" Text='<%#DataBinder.Eval(Container, "DataItem.SalTerritoryDesc")%>'
                                                                                    runat="server" Width="170px"></asp:Label>
                                                                                <asp:HiddenField ID="hidBranchName" runat="server" Value='<%#DataBinder.Eval(Container, "DataItem.LocName")%>' />
                                                                                <asp:HiddenField ID="hidBranchId" runat="server" Value='<%#DataBinder.Eval(Container, "DataItem.LocID")%>' />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td valign="middle">
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="Label6" runat="server" Text="Chain:" Width="39px"></asp:Label></td>
                                                                            <td>
                                                                                <asp:Label ID="lblChainCd" Text='<%#DataBinder.Eval(Container, "DataItem.ChainCd")%>'
                                                                                    runat="server" Width="150px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <asp:Table BorderStyle="None" BorderWidth="0px" ID="tblCustBudget" runat="server"
                                                            Height="180px" CellPadding="0" CellSpacing="0" Font-Bold="true">
                                                            <asp:TableHeaderRow runat="server">
                                                                <asp:TableHeaderCell CssClass="GridHeadLine" HorizontalAlign="Center" Width="80px"
                                                                    runat="server">Fiscal Year</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell CssClass="GridHeadLine" HorizontalAlign="Center" Width="60px"
                                                                    runat="server">Type</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Sep</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Oct</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Nov</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Dec</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Jan</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Feb</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Mar</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Apr</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">May</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Jun</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Jul</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="62px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Aug</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="75px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Annual</asp:TableHeaderCell>
                                                                <asp:TableHeaderCell Width="58px" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                                    runat="server">Growth %</asp:TableHeaderCell>
                                                            </asp:TableHeaderRow>
                                                            <asp:TableRow runat="server" CssClass="GridBottomLine">
                                                                <asp:TableCell ID="tdDolYear1" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                                    Text="2010" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="tdDolYear1Type" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                                    Text="Actual" runat="server"></asp:TableCell>
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
                                                            <asp:TableRow runat="server">
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
                                                                    Text="0.0" runat="server"></asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow runat="server">
                                                                <asp:TableCell CssClass="GridBottomLine" ID="tdDolYear3" HorizontalAlign="Center"
                                                                    Text="2011" runat="server"></asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell63" HorizontalAlign="Left"
                                                                    runat="server">                                            
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell57" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <asp:HiddenField ID="hidLYpCustSalForecastId" runat="server" Value="" />
                                                                    <asp:HiddenField ID="hidpCustSalForecastId" runat="server" Value="" />
                                                                    <uc4:PFCTextBox ID="txtDolFYearSep" OnBubbleClick="txtDolFYearSep_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell58" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearOct" OnBubbleClick="txtDolFYearOct_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell59" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearNov" OnBubbleClick="txtDolFYearNov_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell60" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearDec" OnBubbleClick="txtDolFYearDec_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell61" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearJan" OnBubbleClick="txtDolFYearJan_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell62" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearFeb" OnBubbleClick="txtDolFYearFeb_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell64" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearMar" OnBubbleClick="txtDolFYearMar_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell65" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearApr" OnBubbleClick="txtDolFYearApr_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell66" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearMay" OnBubbleClick="txtDolFYearMay_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell67" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearJun" OnBubbleClick="txtDolFYearJun_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell68" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearJul" OnBubbleClick="txtDolFYearJul_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell69" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearAug" OnBubbleClick="txtDolFYearAug_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell ID="tdDolFYearAnnual" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell71" HorizontalAlign="Center"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtDolFYearGrowthPct" TextAlign="Center" OnBubbleClick="txtDolFYearGrowthPct_TextChanged"
                                                                        CssClass="FormCtrl2" Width="35" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                            </asp:TableRow>
                                                            <asp:TableRow ID="trEmptyLine1" runat="server">
                                                                <asp:TableCell ID="TableCell79" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                                    Text="" runat="server"></asp:TableCell>
                                                                <asp:TableCell ID="TableCell80" CssClass="GridBottomLine" HorizontalAlign="Left"
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
                                                            <asp:TableRow runat="server">
                                                                <asp:TableCell HorizontalAlign="center" runat="server" CssClass="GridBottomLine">2010</asp:TableCell>
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
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell31" HorizontalAlign="Center"
                                                                    Text="2012" runat="server"></asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell32" HorizontalAlign="Left"
                                                                    Text="F-GM Pct" runat="server"></asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell33" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearSep" OnBubbleClick="txtPctFYearSep_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell34" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearOct" OnBubbleClick="txtPctFYearOct_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell35" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearNov" OnBubbleClick="txtPctFYearNov_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell36" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearDec" OnBubbleClick="txtPctFYearDec_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell37" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearJan" OnBubbleClick="txtPctFYearJan_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell38" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearFeb" OnBubbleClick="txtPctFYearFeb_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell39" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearMar" OnBubbleClick="txtPctFYearMar_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell40" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearApr" OnBubbleClick="txtPctFYearApr_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell41" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearMay" OnBubbleClick="txtPctFYearMay_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell42" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearJun" OnBubbleClick="txtPctFYearJun_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell43" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearJul" OnBubbleClick="txtPctFYearJul_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell44" HorizontalAlign="Right"
                                                                    runat="server">
                                                                    <uc4:PFCTextBox ID="txtPctFYearAug" OnBubbleClick="txtPctFYearAug_TextChanged" CssClass="FormCtrl2"
                                                                        Width="50" runat="server" Validation="AllowDecimals" />
                                                                </asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell45" HorizontalAlign="Right"
                                                                    Text="0" runat="server"></asp:TableCell>
                                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell72" HorizontalAlign="Center"
                                                                    runat="server"></asp:TableCell>
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
                <td align="left" colspan="2" height="320" valign="top" style="padding-top: 1px; background-color: White;"
                    class="GridBorderAll" runat="server" id="tdBranchPanel">
                    <asp:UpdatePanel ID="pnlBranchGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                <tr>
                                    <td class="BluBg" style="height: 30px;" id="tdBranchGridHdr" runat="server">
                                        <table border="0" cellpadding="0" cellspacing="0" class="TabHead" style="padding-left: 5px;">
                                            <tr>
                                                <td colspan="2" valign="middle">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left">
                                                                <asp:Label ID="lblBranchCaption" Font-Size="Large" runat="server" Width="755px" Height="22px"></asp:Label></td>
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
                                            Height="310px" CellPadding="0" CellSpacing="0" Font-Bold="true" Visible="false">
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
                                            <asp:TableRow ID="TableRowB1" runat="server" CssClass="GridBottomLine">
                                                <asp:TableCell ID="tdDolYear1" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                    Text="2010" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="tdDolYear1Type" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    Text="Actual" runat="server"></asp:TableCell>
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
                                            <asp:TableRow ID="TableRowB2" runat="server">
                                                <asp:TableCell CssClass="GridBottomLine" ID="tdDolYear2" HorizontalAlign="Center"
                                                    Text="2011" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="tdDolYear2Type" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    Text="Act Fcst" runat="server"></asp:TableCell>
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
                                            <asp:TableRow ID="TableRow3" runat="server">
                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell97" HorizontalAlign="Center"
                                                    Text="2012" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell98" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    Text="Corp Fcst" runat="server"></asp:TableCell>
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
                                            <asp:TableRow ID="TableRow4" runat="server">
                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell129" HorizontalAlign="Center"
                                                    Text="2012" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell130" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    Text="Branch Fcst" runat="server"></asp:TableCell>
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
                                            <asp:TableRow ID="TableRow5" runat="server">
                                                <asp:TableCell CssClass="GridBottomLine" ID="TableCell209" HorizontalAlign="Center"
                                                    Text="2012" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell210" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    Text="Variance Pct" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell211" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell212" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell213" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell214" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell215" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell216" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell217" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell218" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell219" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell220" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell221" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell222" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell223" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell224" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                    Text="" runat="server"></asp:TableCell>
                                            </asp:TableRow>
                                            <asp:TableRow ID="TableRowB6" runat="server">
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
                                            <asp:TableRow ID="trActPerDay" runat="server">
                                                <asp:TableCell ID="TableCell79" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                    Text="" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell80" CssClass="GridBottomLine" HorizontalAlign="Left"
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
                                            <asp:TableRow ID="trBrPerDay" runat="server">
                                                <asp:TableCell ID="TableCell70" HorizontalAlign="center" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell1" HorizontalAlign="Left" Text="Actual" runat="server"
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
                                            <asp:TableRow ID="TableEmptyRow6" runat="server">
                                                <asp:TableCell ID="TableCell225" HorizontalAlign="center" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell226" HorizontalAlign="Left" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell227" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell228" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell229" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell230" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell231" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell232" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell233" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell234" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell235" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell236" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell237" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell238" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell239" HorizontalAlign="Right" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell240" HorizontalAlign="Center" Text="" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                            </asp:TableRow>
                                            <asp:TableRow ID="TableRowB10" runat="server">
                                                <asp:TableCell ID="TableCell16" HorizontalAlign="center" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell17" HorizontalAlign="Left" Text="Act Fcst" runat="server"
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
                                                <asp:TableCell ID="TableCell114" HorizontalAlign="Left" Text="Corp Fcst" runat="server"
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
                                                <asp:TableCell ID="TableCell47" HorizontalAlign="Left" Text="Branch Fcst" runat="server"
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
                                        <asp:Table BorderStyle="None" BorderWidth="0px" ID="tblSalesRepBudget" runat="server"
                                            Height="270px" CellPadding="0" CellSpacing="0" Font-Bold="true">
                                            <asp:TableHeaderRow ID="SalesRepTableHeaderRow2" runat="server">
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell17" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                    Width="70px" runat="server">Fiscal Year</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell18" CssClass="GridHeadLine" HorizontalAlign="Center"
                                                    Width="85px" runat="server">Type</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell19" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Sep</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell20" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Oct</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell21" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Nov</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell22" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Dec</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell23" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Jan</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell24" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Feb</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell25" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Mar</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell26" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Apr</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell27" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">May</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell28" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Jun</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell29" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Jul</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell30" Width="62px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Aug</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell31" Width="75px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Annual</asp:TableHeaderCell>
                                                <asp:TableHeaderCell ID="SalesRepTableHeaderCell32" Width="58px" CssClass="GridHeadLine"
                                                    HorizontalAlign="Center" runat="server">Growth %</asp:TableHeaderCell>
                                            </asp:TableHeaderRow>
                                            <asp:TableRow ID="SalesRepTableRow11" runat="server" CssClass="GridBottomLine">
                                                <asp:TableCell ID="SalesRepTableCell176" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                    Text="2010" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell177" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    Text="Actual" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell178" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell179" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell180" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell181" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell182" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell183" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell184" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell185" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell186" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell187" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell188" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell189" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell190" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell191" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                    Text="" runat="server"></asp:TableCell>
                                            </asp:TableRow>
                                            <asp:TableRow ID="SalesRepTableRow12" runat="server">
                                                <asp:TableCell CssClass="GridBottomLine" ID="SalesRepTableCell192" HorizontalAlign="Center"
                                                    Text="2011" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell193" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    Text="A-Sales" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell194" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell195" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell196" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell197" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell198" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell199" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell200" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell201" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell202" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell203" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell204" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell205" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell206" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SalesRepTableCell207" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                    Text="0.0" runat="server"></asp:TableCell>
                                            </asp:TableRow>
                                            <asp:TableRow ID="SRepTableRow11" runat="server">
                                                <asp:TableCell CssClass="GridBottomLine" ID="SRepTableCell176" HorizontalAlign="Center"
                                                    Text="2011" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell177" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    Text="A-Sales" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell178" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell179" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell180" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell181" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell182" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell183" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell184" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell185" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell186" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell187" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell188" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell189" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell190" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    Text="0" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell191" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                    Text="" runat="server"></asp:TableCell>
                                            </asp:TableRow>
                                            <asp:TableRow ID="SRepActPerDay" runat="server">
                                                <asp:TableCell ID="TableCell241" CssClass="GridBottomLine" HorizontalAlign="Center"
                                                    Text="" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell242" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell243" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell244" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell245" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell246" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell247" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell248" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell249" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell250" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell251" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell252" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell253" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell254" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell255" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell256" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell257" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                            </asp:TableRow>
                                            <asp:TableRow ID="SRepBrFcstPerDay" runat="server">
                                                <asp:TableCell ID="TableCell258" HorizontalAlign="center" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell259" HorizontalAlign="Left" Text="Actual" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell260" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell261" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell262" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell263" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell264" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell265" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell266" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell267" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell268" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell269" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell270" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell271" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell272" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell273" HorizontalAlign="Right" Text="" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                            </asp:TableRow>                                            
                                            <asp:TableRow ID="trSRepEmptyLine1" runat="server">
                                                <asp:TableCell ID="SRepTableCell79" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    Text="" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell80" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell81" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell82" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell83" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell84" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell85" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell86" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell87" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell88" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell89" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell90" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell91" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell92" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell93" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell94" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="SRepTableCell95" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                            </asp:TableRow>
                                            <asp:TableRow runat="server">
                                                <asp:TableCell HorizontalAlign="center" runat="server" CssClass="GridBottomLine">2010</asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Left" Text="A-GM Pct" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                            </asp:TableRow>
                                            <asp:TableRow runat="server">
                                                <asp:TableCell HorizontalAlign="center" runat="server" CssClass="GridBottomLine">2011</asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Left" Text="A-GM Pct" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Right" Text="0.0" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell HorizontalAlign="Center" Text="" runat="server" CssClass="GridBottomLine"></asp:TableCell>
                                            </asp:TableRow>
                                            <asp:TableRow ID="TableRow11" runat="server">
                                                <asp:TableCell ID="TableCell176" HorizontalAlign="center" runat="server" CssClass="GridBottomLine">2011</asp:TableCell>
                                                <asp:TableCell ID="TableCell177" HorizontalAlign="Left" Text="A-GM Pct" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell178" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell179" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell180" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell181" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell182" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell183" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell184" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell185" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell186" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell187" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell188" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell189" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell190" HorizontalAlign="Right" Text="0.0" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                                <asp:TableCell ID="TableCell191" HorizontalAlign="Center" Text="" runat="server"
                                                    CssClass="GridBottomLine"></asp:TableCell>
                                            </asp:TableRow>
                                            <asp:TableRow ID="TableRow12" runat="server">
                                                <asp:TableCell ID="TableCell192" CssClass="GridBottomLine" HorizontalAlign="Left"
                                                    Text="" runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell193" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell194" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell195" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell196" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell197" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell198" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell199" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell200" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell201" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell202" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell203" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell204" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell205" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell206" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell207" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                                <asp:TableCell ID="TableCell208" CssClass="GridBottomLine" HorizontalAlign="Right"
                                                    runat="server"></asp:TableCell>
                                            </asp:TableRow>
                                        </asp:Table>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <uc2:BottomFooter ID="ucFooter" Title="Customer Sales Forecast Maintenance" runat="server" />
                    <asp:HiddenField ID="hidShowMode" runat="server" />
                    <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
