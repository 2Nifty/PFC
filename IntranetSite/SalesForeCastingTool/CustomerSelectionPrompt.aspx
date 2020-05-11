<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerSelectionPrompt.aspx.cs"
    Inherits="SalesForeCastingTool_CustomerSelectionPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Sales Forecasting - Customer Selector</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript">
        function LoadHelp()
        {
            window.open("../Help/HelpFrame.aspx?Name=CustomerSelector",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
        }
        function ViewReport()
        {    
            var w = document.form1.ddlBranch.selectedIndex;
            var orderIndex = document.form1.ddlType.selectedIndex; 
            var reportHeaderText = document.form1.ddlBranch.options[w].text + " : " +  document.form1.ddlType.options[orderIndex].text
        
            var Url = "../SalesForeCastingTool/CustomerSelector.aspx?Branch=" + document.form1.ddlBranch.value+"&HeaderText=" +reportHeaderText + "&OrderType="+ document.form1.ddlType.options[orderIndex].text;  
            window.open(Url,"CustomerSelector" ,'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
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
                            <td width="100%" height="100%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" colspan="2">
                                            <div class="Left5pxPadd">
                                                <div align="left" class="BannerText">
                                                    Sales Forecasting - Customer Selection</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px; width: 275px;">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img src="../Common/images/close.gif" onclick="javascript:history.back();" style="cursor: hand" id="IMG2" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                               
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td colspan="2">
                                            <asp:UpdatePanel ID="upnlBranch" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <table border="0" cellspacing="0" cellpadding="3" width="300">
                                                        <tr>
                                                        <tr>
                                                            <td style="height: 28px">
                                                                <span class="LeftPadding" style="width: 100px">Branch</span></td>
                                                            <td colspan="2" style="height: 28px">
                                                                <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="190px"
                                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged">
                                                                </asp:DropDownList></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 670px">
                                                                <span class="LeftPadding" style="width: 100px">Order Type</span></td>
                                                            <td colspan="3">
                                                                <asp:DropDownList ID="ddlType" runat="server" CssClass="FormCtrl" Width="190px">
                                                                    <asp:ListItem Value="W">Warehouse</asp:ListItem>
                                                                    <asp:ListItem Value="M">Mill</asp:ListItem>
                                                                </asp:DropDownList></td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="BluBg" style="width: 1212px">
                                            <div class="LeftPadding">
                                                <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <img id="Img1" src="../common/images/viewReport.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;<img
                                                        src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />&nbsp;
                                                </span>
                                            </div>
                                        </td>
                                        <td class="BluBg" style="width: 20px">
                                        </td>
                                    </tr>
                                </table>
                    </table>
                </td>
            </tr>
    </form>
    <%--<script>
    document.getElementById("lblStatus").innerText="";
    </script>--%>
</body>
</html>
