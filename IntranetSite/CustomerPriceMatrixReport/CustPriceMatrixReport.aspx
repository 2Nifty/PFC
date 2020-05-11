<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="CustPriceMatrixReport.aspx.cs"
    EnableEventValidation="false" ValidateRequest="false" Inherits="CustPricingMatrixReport" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Price Matrix Report </title>
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function PrintReport()
    {  
        var WinPrint = window.open('print.aspx','Print','height=10,width=10,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");       
    }   
    
    // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {
        CustPricingMatrixReport.DeleteExcel('CustPricingMatrixReport'+session).value
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
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="360000"
            EnablePartialRendering="true">
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
                                            Customer Price Matrix Report
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
                <td class="LeftPadding TabHead" colspan="2">
                    <asp:UpdatePanel ID="pnlBranch" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <table cellspacing="0" border="0" cellpadding="0" height="20" width="100%">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td valign="top" style="width: 250px">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left">
                                                                <asp:Label ID="Label1" runat="server" Text="Territory: " Width="55px" Height="20px"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblTerritory" runat="server" Width="200px" Height="20px"></asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>                                                
                                                <td style="padding-left: 10px; width: 250px" valign="top">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label4" runat="server" Text="Inside Rep:" Height="20px" Width="65px"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblInsideRep" runat="server" Width="200px" Height="20px"></asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>                                                
                                                <td style="padding-left: 10px; width: 250px" valign="top">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 250px;" valign="top">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label3" runat="server" Text="Outside Rep:" Width="75px" Height="20px"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblOutsideRep" runat="server" Width="200px" Height="20px"></asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 10px; width: 250px" valign="top">
                                                     <table border="0" cellpadding="0" cellspacing="0">
                                                         <tr>
                                                             <td>
                                                                 <asp:Label ID="Label7" runat="server" Height="20px" Text="Region:" Width="47px"></asp:Label></td>
                                                             <td>
                                                                 <asp:Label ID="lblRegion" runat="server" Height="20px" Width="200px"></asp:Label>
                                                             </td>
                                                         </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 10px; width: 250px" valign="top">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label2" runat="server" Height="20px" Text="Buy Group:" Width="67px"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblBuyGrp" runat="server" Height="20px" Width="200px"></asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" style="padding-right: 10px;" valign="bottom">
                                        <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter="10" DynamicLayout="false">
                                            <ProgressTemplate>
                                                <span style="padding-left: 5px; font-weight: bold; padding-top: 0px; color: Red;">Loading...</span>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 510px; width: 1018px; border: 0px solid;">
                                <asp:GridView PagerSettings-Visible="false" ID="gvQuoteMetrics" UseAccessibleHeader="true"
                                    runat="server" ShowHeader="true" ShowFooter="false" AutoGenerateColumns="true"
                                    AllowSorting="false" 
                                    AllowPaging="true" OnRowCreated="gvQuoteMetrics_RowCreated" OnRowDataBound="gvQuoteMetrics_RowDataBound">                                    
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" Width="70px" />
                                    <RowStyle CssClass="GridItem Right5pxPadd" BackColor="White" BorderColor="White" Height="19px"
                                        HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Right" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Right" />
                                    <EmptyDataRowStyle VerticalAlign="Top" BorderWidth="0px" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Right" />
                                </asp:GridView>
                                <div align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>
                                <input type="hidden" runat="server" id="hidSortExpression" />                                
                                <input type="hidden" runat="server" id="hidSort" />
                            </div>
                            <div id="divPager" runat="server">
                                <uc3:pager ID="pager" runat="server" OnBubbleClick="Pager_PageChanged" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <uc2:BottomFooter ID="ucFooter" Title="Customer Price Matrix Report" runat="server" />
                    <asp:HiddenField ID="hidShowMode" runat="server" />
                    <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
