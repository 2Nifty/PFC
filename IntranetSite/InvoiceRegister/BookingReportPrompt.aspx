<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BookingReportPrompt.aspx.cs"
    Inherits="PFC.Intranet.BookingReportPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Invoice Analysis Prompt</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript">

    function ViewReport()
    {
        var branchID =document.form1.ddlBranch.value ;    
        var w = document.form1.ddlBranch.selectedIndex;
        var selected_text = document.form1.ddlBranch.options[w].value;    
        var branchDesc = document.form1.ddlBranch.options[w].text;    
        
        var lineType =  document.form1.ddlLineFilter.options[document.form1.ddlLineFilter.selectedIndex].value;
        var lineTypeDesc =  document.form1.ddlLineFilter.options[document.form1.ddlLineFilter.selectedIndex].text;
        
        var subTotalType = document.form1.ddlSubTotals.options[document.form1.ddlSubTotals.selectedIndex].value;
        var subTotalTypeDesc = document.form1.ddlSubTotals.options[document.form1.ddlSubTotals.selectedIndex].text;
        
        if(document.getElementById("hidEndDt").value == "" ||  document.getElementById("hidStartDt").value == "")
        {
            alert('Select beginning & end date');
        }
        else
        {              
            var Url =   "BookingReport.aspx?StartDate=" + document.getElementById("hidStartDt").value + 
                    "&EndDate=" + document.getElementById("hidEndDt").value + "&Branch=" + branchID + 
                    "&CustNo=" +  document.form1.txtCustNo.value+"&CSR="+ document.form1.txtCSR.value + 
                    "&LineType="+ lineType + "&SubTotalType="+ subTotalType + 
                    "&BranchDesc="+ branchDesc + "&LineTypeDesc="+ lineTypeDesc + 
                    "&SubTotalDesc="+ subTotalTypeDesc ;
        
            var hwnd=window.open(Url,"bookingReport" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hwnd.focus();            
        }
    }
    
    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=InvoiceReport",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
    }
    </script>

</head>
<body scroll="auto">
    <form id="form1" runat="server">
        <table width="100%">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="top">
                                <uc1:PageHeader ID="PageHeader1" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="height: 100%;">
                                <asp:ScriptManager runat="server" ID="scmPostBack">
                                </asp:ScriptManager>
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width="75%">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    Booking Report Filter Menu</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px; width: 275px;">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img src="../Common/images/close.gif" onclick="javascript:history.back();" style="cursor: hand" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table border="0" cellspacing="0" cellpadding="3">
                                                <tr id="tdRange" runat="server">
                                                    <td colspan="2" style="width: 400px; height: 20px">
                                                        <asp:UpdatePanel runat="server" ID="upPostBack">
                                                            <ContentTemplate>
                                                                <table>
                                                                    <tr>
                                                                        <td style="height: 12px; width: 165px;">
                                                                            <asp:Label ID="lblStartDt" runat="server" Text="Beginning Date" Width="93px" Font-Bold="True"
                                                                                ForeColor="Red"></asp:Label></td>
                                                                        <td>
                                                                            &nbsp;</td>
                                                                        <td>
                                                                            <asp:Label ID="lblEndDt" runat="server" Text="Ending Date" Width="67px" Font-Bold="True"
                                                                                ForeColor="Red"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 165px; height: 12px">
                                                                            <asp:Calendar ID="cldStartDt" runat="server" Visible="true" OnSelectionChanged="cldStartDt_SelectionChanged"
                                                                                Width="150px"></asp:Calendar>
                                                                            <input type="hidden" id="hidStartDt" runat="server" /></td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Calendar ID="cldEndDt" runat="server" Visible="true" OnSelectionChanged="cldEndDt_SelectionChanged"
                                                                                Width="150px"></asp:Calendar>
                                                                            <input type="hidden" id="hidEndDt" runat="server" /></td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td colspan="1" style="width: 560px; height: 20px; padding-top: 20px;" valign="top">
                                                        <table border="0" cellpadding="5" cellspacing="0" style="width: 200px;">
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Show Sub-Totals:" Width="99px"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlSubTotals" runat="server" CssClass="FormCtrl"
                                                                        Width="200px">
                                                                        <asp:ListItem Value="BranchSls">Sales Branch</asp:ListItem>
                                                                        <asp:ListItem Value="CustomerSrvcRepName">Customer Service Representative</asp:ListItem>
                                                                        <asp:ListItem Value="SellToCustomerNumber">Sell-To Customer</asp:ListItem>
                                                                        <asp:ListItem Value="OrderNo">Order Number</asp:ListItem>
                                                                        <asp:ListItem Value="1">ALL</asp:ListItem>
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label2" runat="server" Text="Branch" Font-Bold="True"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="200px">
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="CSR:  " Width="64px"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox ID="txtCSR" runat="server" CssClass="FormCtrl" Width="135px"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Customer No:" Width="79px"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox ID="txtCustNo" runat="server" CssClass="FormCtrl" Width="135px"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label3" runat="server" Text="Line Filter:" Font-Bold="True" Width="64px"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlLineFilter" runat="server" CssClass="FormCtrl"
                                                                        Width="142px">
                                                                        <asp:ListItem Value="ALL">ALL Lines</asp:ListItem>
                                                                        <asp:ListItem Value="LM">Only Low Margin Lines</asp:ListItem>
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 100%" valign="top">
                            <asp:UpdatePanel runat="server" ID="pnlStatus">
                                <ContentTemplate>
                                    <asp:Label ID="lblError" runat="server" Font-Bold="True" ForeColor="Red" Text=""
                                        Visible="false" Width="67px"></asp:Label></td>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </tr>
                        <tr>
                            <td class="BluBg" style="">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <img id="Img1" src="../common/images/viewReport.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;<img
                                            src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />&nbsp;
                                    </span>
                                </div>
                            </td>
                            <td class="BluBg">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
