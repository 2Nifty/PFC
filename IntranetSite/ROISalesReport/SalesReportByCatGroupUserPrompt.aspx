<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesReportByCatGroupUserPrompt.aspx.cs"
    Inherits="ROISalesReport_SalesReportByCatGroupUserPrompt" %>

<%@ Register Src="~/Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>ROI Sales Report</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>

function ValidateNumber()
{
     if (window.event.keyCode < 47 || window.event.keyCode > 58) window.event.keyCode = 0;
}

 function LoadHelp()
{
    var hwin=window.open("../Help/HelpFrame.aspx?Name=ROIReport",'ROIReport','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
    hwin.focus();
} 
function ViewReport()
{
  
    var Url = "SalesReportByCatGroup.aspx?Month="+ document.form1.ddlMonth.value + "&Year=" +  document.form1.ddlYear.value ; 
     
    var hwin=window.open(Url,"SalesReportByCatGroup" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    hwin.focus();
}

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top">
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" height="100%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                        <tr>
                            <td class="PageHead" style="height: 40px; width: 279px;">
                                <div class="LeftPadding">
                                    <div align="left" class="BannerText">
                                        ROI Sales Report
                                    </div>
                                </div>
                            </td>
                            <td class="PageHead" style="height: 40px">
                                <div class="LeftPadding">
                                    <div align="right" class="BannerText">
                                        <img src="../Common/images/close.gif" onclick="javascript:window.history.back();"
                                            style="cursor: hand" id="IMG2" /></div>
                                </div>
                            </td>
                        </tr>
                        <tr style="height:20px;"><td colspan="2"></td></tr>
                        <tr>
                            <td colspan="2">
                                <table border="0" cellspacing="0" cellpadding="1" width="100%">
                                    <tr>
                                        <td style="padding-left:10px;height: 12px;">
                                            <asp:Label ID="lblCaption" Width=80px Text= "Select Month" runat=server></asp:Label>
                                        </td>                                        
                                        <td colspan="3" style="height: 12px; width: 100%;">
                                            <table align="left">
                                                <tr>
                                                    <td>
                                                        <asp:DropDownList ID="ddlMonth" runat="server" CssClass="FormCtrl" Width="115px">
                                                            <asp:ListItem Text="January" Value="01"></asp:ListItem>
                                                            <asp:ListItem Text="February" Value="02"></asp:ListItem>
                                                            <asp:ListItem Text="March" Value="03"></asp:ListItem>
                                                            <asp:ListItem Text="April" Value="04"></asp:ListItem>
                                                            <asp:ListItem Text="May" Value="05"></asp:ListItem>
                                                            <asp:ListItem Text="June" Value="06"></asp:ListItem>
                                                            <asp:ListItem Text="July" Value="07"></asp:ListItem>
                                                            <asp:ListItem Text="August" Value="08"></asp:ListItem>
                                                            <asp:ListItem Text="September" Value="09"></asp:ListItem>
                                                            <asp:ListItem Text="October" Value="10"></asp:ListItem>
                                                            <asp:ListItem Text="November" Value="11"></asp:ListItem>
                                                            <asp:ListItem Text="December" Value="12"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                        <asp:Label ID="Label1" runat="server" Text="Year"></asp:Label></td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlYear" runat="server" CssClass="FormCtrl">
                                                        </asp:DropDownList></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr style="height:20px;"><td colspan="2"></td></tr>
                        <tr>
                            <td class="BluBg" align="left" colspan="2">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle"><img id="Img1" src="../common/images/viewReport.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;<img
                                src="Common/Images/buttons/help.gif" onclick="LoadHelp();" style="cursor: hand" /></span></div>
                            </td>
                            
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
