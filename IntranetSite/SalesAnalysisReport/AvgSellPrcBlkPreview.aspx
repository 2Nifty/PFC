<%@ Page Language="VB" AutoEventWireup="false" CodeFile="~/SalesAnalysisReport/AvgSellPrcBlkPreview.aspx.vb" Inherits="AvgSellPrcBlkPreview" %>
<%@ Register TagPrefix="CR" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=11.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ Register Src="~/IntranetTheme/UserControls/PageHeader.ascx" TagName="Header"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Average Selling Price - Bulk</title>
    <link href="../IntranetTheme/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function LoadHelp()
        {
            window.open("ASPBHelp.aspx",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }        
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td valign="top" colspan="2">
                <uc1:Header ID="PageHeader1" runat="server" />
            </td>
        </tr>
        <tr>
            <td valign="middle" class="PageHead">
                <span class="Left5pxPadd">
                    <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Average Selling Price - Bulk Report"></asp:Label></span>
            </td>
            <td align="right" valign="middle" class="PageHead" style="padding-right: 20px; height: 40px;">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="80px" valign="middle">
                                    <img src="../IntranetTheme/Images/Buttons/help.gif" onclick="LoadHelp();" style="cursor: hand;
                                        display: block;" />
                                </td>
                                <td width="80px" valign="middle">
                                    <img id="ibtnClose" src="../IntranetTheme/Images/Buttons/Close.gif"  style="cursor:hand; display: block;" runat=server />
                                </td>
                            </tr>
                        </table>
                    </td>
        </tr>
        <tr>
           <td colspan="2"  style="padding-left:10px">                
                <CR:CrystalReportViewer ID="CrystalReportViewer1" Runat="server" AutoDataBind="True"
                    Height="947px" ReportSourceID="ASPB" Width="845px" EnableDatabaseLogonPrompt="false" HasCrystalLogo="False" 
                    HasRefreshButton="True" ReuseParameterValuesOnRefresh="true" CssClass="notice" />
                <CR:CrystalReportSource ID="ASPB" runat="server">
                    <Report FileName="AvgSellingPriceBulk.rpt">
                    </Report>
                </CR:CrystalReportSource>
            </td>
        </tr>
    </table>
    </div>
    <link href="../IntranetTheme/StyleSheet/CrystalReportStyle.css" rel="stylesheet" type="text/css" />
    </form>
</body>
</html>
