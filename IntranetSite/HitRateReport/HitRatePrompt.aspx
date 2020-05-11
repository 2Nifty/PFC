<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HitRatePrompt.aspx.cs"
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
        
        var regionCd = document.form1.ddlRegion.options[document.form1.ddlRegion.selectedIndex].value;    
        var salesPersonCd = document.form1.ddlSalesPerson.options[document.form1.ddlSalesPerson.selectedIndex].value;
        var salesPersonName = document.form1.ddlSalesPerson.options[document.form1.ddlSalesPerson.selectedIndex].text;
        var NoOfDays = document.form1.ddlNoOfDays.options[document.form1.ddlNoOfDays.selectedIndex].value;
                     
        var Url =   "HitRateReport.aspx?RegionCd=" + regionCd + 
                    "&NoOfDays=" + NoOfDays +
                    "&SalesPersonCd=" +  salesPersonCd +
                    "&SalesPersonName=" + salesPersonName;
    
        var hwnd=window.open(Url,"HitRateReport" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        hwnd.focus();            
    
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
                                                    Hit Rate Report Menu</div>
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
                                            <asp:UpdatePanel ID="pnlDropDowns" runat="server">
                                                            <ContentTemplate>
                                                        <table border="0" cellpadding="5" cellspacing="0" style="width: 200px;">
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label2" runat="server" Text="Region:" Font-Bold="True"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlRegion" runat="server" CssClass="FormCtrl" Width="120px" AutoPostBack="True" OnSelectedIndexChanged="ddlRegion_SelectedIndexChanged">
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Sales Rep:" Width="82px"></asp:Label></td>
                                                                <td colspan="3"><asp:DropDownList ID="ddlSalesPerson" runat="server" CssClass="FormCtrl" Width="120px">
                                                                </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="No. of Days up:" Width="82px"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlNoOfDays" runat="server" CssClass="FormCtrl" Width="120px">
                                                                    <asp:ListItem Text="30 Days" Value="30"></asp:ListItem>
                                                                    <asp:ListItem Text="60 Days" Value="60"></asp:ListItem>
                                                                    <asp:ListItem Text="90 Days" Value="90"></asp:ListItem>
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                        </table>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 100%" valign="top">
                                <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                                    <ProgressTemplate>
                                        <strong>Loading...</strong>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
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
